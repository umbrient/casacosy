class KeynestApi < Api

  URI = "https://login.smoobu.com"


  def initialize; end

  def get_keys 
    response = conn.get("https://api.keynest.com/api/v3/Keys", {} ) { |req| req.headers['ApiKey'] = api_key }
    
    response = JSON.parse(response.body) if response.success?
  
    if response['ResponsePacket']['KeyList'].any? 
      response['ResponsePacket']['KeyList'].each do |key|

        apt_id = Apartment.find_by(name: key['KeyName']).id || 0

        the_key = Key.find_or_create_by({ 
          key_id: key['KeyId'],  
          name: key['KeyName'],
          store_id: key['CurrentOrLastStoreID'],
          apartment_id: apt_id
        })

        the_key.update({
          status_type: key['StatusType'],
          last_movement: key['LastMovement'],
          current_status: key['CurrentStatus'],
        })

        # get drop off codes 
        update_dropoff_codes(the_key.key_id)

        # get permanent collection codes (for back-up situations and staff)
        get_permanent_collection_codes(the_key.key_id)

      end
    end 
  end

  def update_dropoff_codes(key_id)
    response = conn.get("https://api.keynest.com/api/v3/Codes/DropOffCode/#{key_id}", {} ) { |req| req.headers['ApiKey'] = api_key }
    response = JSON.parse(response.body) if response.success?
    
    key = Key.find_by(key_id: key_id)
    return unless key

    dropoff_code = response['ResponsePacket']['DropOffCode'] || 'NA'
    key.update(drop_off_code: dropoff_code)
  end

  def generate_collection_code(args, booking)
    response = conn.post("https://api.keynest.com/api/v3/Codes/CollectionCode/LOC01", args.to_json) { |req| req.headers['ApiKey'] = api_key }
    response = JSON.parse(response.body) if response.success?

    collection_code = response['ResponsePacket']['CollectionCode']

    booking.update(keynest_code: collection_code)
  end


  def get_permanent_collection_codes(key_id)
    response = conn.get("https://api.keynest.com/api/v3/Codes/CollectionCode?KeyId=#{key_id}", {} ) { |req| req.headers['ApiKey'] = api_key }
    response = JSON.parse(response.body) if response.success?
    
    key = Key.find_by(key_id: key_id)
    return unless key

    response['ResponsePacket']['ValidCodes'].each do |code| 
      next unless code['IsPermanent']

      perm_collection_code = code['Code'] || 'NA'
      key.update(collection_code: perm_collection_code)
      break 
    end
    
  end

   private 

    def api_key 
      @api_key ||= (Rails.application.credentials.dig(:keynest_api_key) || ENV['KEYNEST_API_KEY'])
    end

end

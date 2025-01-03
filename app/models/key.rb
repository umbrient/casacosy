class Key < ApplicationRecord
  belongs_to :apartment 

  def new_code(booking) 

    date = Date.parse(booking.arrival.to_s)
    time = Time.parse(booking.check_in_time.to_s)
    
    # Combine them into a DateTime object
    combined_datetime = DateTime.new(date.year, date.month, date.day, time.hour, time.min, time.sec, time.zone)
    
    args = {
      "KeyId": self.key_id,
      "StoreId": self.store_id,
      "ExpectedCollectionUserName": booking.guest_name,
      "IsPermanentCode": false,
      "ValidFrom": combined_datetime,
      "ValidTo": combined_datetime.end_of_day
    }

    keynest_api.generate_collection_code(args, booking)
  end



  private

  def keynest_api 
    @keynest_api ||= KeynestApi.new
  end

end

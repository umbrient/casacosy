class RequestUpdator
  
  def initialize(args)
    @action = args[:action]
    @params = args[:params]
  end


  def call 
    result = self.send(@action)
    return result 
  end


  private 

  def upload_id 
    request = Request.not_expired.request.find_by(id: @params[:id])
    return unless request 
      
    request_type = request.request_type.pluralize
    date = Date.today.strftime("%Y/%B/%d")
    ext = File.extname(@params[:file].original_filename)
    
    file_name = (request.booking.guest_name || SecureRandom.alphanumeric(7).downcase)
    file_name += Time.now.strftime("%H%M%S").to_s
      
    path = "SAs/#{request_type}/#{date}/#{request.booking.apartment.name}/#{file_name}#{ext}"

    if @params[:file]
      begin
        s3 = Aws::S3::Resource.new
        obj = s3.bucket('sa-portal').object(path)
        obj.upload_file(@params[:file].path)
        
        r = Request.create({
          booking_id: request.booking.id,
          request_type: request.request_type, 
          request_action: 'Uploaded',
          notes: obj.key,
          user_id: 0
        });

        r.update(link: "/requests/#{r.id}/preview-id")

        return request.update(expired: true)
      rescue Aws::S3::Errors::ServiceError => e
        return false
      end
    else
        return false 
    end

    return false 

  end

  def pay_deposit 

    request = Request.not_expired.request.find_by(id: @params[:id])
    return unless request
    
    unless request.paid?

      # paid with stripe?
      payment_id = @params[:paymentId]
      
      # paid with third party?
      payment_id = @params[:payment_intent] if payment_id.nil?
       
      status = stripe_api.deposit_successful?(payment_id) ? 'Paid' : 'Error'
      
      Request.create({
        booking_id: request.booking.id,
        request_type: request.request_type, 
        request_action: status,
        link: "https://dashboard.stripe.com/payments/#{payment_id}",
        notes: payment_id,
        user: nil
      });
        
      return request.update(expired: true)

      return false
    end 

    return false
      
  end

  def agree_to_terms

    request = Request.not_expired.request.find_by(id: @params[:id])
    return unless request 

    output_path = Rails.root.join("tmp", "#{request.booking.reservation_id}.pdf")

    add_signature_to_pdf(@params[:file], output_path)

    request_type = request.request_type.pluralize
    date = Date.today.strftime("%Y/%B/%d")
    file_name = request.booking.guest_name || request.booking.reservation_id || SecureRandom.alphanumeric(7).downcase
      
    path = "SAs/#{request_type}/#{date}/#{request.booking.apartment.name}/#{file_name}.pdf"

    if @params[:file]
      begin
        s3 = Aws::S3::Resource.new
        obj = s3.bucket('sa-portal').object(path)
        obj.upload_file output_path
        
        r = Request.create({
          booking_id: request.booking.id,
          request_type: request.request_type, 
          request_action: 'Signed',
          notes: obj.key,
          user: nil
        });

        r.update(link: "/requests/#{r.id}/preview-terms")

        return request.update(expired: true)
      rescue Aws::S3::Errors::ServiceError => e
        return false
      end
    else
        return false 
    end

    return false 
  end

  def release_deposit
  end

  def capture_deposit
  end

  def decode_base64_image(base64_data)
    # Remove the Base64 prefix (e.g., "data:image/png;base64,")
    base64_string = base64_data.split(',')[1]
    Base64.decode64(base64_string)
  end

  def add_signature_to_pdf(base64_image, output_path)
    
    pdf_path = Rails.root.join("public", "terms.pdf")
    decoded_image = decode_base64_image(base64_image)

    Prawn::Document.generate(output_path, template: pdf_path.to_s) do |pdf| 
      pdf.go_to_page pdf.page_count
      pdf.image StringIO.new(decoded_image), at: [30, 200], width: 100
    end
  end

  def stripe_api 
    @stripe_api ||= StripeApi.new
  end

  def aws_api
    @aws_api ||= AwsApi.new
  end

end
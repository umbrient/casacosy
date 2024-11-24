class RequesterMailer < ApplicationMailer

  def id_email(request_id)
    @r = Request.find(request_id)
    return unless @r
  
    
    bootstrap_mail(
      to: 'mohamed@casacosy.co.uk',
      subject: "Booking Ref (#{@r.booking.reference_id}) Request to upload your ID"
    )
  end

  def deposit_email(request_id)
    @r = Request.find(request_id)
    return unless @r
    
    bootstrap_mail(
      to: 'mohamed@casacosy.co.uk',
      subject: "Booking Ref (#{@r.booking.reference_id}) Request to clear outstanding deposit"
    )
  end

  def terms_email(request_id)

    @r = Request.find(request_id)
    return unless @r
    
    bootstrap_mail(
      to: 'mohamed@casacosy.co.uk',
      subject: "Booking Ref (#{@r.booking.reference_id}) Request to agree to terms"
    )
  end

end

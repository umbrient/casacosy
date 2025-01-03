class RequestCreator

  
  def initialize(args, send_email = false )
    @r = Request.create(args)
    @send_email = send_email
  end


  def call 
    if @r.save
      if @r.request?
        if @send_email
          # RequesterMailer.id_email(@r.id).deliver_now if @r.id?
          # RequesterMailer.deposit_email(@r.id).deliver_now if @r.deposit?
          # RequesterMailer.terms_email(@r.id).deliver_now if @r.terms?
        end 
      end
      return true 
      
    else 
      return false 
    end
  end


end
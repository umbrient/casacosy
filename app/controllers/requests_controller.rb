class RequestsController < ApplicationController

  load_and_authorize_resource
  layout "end_user", only: [:show]

  def index 
    type = request_params[:type]
    booking_id = request_params[:booking_id]

    logs = Request.where(request_type: type, booking_id: booking_id ).order(:created_at).select(:request_action, :user_id, :link, :created_at).map do |r| 
      # -1 = Machine, 0 = Guest, >0 = User
      { 
        action: r.action_past_tense.capitalize,
        user: r.username,
        time: r.created_at.strftime("%d-%m-%y %H:%M:%S"),
        link: r.link
      }

    end

    if request 
      render json: { logs: logs }
    else 
      render json: "No recorded message"
    end
  end

  def create 
    booking = Booking.find create_params[:booking_id] 
    return unless booking 

    args = { 
      booking_id: booking.id,
      request_type: Request.request_types[create_params[:request_type]],
      request_action: create_params[:request_action],
      user_id: current_user.id
    }

    if RequestCreator.new(args, true).call
      render json: { msg: "Request created successfully." }      
    else 
      render json: { msg: "An unknown error occurred. Request was not created." }
    end 

  end

  def show

    byebug 
    
    @request = Request.find_by(id: params[:id])
    original_id = params[:id]
    reservation_id = params[:r]
    
    return render plain: "This link has expired." unless  @request
    return render plain: "This link is invalid." unless  @request.booking.reservation_id == reservation_id

    requests = @request.booking.requests.request.not_expired
    @booking = @request.booking

    @deposit_amount = 150

    if requests.id.any?
      @request = requests.id.last
      @step = 1
      @step_text = 'Upload Your ID'
    elsif requests.terms.any? 
      @request = requests.terms.last
      @step = 2
      @step_text = 'Your Signature'
    elsif requests.deposit.any?
      unless @booking.questions_answered?
        @step = 3
        @step_text = 'Any Extras?'
      else 
        @step = 4 
        @step_text = 'Pay Deposit'
        @request = requests.deposit.last
      end
    else 
      return render plain: "The student has become the master."
    end

    @booking = @request.booking

    redirect_to request_path(@request) + "?r=#{reservation_id}" if original_id != @request.id
  end

  def upload_id
    args = {
      params: params,
      action: 'upload_id'
    }
    result = RequestUpdator.new(args).call
    
    render json: { success: result }
  end 

  def preview_id
    
    @r = Request.find(params[:id])
    return unless @r
    
    @img = aws_api.get_id_link(request: @r)
    
  end

  def pay_deposit
    args = {
      params: params,
      action: 'pay_deposit'
    }

    result = RequestUpdator.new(args).call

  end

  def agree_to_terms
    args = {
      params: params,
      action: 'agree_to_terms'
    }

    result = RequestUpdator.new(args).call

    render json: { success: result }


  end

  def release_deposit
    request = Request.where(booking_id: params[:booking_id]).deposit.paid.last
    return unless request

    payment_intent = stripe_api.retrieve_payment(request.notes)

    notes = params[:notes]

    if payment_intent.status == 'requires_capture'
      payment_intent.cancel 

      Request.create({
        booking_id: request.booking.id,
        request_type: request.request_type, 
        request_action: 'Released',
        notes: notes,
        user: current_user
      });
      return render json: { success: true } 
    else 
      return render json: { success: false } 
    end
  end

  def capture_deposit 
    request = Request.deposit.paid.find_by(id: params[:id])
    return unless request

    amount = (params[:amount].to_f * 100).to_i
    payment_intent = stripe_api.capture_deposit(payment_intent_id: request.notes, amount: amount)
    notes = params[:notes]

    if payment_intent.status == 'succeeded'
      Request.create({
        booking_id: request.booking.id,
        request_type: request.request_type, 
        request_action: 'Captured',
        link: "£#{amount / 100}",
        notes: notes,
        user: current_user
      });
      return render json: { success: true } 
    else 
      return render json: { success: false } 
    end
  end

  private 

  def request_params
    params.permit(:type, :booking_id, :request_action)
  end 

  def create_params
    params.require(:request).permit(:type, :booking_id, :request_action, :notes, :request_type)
  end 

  def stripe_api 
    @stripe_api ||= StripeApi.new
  end

  def aws_api
    @aws_api ||= AwsApi.new
  end
end

class RequestsController < ApplicationController
  
  load_and_authorize_resource

  def index 
    type = request_params[:type]
    booking_id = request_params[:booking_id]

    logs = Request.where(request_type: type, booking_id: booking_id ).select(:request_action, :user_id, :created_at).map do |r| 
      # -1 = Machine, 0 = Guest, >0 = User
      { action: r.action_past_tense.capitalize, user: r.user_id > 0 ? r.user.name : (r.user_id == -1 ? 'Machine' : 'Guest'), time: r.created_at.strftime("%d-%m-%y %H:%M:%S") }

    end

    if request 
      render json: { logs: logs }
    else 
      render json: "No recorded message"
    end
  end

  def create 

    byebug 

    booking = Booking.find create_params[:booking_id] 
    return unless booking 

    r = Request.new(booking_id: booking.id, request_type: create_params[:type], request_action: create_params[:request_action], user_id: current_user.id)

    if r.save 
      render json: { msg: "Request created successfully." }
    else 
      render json: { msg: "An unknown error occurred. Request was not created." }
    end

  end


  private 


  def request_params
    params.permit(:type, :booking_id, :request_action)
  end 

  def create_params
    params.require(:request).permit(:type, :booking_id, :request_action, :notes, :request_type)
  end 
end

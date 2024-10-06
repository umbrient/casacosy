class RequestsController < ApplicationController
  
  load_and_authorize_resource

  def index 
    type = request_params[:type]
    booking_id = request_params[:booking_id]

    logs = Request.where(request_type: type, booking_id: booking_id ).select(:action, :user_id, :created_at).map do |r| 
      # -1 = Machine, 0 = Guest, >0 = User
      { action: r.action, user: r.user_id > 0 ? r.user.name : (r.user_id == -1 ? 'Machine' : 'Guest'), time: r.created_at.strftime("%d-%m-%y %H:%M:%S") }

    end

    if request 
      render json: { logs: logs }
    else 
      render json: "No recorded message"
    end

  end


  private 


  def request_params
    params.permit(:type, :booking_id)
  end 
end

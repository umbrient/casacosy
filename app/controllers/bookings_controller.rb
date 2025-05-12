class BookingsController < ApplicationController

  load_and_authorize_resource except: :create
  skip_authorization_check only: [:create]
  
  def show 
    @booking = Booking.find(params[:id])&.decorate
    @img = aws_api.get_id_link(request: @booking.requests.id.last) if @booking&.requests&.id&.last
    @terms = aws_api.get_id_link(request: @booking.requests.terms.last) if @booking&.requests&.terms&.last
    redirect_to(root_path) unless @booking
  end

  def create 
    result = smoobu_api.create_booking(booking_params)
    
    if(result.dig('id')) 
      render json: { status: 'success', msg: '' }
    else 
      render json: { status: 'error', msg: extract_validation_messages(result).join(". ") }
    end
  end


  private 

  def aws_api 
    @aws_api ||= AwsApi.new
  end

  def smoobu_api
    @smoobu_api ||= SmoobuApi.new
  end

  def booking_params 
    params.require(:booking).permit(
      :adults,
      :children,
      :arrival_time,
      :departure_time,
      :price,
      :deposit,
      :cleaning_fee,
      :notice,
      :firstname,
      :lastname,
      :apartment_id,
      :arrival,
      :departure,
      :phone,
      :email
    )
  end

  
end

class BookingsController < ApplicationController

  load_and_authorize_resource
  
  def show 
    @booking = Booking.find(params[:id])&.decorate
    @img = aws_api.get_id_link(request: @booking.requests.id.last) if @booking&.requests&.id&.last
    @terms = aws_api.get_id_link(request: @booking.requests.terms.last) if @booking&.requests&.terms&.last
    redirect_to(root_path) unless @booking
  end 


  private 

  def aws_api 
    @aws_api ||= AwsApi.new
  end
  
end

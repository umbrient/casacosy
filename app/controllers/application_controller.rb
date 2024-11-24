class ApplicationController < ActionController::Base
  check_authorization unless: :devise_controller?
  before_action :authenticate_user!
  
  rescue_from CanCan::AccessDenied do |exception|
    render plain: "This page does not exist."
  end

  rescue_from ActiveRecord::RecordNotFound do |exception|
    render plain: "This page does not exist."
  end

  def sync_bookings 
    smoobu_api.get_all_past_reservations
  end

  def sync_transactions 
    starling_api.get_transactions
  end

  def sync 
    sync_bookings
    sync_transactions
  end 


  private 

  def starling_api
    @smoobu_api ||= StarlingApi.new
  end

  def smoobu_api
    @smoobu_api ||= SmoobuApi.new
  end


end

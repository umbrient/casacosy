class ApplicationController < ActionController::Base
  check_authorization :unless => :devise_controller?
  before_action :authenticate_user!, unless: :guest?
  
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

  def sync_keys
    keynest_api.get_keys
  end

  def sync 
    sync_bookings
    sync_transactions
    sync_keys
  end 


  private 

  def guest?
    controller_name == 'guests' 
  end

  def starling_api
    @smoobu_api ||= StarlingApi.new
  end

  def smoobu_api
    @smoobu_api ||= SmoobuApi.new
  end

  def keynest_api
    @keynest_api ||= KeynestApi.new
  end


end

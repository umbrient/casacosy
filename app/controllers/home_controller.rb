class HomeController < ApplicationController
  
  before_action :authenticate_user!, :starling_api


  def index 
    # starling_api.get_transactions
    # smoobu_api.get_all_past_reservations

    @transactions = Transaction.unprocessed.settled.order(transaction_timestamp: :desc).paginate(page: params[:page], per_page: 20)

  end

  def cleans 
    @apartments = Apartment.all 
  end


  private 

  def starling_api 
    @starling_api ||= StarlingApi.new 
  end

  def smoobu_api
    @smoobu_api ||= SmoobuApi.new 
  end




end
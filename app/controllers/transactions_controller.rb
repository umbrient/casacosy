class TransactionsController < ApplicationController

  load_and_authorize_resource

  def index 
    # starling_api.get_transactions
    # smoobu_api.get_all_past_reservations

    @transactions = Transaction.unprocessed.settled.order(transaction_timestamp: :desc).paginate(page: params[:page], per_page: 20)
  end

  
end

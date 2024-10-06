class TransactionsController < ApplicationController

  load_and_authorize_resource

  def index 
    sync_transactions

    @transactions = Transaction.unprocessed.settled.order(transaction_timestamp: :desc).paginate(page: params[:page], per_page: 20)
  end  
end

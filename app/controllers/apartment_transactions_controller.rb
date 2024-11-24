class ApartmentTransactionsController < ApplicationController

  def create 
    apartment_id = params[:apartment_id]
    transaction_id = params[:transaction_id]
    expense_type_id = params[:expense_type_id]

    transaction = Transaction.find_by(id: transaction_id)
    
    return unless transaction && !transaction.processed

    at = ApartmentTransaction.create(
      apartment_id: apartment_id,
      transaction_id: transaction_id,
      amount: transaction.amount_pennies / 100
    )

    t = transaction.update(expense_type_id: expense_type_id, processed: true)

    render json: { success: true } if at && t 

  end

  def destroy 
    transaction_id = params[:transaction_id]
    transaction = Transaction.find_by id: transaction_id
    return unless transaction

    et = ExpenseType.find_by(name: 'Unrelated')
    return unless et 

    transaction.update(expense_type_id: et.id, processed: true)

    render json: { success: true } 
  end

  def create_many
    splits = params[:amounts]
    expense_type_id = params[:expense_type_id]

    return if splits.pluck('transaction_id').uniq.count > 1

    transaction_id = splits.pluck('transaction_id').uniq.first

    transaction = Transaction.find_by(id: transaction_id)

    return unless transaction && !transaction.processed

    total_amount = transaction.amount_pennies / 100

    splits_total = splits.pluck('amount').map(&:to_f).sum

    return unless splits_total.round(2) == total_amount

    splits.each do |split|
      transaction_id = split['transaction_id']
      apartment_id = split['apartment_id']
      amount = split['amount']

      next unless amount.to_f > 0

      ApartmentTransaction.create({ 
        transaction_id: transaction_id,
        apartment_id: apartment_id,
        amount: amount
      })
    end

    t = transaction.update(processed: true, expense_type_id: expense_type_id)
    
    render json: { success: true } if t 

  end
end

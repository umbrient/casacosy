class StarlingApi < Api

  URI = "https://api.starlingbank.com"

  def initialize 
    @account_id = Rails.application.credentials.dig(:starling, :account_id)
    @default_category = Rails.application.credentials.dig(:starling, :default_category)
    @bearer_token = Rails.application.credentials.dig(:starling, :bearer_token)
  end

  def get_transactions

    latest = Transaction.where(status: 'SETTLED').maximum(:transaction_timestamp) || 10.years.ago
    
    response = conn.get("/api/v2/feed/account/#{@account_id}/category/#{@default_category}", { changesSince: latest.iso8601(3) }) do |req|
      req.headers['Authorization'] = "Bearer #{@bearer_token}"
    end

    if response.success?
      transactions = JSON.parse(response.body)['feedItems']

      transactions.each do |t|

          next if Transaction.find_by(feedItemUid: t['feedItemUid'])

          Transaction.create(
            user_id: User.first.id,
            feedItemUid: t['feedItemUid'],
            amount_pennies: t['amount']['minorUnits'],
            direction: t['direction'],
            status: t['status'],
            source: t['source'],
            account_name: t['counterPartyName'],
            transaction_timestamp: t['transactionTime'],
            reference: t['reference']
          )
      end
    end

  end 

end
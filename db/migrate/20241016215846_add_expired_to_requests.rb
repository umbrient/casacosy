class AddExpiredToRequests < ActiveRecord::Migration[7.0]
  def change
    add_column :requests, :expired, :boolean, default: false
  end
end

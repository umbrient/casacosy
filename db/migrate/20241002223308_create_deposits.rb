class CreateDeposits < ActiveRecord::Migration[7.0]
  def change
    create_table :deposits do |t|
      t.integer :booking_id 
      t.string :id_status
      t.string :deposit_status
      t.string :terms_status 
      t.text :notes
      t.timestamps
    end
  end
end

class CreateRequests < ActiveRecord::Migration[7.0]
  def change
    create_table :requests do |t|
      t.integer :booking_id 
      t.string :request_type 
      t.string :action
      t.string :link 
      t.text :notes
      t.timestamps
    end
  end
end

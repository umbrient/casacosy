class CreateKeys < ActiveRecord::Migration[7.0]
  def change
    create_table :keys do |t|
      t.string :name 
      t.references :apartment
      t.integer :store_id
      t.string :key_id 
      t.string :status_type
      t.datetime :last_movement
      t.string :current_status
      t.string :drop_off_code
      t.string :collection_code
      t.timestamps
    end
  end
end


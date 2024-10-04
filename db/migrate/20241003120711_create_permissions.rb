class CreatePermissions < ActiveRecord::Migration[7.0]
  def change
    create_table :permissions do |t|
      t.integer :role_id
      t.string :controller
      t.string :action 
      t.string :misc
      t.timestamps
    end
  end
end

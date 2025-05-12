class CreateComplaints < ActiveRecord::Migration[7.0]
  def change
    create_table :complaints do |t|

      t.references :booking 
      t.string :regarding
      t.text :complaint_body
      t.timestamps
    end
  end
end

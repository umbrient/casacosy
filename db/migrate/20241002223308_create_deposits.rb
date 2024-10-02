class CreateDeposits < ActiveRecord::Migration[7.0]
  def change
    create_table :deposits do |t|

      t.timestamps
    end
  end
end

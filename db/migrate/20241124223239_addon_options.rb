class AddonOptions < ActiveRecord::Migration[7.0]
  def change
    create_table :addon_options do |t| 
      t.references :addon
    end
  end
end

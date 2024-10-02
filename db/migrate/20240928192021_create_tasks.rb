class CreateTasks < ActiveRecord::Migration[7.0]
  def change
    create_table :tasks do |t|
      t.integer :assigner_user_id 
      t.integer :assignee_user_id
      t.integer :apartment_id
      t.string :assignee_name
      t.integer :task_type_id 
      t.datetime :task_assigned
      t.datetime :task_due
      t.integer :booking_id
      t.decimal :rate_per_task
      t.string :status
      t.boolean :qa_approved_timestamp
      t.boolean :qa_approver_user_id
      t.boolean :paid 
      t.boolean :payment_acknowledged
      t.timestamps
    end
  end
end

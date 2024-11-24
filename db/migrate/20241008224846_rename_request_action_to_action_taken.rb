class RenameRequestActionToActionTaken < ActiveRecord::Migration[7.0]
  def change
    rename_column :requests, :action, :request_action
  end
end

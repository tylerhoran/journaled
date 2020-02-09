class AddIssueAlertsToUser < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :issue_alerts, :boolean, default: true
  end
end

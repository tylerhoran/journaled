class CreateJournalsUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :journals_users, id: false do |t|
      t.references :journal
      t.references :user
    end
  end
end

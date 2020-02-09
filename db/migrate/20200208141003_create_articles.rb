class CreateArticles < ActiveRecord::Migration[6.0]
  def change
    create_table :articles do |t|
      t.references :journal, null: false, foreign_key: true
      t.string :name
      t.string :author
      t.datetime :date
      t.string :doi

      t.timestamps
    end
  end
end

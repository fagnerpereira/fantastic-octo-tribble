class CreateJobs < ActiveRecord::Migration[8.1]
  def change
    create_table :jobs do |t|
      t.string :title
      t.text :description
      t.string :status, default: "open"
      t.decimal :price
      t.references :client, null: false, foreign_key: { to_table: :users }
      t.references :worker, null: true, foreign_key: { to_table: :users }

      t.timestamps
    end
  end
end

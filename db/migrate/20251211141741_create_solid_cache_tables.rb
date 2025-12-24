class CreateSolidCacheTables < ActiveRecord::Migration[8.0]
  def change
    create_table :solid_cache_entries do |t|
      t.binary :key_hash, null: false, limit: 128
      t.binary :value, null: false, limit: 524288
      t.datetime :created_at, null: false
      t.integer :byte_size, null: false
      t.index :key_hash, unique: true
    end
  end
end

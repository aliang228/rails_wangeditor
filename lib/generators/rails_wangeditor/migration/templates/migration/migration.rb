class CreateWangeditorAssets < ActiveRecord::Migration
  def self.up
    create_table :wangeditor_assets do |t|
      t.string :asset
      t.integer :file_size
      t.string :file_type
      t.integer :owner_id
      t.string :owner_type
      t.string :asset_type
      t.timestamps
    end
  end

  def self.down
    drop_table :wangeditor_assets
  end
end


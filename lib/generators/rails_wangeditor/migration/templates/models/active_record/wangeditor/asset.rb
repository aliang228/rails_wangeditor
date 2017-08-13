class Wangeditor::Asset < ActiveRecord::Base
  self.table_name = 'wangeditor_assets'
  mount_uploader :asset, Wangeditor::AssetUploader
  validates_presence_of :asset
  before_save :update_asset_attributes

  private
  def update_asset_attributes
    if asset.present? && asset_changed?
      self.file_size = asset.file.size
      self.file_type = asset.file.content_type
    end
  end
end
require 'carrierwave/mongoid'

class Wangeditor::Asset
  include Mongoid::Document
  include Mongoid::Timestamps

  field :file_size, :type => Integer
  field :file_type, :type => String
  field :owner_id, :type => Integer
  field :asset_type, :type => String

  mount_uploader :asset, Wangeditor::AssetUploader
  validates_presence_of :asset
  before_save :update_asset_attributes

  def self.collection_name
    :wangeditor_assets
  end

  private
  def update_asset_attributes
    if asset.present? && asset_changed?
      self.file_size = asset.file.size
      self.file_type = asset.file.content_type
    end
  end
end

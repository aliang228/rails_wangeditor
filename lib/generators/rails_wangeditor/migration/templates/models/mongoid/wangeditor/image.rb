class Wangeditor::Image < Wangeditor::Asset
  mount_uploader :asset, Wangeditor::ImageUploader
end
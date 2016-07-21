# encoding: utf-8

class Wangeditor::ImageUploader < Wangeditor::AssetUploader

  def extension_white_list
    EXT_NAMES[:image]
  end

end


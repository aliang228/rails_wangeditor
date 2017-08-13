# encoding: utf-8
class Wangeditor::AssetUploader < CarrierWave::Uploader::Base

  EXT_NAMES = {:image => RailsWangeditor.upload_image_ext}

  # Include RMagick or ImageScience support:
  # include CarrierWave::RMagick
  # include CarrierWave::ImageScience
  # include CarrierWave::MiniMagick

  # Choose what kind of storage to use for this uploader:
  storage :file
  # storage :fog

  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  def store_dir
    if Wangeditor::AssetUploader.save_upload_info?
      "#{RailsWangeditor.upload_store_dir}/#{model.asset_type.to_s.underscore.gsub(/(wangeditor\/)|(_uploader)/, '')}/#{model.created_at.strftime("%Y%m")}"
    else
      "#{RailsWangeditor.upload_store_dir}/#{self.class.to_s.underscore.gsub(/(wangeditor\/)|(_uploader)/, '')}/#{Time.now.strftime("%Y%m")}"
    end
  end

  def cache_dir
    "#{Rails.root}/tmp/uploads"
  end

  before :store, :remember_cache_id
  after :store, :delete_tmp_dir

  # store! nil's the cache_id after it finishes so we need to remember it for deletition
  def remember_cache_id(new_file)
    @cache_id_was = cache_id
  end

  def delete_tmp_dir(new_file)
    # make sure we don't delete other things accidentally by checking the name pattern
    if @cache_id_was.present? && @cache_id_was =~ /\A[\d]{8}\-[\d]{4}\-[\d]+\-[\d]{4}\z/
      FileUtils.rm_rf(File.join(cache_dir, @cache_id_was))
    end
  end

  def filename
    if original_filename
      @name ||= Digest::MD5.hexdigest(File.dirname(current_path)).slice(0, 12)
      "#{@name}.#{file.extension}"
    end
  end

  def self.save_upload_info?
    begin
      %w(asset image).each do |s|
        "Wangeditor::#{s.camelize}".constantize
      end
      return true
    rescue
      return false
    end
  end

end


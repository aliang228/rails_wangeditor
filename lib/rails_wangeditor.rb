require 'rails_wangeditor/engine'
require 'rails_wangeditor/helper'
require 'rails_wangeditor/active_record'
require 'carrierwave'
require 'mini_magick'

module RailsWangeditor

  mattr_accessor :upload_dir
  @@upload_dir = 'uploads'

  mattr_accessor :upload_image_ext
  @@upload_image_ext = %w[gif jpg jpeg png bmp]

  mattr_accessor :mapAk
  @@mapAk = 'TVhjYjq1ICT2qqL5LdS8mwas'

  mattr_accessor :image_resize_to_limit

  mattr_accessor :asset_url_prefix

  def self.base_path
    self.asset_url_prefix ? "#{self.asset_url_prefix}/wangeditor/" : '/assets/wangeditor/'
  end

  def self.root_path
    @root_path ||= Pathname.new(File.dirname(File.expand_path('../', __FILE__)))
  end

  def self.assets
    Dir[root_path.join('vendor/assets/javascripts/wangeditor/**', '*.{js,css}')].inject([]) do |assets, path|
      assets << Pathname.new(path).relative_path_from(root_path.join('vendor/assets/javascripts')).to_s
    end
  end

  def self.upload_store_dir
    dirs = upload_dir.gsub(/^\/+/,'').gsub(/\/+$/,'').split('/')
    dirs.each { |dir| dir.gsub!(/\W/, '') }
    dirs.delete('')
    dirs.join('/')
  end

  def self.resize_to_limit
    if !image_resize_to_limit.nil? && image_resize_to_limit.is_a?(Array)
      [image_resize_to_limit[0], image_resize_to_limit[1]]
    else
      [800, 800]
    end
  end

  def self.setup
    yield self
  end

end
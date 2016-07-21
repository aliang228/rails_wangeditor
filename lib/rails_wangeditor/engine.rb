require "rails_wangeditor"
require "rails"
require "action_controller"

module RailsWangeditor
  class Engine < Rails::Engine

    initializer "rails_wangeditor.assets_precompile" do |app|
      app.config.assets.precompile += RailsWangeditor.assets
    end

    initializer "rails_wangeditor.simple_form" do
      require "rails_wangeditor/simple_form" if Object.const_defined?("SimpleForm")
    end

    initializer "rails_wangeditor.helper_and_builder" do
      ActiveSupport.on_load :action_view do
        ActionView::Base.send(:include, RailsWangeditor::Helper)
        ActionView::Helpers::FormBuilder.send(:include, RailsWangeditor::Builder)
      end
    end

    initializer "rails_wangeditor.image_process" do
      unless RailsWangeditor.image_resize_to_limit.nil?
        Wangeditor::ImageUploader.class_eval do
          include CarrierWave::MiniMagick
          process :resize_to_limit => RailsWangeditor.resize_to_limit
        end
      end
    end
  end
end
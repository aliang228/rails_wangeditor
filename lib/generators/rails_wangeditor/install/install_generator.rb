module RailsWangeditor
  class InstallGenerator < Rails::Generators::Base
    source_root File.expand_path('../templates', __FILE__)
    desc "Install wangEditor for your application."

    def copy_wangeditor_files
      if ::Rails.version < "4.0.0"
        warn "Warning: rails_wangeditor  only support Rails4.0+!"
      else
        template "rails_wangeditor.rb", "config/initializers/rails_wangeditor.rb"
      end
    end

    def insert_or_copy_js_files
      if File.exist?('app/assets/javascripts/application.js')
        insert_into_file "app/assets/javascripts/application.js", "//= require wangEditor\n", :before => "//= require_tree ."
      else
        copy_file "application.js", "app/assets/javascripts/application.js"
      end
    end

    def insert_or_copy_css_files
      if File.exist?('app/assets/stylesheets/application.css')
        insert_into_file "app/assets/stylesheets/application.css", "*= require wangEditor/wangEditor.min\n", :before => "*= require_self"
      else
        if File.exist?('app/assets/stylesheets/application.scss')
          insert_into_file "app/assets/stylesheets/application.scss", "*= require wangEditor/wangEditor.min\n", :before => " *= require_self"
        else
          copy_file "application.css", "app/assets/stylesheets/application.css"
        end
      end
    end
  end
end
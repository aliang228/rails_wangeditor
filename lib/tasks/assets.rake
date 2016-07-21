namespace :wangeditor do
  desc "copy wangeditor assets into public folder"
  task :assets do
    puts "copying wangeditor into public/assets folder ..."
    dest_path = "#{Rails.root}/public/assets"
    FileUtils.mkdir_p dest_path
    FileUtils.cp_r "#{RailsWangeditor.root_path}/vendor/assets/stylesheets/wangEditor/fonts/", dest_path
  end
end
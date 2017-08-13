namespace :wangeditor do
  desc "copy wangeditor assets into public folder"
  task :assets do
    puts "copying wangeditor into public/fonts folder ..."
    dest_path = "#{Rails.root}/public"
    FileUtils.mkdir_p dest_path
    FileUtils.cp_r "#{RailsWangeditor.root_path}/vendor/assets/fonts/", dest_path
  end
end

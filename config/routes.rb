Rails.application.routes.draw do
  namespace :wangeditor do
    post "/upload" => "assets#create"
    get  "/filemanager" => "assets#list"
  end
end
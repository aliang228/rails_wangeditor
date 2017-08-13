Rails.application.routes.draw do
  namespace :wangeditor do
    post "/upload" => "assets#create"
  end
end
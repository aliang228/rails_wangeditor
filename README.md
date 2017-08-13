# wangEditor for Ruby on Rails  [![Gem Version](https://badge.fury.io/rb/rails_wangeditor.svg)](http://badge.fury.io/rb/rails_wangeditor)

wangEditor is an easy, fast and beautiful WYSIWYG javascript editor, visit [https://github.com/wangfupeng1988/wangEditor](https://github.com/wangfupeng1988/wangEditor) for details.
rails_wangeditor will helps your rails app integrate with wangEditor, includes images uploading.

![](http://images2015.cnblogs.com/blog/138012/201509/138012-20150910004209122-1645253022.png)


## Installation and usage

### Add this to your Gemfile

```ruby
  gem 'rails_wangeditor', '>= 0.3.1'
```

### Run "bundle" command.

```bash
  bundle
```

### Run install generator:

```bash
  rails generate rails_wangeditor:install
```

### Rails4 in production mode

In Rails 4.0, precompiling assets no longer automatically copies non-JS/CSS assets from vendor/assets and lib/assets. see https://github.com/rails/rails/pull/7968
In Rails 4.0's production mode, please run 'rake wangeditor:assets', this method just copy wangeditor into public folder.

```bash
  rake wangeditor:assets
```

### Usage:

```ruby
  1. <%= wangeditor_tag :content, 'default content value' %>
     # or <%= wangeditor_tag :content, 'default content value', :input_html =>{style: "height: 300px"} %>
```

```ruby
  2. <%= form_for @article do |f| %>
       ...
       <%= f.wangeditor :content %>
       # or <%= f.wangeditor :content, style: "height: 300px"%>
       ...
     <% end %>
```

When you need to specify the owner_id：

```ruby
<%= f.wangeditor :content, owner: @article%>
```

## SimpleForm integration

### simple_form:

```ruby
  <%= f.input :content, as: :wangeditor, :label => "正文",  :owner_id => current_user.id, :input_html => {style: "height: 300px" } %>
```

## Upload options configuration

When you run "rails generate rails_wangeditor:install", installer will copy configuration files in config/initializers folder.
You can customize some option for uploading. 

```ruby
  # Specify the subfolders in public directory.
  # You can customize it , eg: config.upload_dir = 'this/is/my/folder'
  config.upload_dir = 'uploads'

  # Allowed file types for upload.
  config.upload_image_ext = %w[gif jpg jpeg png bmp]

  # Porcess upload image size, need mini_magick
  #     before    => after
  # eg: 1600x1600 => 800x800
  #     1600x800  => 800x400
  #     400x400   => 400x400 # No Change
  # config.image_resize_to_limit = [800, 800]

```

## Asset host options configuration

```ruby
  # if you have config in your rails application like this:
  # /config/enviroments/production.rb
  #   # config.action_controller.asset_host = "http://asset.example.com"
  #   # config.assets.prefix = "assets_prefx"
  # then you should:
  #
  config.asset_url_prefix = "http://asset.example.com/assets_prefx/" if Rails.env.production?
```


## Save upload file information into database(optional)

rails_wangeditor can save upload file information into database.

### Just run migration generate, there are two ORM options for you: 1.active_record 2.mongoid, default is active_record.

```bash
  rails generate rails_wangeditor:migration
  or
  rails generate rails_wangeditor:migration -o mongoid
```

### The generator will copy model and migration to your application. When you are done, remember run rake db:migrate:

```bash
  rake db:migrate
```

### Delete uploaded files automatically (only for active_record)

You can specify the owner for uploaded files, when the owner was destroying, all the uploaded files(belongs to the owner) will be destroyed automatically.

#### 1. specify the owner_id for wangeditor

```ruby
   <%= form_for @article do |f| %>
     ...
     <%= f.wangeditor :content, :owner => @article  %>
     ...
   <% end %>
```

```ruby
Warnning: the @article must be created before this scene, the @article.id should not be empty.
```

#### 2. add has_many_wangeditor_assets in your own model

```ruby
  class Article < ActiveRecord::Base
    has_many_wangeditor_assets :attachments, :dependent => :destroy
    # has_many_wangeditor_assets :attachments, :dependent => :nullify
    # has_many_wangeditor_assets :your_name, :dependent => :destroy
  end
```

#### 3. relationship

```ruby
  article = Article.first
  article.attachments # => the article's assets uploaded by wangeditor
  asset = article.attachments.first
  asset.owner # => aritcle
```

### If you're using mongoid, please add 'gem "carrierwave-mongoid"' in your Gemfile

```ruby
  gem 'carrierwave-mongoid'
```

## Thanks
- 1.Macrow, https://github.com/Macrow/rails_kindeditor
- 2.wangfupeng1988, https://github.com/wangfupeng1988/wangEditor/

## License

MIT License.

module RailsWangeditor
  module Helper
    def wangeditor_tag(name, content = nil, options = {})
      id = sanitize_to_id(name)
      input_html = { :id => id }.merge(options.delete(:input_html) || {})
      output = ActiveSupport::SafeBuffer.new
      output << text_area_tag(name, content, input_html)
      output << javascript_tag(js_replace(id, options))
    end

    def wangeditor(name, method, options = {})
      input_html = (options.delete(:input_html) || {}).stringify_keys
      output_buffer = ActiveSupport::SafeBuffer.new
      output_buffer << build_text_area_tag(name, method, self, merge_assets_info(options), input_html)
      output_buffer << javascript_tag(js_replace(input_html['id'], options))
    end

    def merge_assets_info(options)
      owner = options.delete(:owner)
      if Wangeditor::AssetUploader.save_upload_info? && (!owner.nil?) && (!owner.id.nil?)
        begin
          owner_id = owner.id
          owner_type = owner.class.name
          options.reverse_merge!(owner_id: owner_id, owner_type: owner_type, data: {upload: wangeditor_upload_json_path(owner_id: owner_id, owner_type: owner_type)})
          return options
        end
      else
        options.reverse_merge!(data: {upload: wangeditor_upload_json_path})
      end
    end

    def wangeditor_upload_json_path(*args)
      options = args.extract_options!
      owner_id_query_string = options[:owner_id] ? "?owner_id=#{options[:owner_id]}" : ''
      owner_type_query_string = options[:owner_type] ? "&owner_type=#{options[:owner_type]}" : ''
      if owner_id_query_string == '' && owner_type_query_string == ''
        "#{main_app_root_url}wangeditor/upload"
      else
        "#{main_app_root_url}wangeditor/upload#{owner_id_query_string}#{owner_type_query_string}"
      end
    end

    private

    def main_app_root_url
      begin
        main_app_root_url = main_app.root_url.slice(0, main_app.root_url.rindex(main_app.root_path))
        if ENV['RAILS_RELATIVE_URL_ROOT']
          main_app_root_url += ENV['RAILS_RELATIVE_URL_ROOT'] + "/"
        else
          main_app_root_url += "/"
        end
      rescue
        '/'
      end
    end

    def js_replace(dom_id, options = {})
      "var E = window.wangEditor;
       var editor = new E('#{dom_id}');
       editor.customConfig.uploadImgFileName = 'imgFile';
       editor.customConfig.uploadImgServer = '#{wangeditor_upload_json_path(:owner_id => options.delete(:owner_id), :owner_type => options.delete(:owner_type))}';
       editor.create();"
    end

    def build_text_area_tag(name, method, template, options, input_html)
      if Rails.version >= '4.0.0'
        text_area_tag = ActionView::Helpers::Tags::TextArea.new(name, method, template, options)
        text_area_tag.send(:add_default_name_and_id, input_html)
        text_area_tag.render
      elsif Rails.version >= '3.1.0'
        text_area_tag = ActionView::Base::InstanceTag.new(name, method, template, options.delete(:object))
        text_area_tag.send(:add_default_name_and_id, input_html)
        text_area_tag.to_text_area_tag(input_html)
      else
        raise 'Please upgrade your Rails !'
      end
    end
  end

  module Builder
    def wangeditor(method, options = {})
      @template.send("wangeditor", @object_name, method, objectify_options(options))
    end
  end
end

#coding: utf-8
require "find"
class Wangeditor::AssetsController < ApplicationController
  skip_before_filter :verify_authenticity_token
  def create
    @imgFile, @dir = params[:imgFile]
    @dir = 'Image'
    unless @imgFile.nil?
      if Wangeditor::AssetUploader.save_upload_info? # save upload info into database
        begin
          @asset = "Wangeditor::#{@dir.camelize}".constantize.new(:asset => @imgFile)
          @asset.owner_id = params[:owner_id] ? params[:owner_id] : 0
          @asset.owner_type = params[:owner_type] ? params[:owner_type] : ''
          logger.warn '=====Warning: the owner have not been created, "delete uploaded files automatically" will not work. ====' if defined?(logger) && @asset.owner_id == 0
          @asset.asset_type = @dir
          if @asset.save
            url = @asset.asset.url
            if ENV['RAILS_RELATIVE_URL_ROOT']
              url = ENV['RAILS_RELATIVE_URL_ROOT'] + url
            end
            render :text => url
          else
            show_error(@asset.errors.full_messages)
          end
        rescue Exception => e
          show_error(e.to_s)
        end
      else # do not touch database
        begin
          uploader = "Wangeditor::#{@dir.camelize}Uploader".constantize.new
          uploader.store!(@imgFile)
          url = uploader.url
          if ENV['RAILS_RELATIVE_URL_ROOT']
            url = ENV['RAILS_RELATIVE_URL_ROOT'] + url
          end
          render :text => url
        rescue CarrierWave::UploadError => e
          show_error(e.message)
        rescue Exception => e
          show_error(e.to_s)
        end
      end
    else
      show_error("No File Selected!")
    end
  end

  private
  def show_error(msg)
    render :text => ("error|#{msg}")
  end

end
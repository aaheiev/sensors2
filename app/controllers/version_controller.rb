class VersionController < ApplicationController
  before_action :read_version, only: :show
  def show
    respond_to do |format|
      format.html
      format.json { render json: {app_version: @app_version, assembly_version: @assembly_version} }
    end
  end

  private
  def read_version
    app_version = File.read(Rails.root.join('VERSION'))
    (app_version_num,app_version_tag) = app_version.split('-')
    unless app_version_tag.to_s.strip.empty?
      app_version_tag_suffix = "-#{app_version_tag}"
    end
    @app_version = app_version_num
    assembly_version = ENV['ASSEMBLY_VERSION'] || "#{app_version_num}#{app_version_tag_suffix}.0"
    @assembly_version= assembly_version
  end
end

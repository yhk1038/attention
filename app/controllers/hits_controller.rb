class HitsController < ApplicationController
  before_action :set_organization
  before_action :set_project
  before_action :set_hit, only: :show

  # GET /hits
  # GET /hits.json
  def index
    @hits = @project.hits.order(created_at: :desc)
  end

  # GET /hits/1
  # GET /hits/1.json
  def show
  end

  private

  def set_organization
    @organization = Organization.find_by(slug: params[:organization_slug])
  end

  def set_project
    @project = @organization.projects.find_or_first(params[:project_id])
  end

  def set_hit
    @hit = Hit.find(params[:id])
  end
end

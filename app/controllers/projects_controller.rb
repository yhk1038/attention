class ProjectsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_organization, only: [:index, :create, :new]
  before_action :set_project, only: [:show, :edit, :update, :destroy]
  before_action :set_project_organization, only: [:show, :edit, :update, :destroy]

  # GET /organizations/:organization_slug/projects(.:format)
  def index
    @projects = @organization.projects.order(created_at: :desc)
  end

  # GET /projects/1
  # GET /projects/1.json
  def show
    redirect_to organization_notifications_path(@project.organization, project_id: @project.id)
  end

  # GET /organizations/:organization_slug/projects/new(.:format)
  def new
    @project = @organization.projects.build
  end

  # POST /organizations/:organization_slug/projects(.:format)
  def create
    @project = Project.new(project_params)

    respond_to do |format|
      if @project.save
        format.html { redirect_to project_path(@project), notice: 'Project was successfully created.' }
        format.json { render :show, status: :created, location: @project }
      else
        format.html { render :new }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /projects/1
  # PATCH/PUT /projects/1.json
  def update
    respond_to do |format|
      if @project.update(project_params)
        format.html { redirect_to root_organization_project_setting_path(@project.organization, @project), notice: 'Project was successfully updated.' }
        format.json { render :show, status: :ok, location: @project }
      else
        format.html { render :edit }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /projects/1
  # DELETE /projects/1.json
  def destroy
    @project.destroy
    respond_to do |format|
      format.html { redirect_to projects_url, notice: 'Project was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  def set_organization
    @organization = Organization.find_by(slug: params[:organization_slug])
  end

  def set_project
    @project = Project.find(params[:id])
  end

  def set_project_organization
    @organization = @project.organization
  end

  # Only allow a list of trusted parameters through.
  def project_params
    params.require(:project).permit(:name, :host, :organization_id)
  end
end

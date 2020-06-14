module Projects
  class SettingsController < ApplicationController
    before_action :set_organization
    before_action :set_project

    def general
    end

    def update
      redirect_path = root_organization_project_setting_path(@organization, @project)
      if @project.update(project_params)
        redirect_to redirect_path, notice: 'Project was successfully updated.'
      else
        redirect_to redirect_path, status: :unprocessable_entity, alert: @project.errors.full_message
      end
    end

    private

    def set_organization
      @organization = Organization.find_by(slug: params[:organization_slug])
    end

    def set_project
      @project = @organization.projects.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      redirect_to root_organization_project_setting_path(@organization, @organization.projects.first)
    end

    def project_params
      params.require(:project).permit(:name, :host, :organization_id)
    end
  end
end

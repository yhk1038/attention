module Sdk
  module V1
    class ProjectsController < ApplicationController
      skip_before_action :verify_authenticity_token

      def show
        @project = Project.find(params[:id])
      end
    end
  end
end

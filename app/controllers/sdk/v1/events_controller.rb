module Sdk
  module V1
    class EventsController < ApplicationController
      skip_before_action :verify_authenticity_token
      before_action :parse_project_id, only: :embed
      before_action :set_project, only: :embed
      before_action :set_organization, only: :embed

      # => 최초 SDK 진입 포인트.
      #
      def embed
        @project.update_in_live_notifications_count
        @notifications = @project.notifications.in_live.order(live_start_at: :asc)
      end

      def fire
        @notification = Notification.find(params[:notification_id])
        @project = @notification.project

        if valid_host?(@project.host, params[:origin])
          headers['X-Frame-Options'] = 'allow-from *'
          render 'sdk/v1/events/fire', layout: 'sdk/v1/iframe'
        else
          render 'sdk/v1/events/fire_error', layout: 'sdk/v1/iframe'
        end
      end

      def hit
        Hit.create(notification_id: params[:notification_id], ip_address: request.remote_ip)
        render js: ''
      end

      private

      def parse_project_id
        id = params[:id].presence
        raise 'id 파라미터가 반드시 필요합니다.' unless id

        id.gsub(Project::MODEL_INITIAL + '-', '')
      end

      def set_project
        @project = Project.find(parse_project_id)
      end

      def set_organization
        @organization = @project.organization
      end

      def valid_host?(base, compare)
        # return true
        return unless compare

        remove_protocol(base).start_with? remove_protocol(compare)
      end

      def remove_protocol(origin)
        origin.to_s.gsub(/http(s|):\/\//, '')
      end
    end
  end
end

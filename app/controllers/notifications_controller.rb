class NotificationsController < ApplicationController
  before_action :set_organization
  before_action :set_project
  before_action :set_notification, only: [:show, :edit, :update, :destroy]

  # GET /notifications
  # GET /notifications.json
  def index
    @notifications = @project.notifications.order(created_at: :desc)
  end

  # GET /notifications/1
  # GET /notifications/1.json
  def show
  end

  # GET /notifications/new
  def new
    @minimum_start_at = Time.zone.now
    @notification = @project.notifications.build(
      live_start_at: @minimum_start_at,
      live_stop_at: @minimum_start_at + 1.hour
    )
  end

  # GET /notifications/1/edit
  def edit
    @minimum_start_at = Time.zone.yesterday.end_of_day
  end

  # POST /notifications
  # POST /notifications.json
  def create
    @notification = Notification.new(notification_params)

    respond_to do |format|
      if @notification.save
        format.html { redirect_to organization_notification_path(@organization, @notification, project_id: @project.id), notice: 'Notification was successfully created.' }
        format.json { render :show, status: :created, location: @notification }
      else
        format.html { render :new }
        format.json { render json: @notification.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /notifications/1
  # PATCH/PUT /notifications/1.json
  def update
    respond_to do |format|
      if @notification.update(notification_params)
        if params[:redirect_url].present?
          format.html { redirect_to params[:redirect_url], notice: 'Notification was successfully updated.' }
        else
          format.html { redirect_to organization_notification_path(@organization, @notification, project_id: @project.id), notice: 'Notification was successfully updated.' }
        end
        format.json { render :show, status: :ok, location: @notification }
      else
        if params[:redirect_url].present?
          format.html { redirect_to params[:redirect_url], alert: @notification.errors.full_message }
        else
          format.html { render :edit }
        end
        format.json { render json: @notification.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /notifications/1
  # DELETE /notifications/1.json
  def destroy
    @notification.destroy
    respond_to do |format|
      format.html { redirect_to organization_notifications_path(@organization, project_id: @project.id), notice: 'Notification was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  def set_organization
    @organization = Organization.find_by(slug: params[:organization_slug])
  end

  def set_project
    @project = @organization.projects.find_or_first(params[:project_id])
  end

  def set_notification
    @notification = Notification.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def notification_params
    params.require(:notification).permit(:title, :content, :project_id, :live_start_at, :live_stop_at, :published)
  end
end

class OrganizationUsersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_organization, only: %i[index invite create]
  before_action :set_organization_user, only: :destroy

  def index
    @users = @organization.users
    @new_organization_user = @organization.organization_users.build
    @new_user = User.find_or_initialize_by(id: params[:user_id])
  end

  def invite
    @invitee = User.find_or_initialize_by(invitee_params)
    @organization.invite!(@invitee)

    if @organization.users.include?(@invitee)
    else
    end
  end

  # POST /organization_users
  # POST /organization_users.json
  def create
    @user = User.find(params[:user_id])

    args = { fallback_location: organization_path(@organization) }.merge(
      if @organization.users << @user
        { notice: 'Organization user was successfully created.' }
      else
        { alert: @organization_user.errors.full_messages }
      end
    )

    redirect_back args
  end

  # DELETE /organization_users/1
  # DELETE /organization_users/1.json
  def destroy
    @organization_user.destroy
    respond_to do |format|
      format.html { redirect_to organization_users_url, notice: 'Organization user was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_organization_user
    @organization_user = OrganizationUser.find(params[:id])
  end

  def set_organization
    @organization = Organization.find_by(slug: params[:organization_slug])
  end

  def invitee_params
    params.require(:invitee).permit(:first_name, :last_name, :email)
  end
end

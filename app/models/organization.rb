class Organization < ApplicationRecord
  has_many :projects

  has_many :organization_users, dependent: :destroy
  has_many :users, through: :organization_users

  def to_param
    slug
  end

  def invite!(invitee)
    if invitee.new_record?
      # Make account without confirmation
      invitee.password = slug
      invitee.password_confirmation = slug

      # Send invite email with generated random password
      invitee.save!
    end

    # Add on the Organization
    users << invitee
  end
end

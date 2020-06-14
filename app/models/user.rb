class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :lockable, :timeoutable
  devise :database_authenticatable, :registerable, :confirmable, :trackable,
         :recoverable, :rememberable, :validatable, :omniauthable

  has_many :organization_users, dependent: :destroy
  has_many :organizations, through: :organization_users

  validates_presence_of :first_name, :last_name
end

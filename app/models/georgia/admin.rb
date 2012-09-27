module Georgia
  class Admin < ActiveRecord::Base
    devise :database_authenticatable, :registerable,
    :recoverable, :rememberable, :trackable, :validatable

    attr_accessible :first_name, :last_name, :email, :password, :password_confirmation, :remember_me, :role_ids

    has_and_belongs_to_many :roles

    def has_role? role
      return false unless role
      @role_names ||= roles.map(&:name)
      @role_names.include? role.to_s.titleize
    end
  end
end
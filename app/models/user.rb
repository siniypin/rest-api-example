class User < ActiveRecord::Base
  has_secure_password

  attr_accessor :name, :role

  validates_inclusion_of :role, in: Role.all_values

  after_initialize -> do
    self.attributes['role'] ||= Role::ADMIN
  end

  def behave_according_to_role
    self.extend Behavior.const_get("#{role.classify}Privilege")
  end
end

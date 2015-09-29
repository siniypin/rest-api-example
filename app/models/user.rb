class User < ActiveRecord::Base
  has_secure_password

  validates_inclusion_of :role, in: Role.all_values

  after_initialize -> do
    self.role ||= Role::ADMIN
  end

  def behave_according_to_role
    self.extend Behavior.const_get("#{role.classify}Privilege")
  end
end

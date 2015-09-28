class User < ActiveRecord::Base
  attr_accessor :name, :role

  validates_inclusion_of :role, in: Role.all_values

  after_initialize -> do
    self.role ||= Role::ADMIN
  end

  def behave_according_to_role
    self.extend Behavior.const_get("#{role.classify}Privilege")
  end
end

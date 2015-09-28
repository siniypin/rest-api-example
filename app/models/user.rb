class User
  attr_accessor :role

  def initialize
    self.role = Role::ADMIN
  end

  def valid?
    Role::all_values.include? role
  end

  def behave_according_to_role
    self.extend Behavior.const_get("#{role.classify}Privilege")
  end
end

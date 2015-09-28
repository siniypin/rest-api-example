class User
  attr_accessor :role

  def initialize
    self.role = Role::ADMIN
  end

  def valid?
    Role::all_values.include? role
  end
end

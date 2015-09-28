module Role
  ADMIN = 'admin'
  USER = 'user'
  GUEST = 'guest'

  def all_values
    %W(#{ADMIN} #{USER} #{GUEST})
  end

  module_function :all_values
end

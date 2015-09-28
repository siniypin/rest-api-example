module Role
  ADMIN = 'admin'

  def all_values
    %W(#{ADMIN})
  end

  module_function :all_values
end

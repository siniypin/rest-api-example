module Behavior
  module GuestPrivilege
    def can_read?
      true
    end

    def method_missing(name, *args)
      return false if name.to_s.start_with?('can_') and name.to_s.end_with?('?')
      super name, args
    end
  end
end

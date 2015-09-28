module Behavior
  module AdminPrivilege
    def method_missing(name, *args)
      return true if name.to_s.start_with?('can_') and name.to_s.end_with?('?')
      super name, args
    end
  end
end

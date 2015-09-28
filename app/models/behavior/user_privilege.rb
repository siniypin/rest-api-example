module Behavior
  module UserPrivilege
    def can_read?(object)
      true
    end

    def can_create?
      true
    end

    def method_missing(name, *args)
      return owned?(args.first) if name.to_s.start_with?('can_') and name.to_s.end_with?('?')
      super name, args
    end

    private
    def owned?(object)
      object.respond_to?(:user_id) and object.user_id == id
    end
  end
end

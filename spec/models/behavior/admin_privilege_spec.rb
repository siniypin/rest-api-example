require 'spec_helper'
require 'rails_helper'

describe Behavior::AdminPrivilege do
  subject { Object.new.extend Behavior::AdminPrivilege }

  %w(create read update delete).each do |action|
    it "should allow to #{action}" do
      expect(subject.send("can_#{action}?".to_sym, Object.new)).to be_truthy
    end
  end
end

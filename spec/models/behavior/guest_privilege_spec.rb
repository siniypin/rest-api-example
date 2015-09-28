require 'spec_helper'
require 'rails_helper'

describe Behavior::GuestPrivilege do
  subject { Object.new.extend Behavior::GuestPrivilege }

  it 'should allow to read' do
    expect(subject.can_read?).to be_truthy
  end

  it 'should forbid to create' do
    expect(subject.can_create?).to be_falsey
  end

  %w(update delete).each do |action|
    it "should forbid to #{action}" do
      expect(subject.send("can_#{action}?".to_sym, Object.new)).to be_falsey
    end
  end
end

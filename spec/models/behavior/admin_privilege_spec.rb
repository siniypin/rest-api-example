require 'spec_helper'
require 'rails_helper'

describe Behavior::AdminPrivilege do
  subject { Object.new.extend Behavior::AdminPrivilege }

  it 'should allow to create' do
    expect(subject.can_create?).to be_truthy
  end

  %w(read update delete).each do |action|
    it "should allow to #{action}" do
      expect(subject.send("can_#{action}?".to_sym, Object.new)).to be_truthy
    end
  end

  it 'should raise error for unexpected requests' do
    expect { subject.send :do_create }.to raise_error NoMethodError
  end
end

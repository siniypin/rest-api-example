require 'spec_helper'
require 'rails_helper'

describe Behavior::UserPrivilege do
  let(:user_id) { rand(100) }
  subject { OpenStruct.new(id: user_id).extend Behavior::UserPrivilege }

  it 'should allow to create' do
    expect(subject.can_create?).to be_truthy
  end

  context 'when owned object provided' do
    let(:owned_object) { OpenStruct.new(user_id: user_id) }

    %w(read update delete).each do |action|
      it "should allow to #{action}" do
        expect(subject.send("can_#{action}?".to_sym, owned_object)).to be_truthy
      end
    end
  end

  context 'when anothers object provided' do
    let(:anothers_object) { OpenStruct.new(user_id: user_id+1) }

    it 'should allow to read' do
      expect(subject.can_read? anothers_object).to be_truthy
    end

    %w(update delete).each do |action|
      it "should forbid to #{action}" do
        expect(subject.send("can_#{action}?".to_sym, anothers_object)).to be_falsey
      end
    end
  end
end

require 'spec_helper'
require 'rails_helper'

describe User do
  it 'should provide means to create an instance' do
    expect(User.new).not_to be_nil
  end

  describe 'role attribute' do
    it 'should exist' do
      expect { subject.role }.not_to raise_error
    end

    it 'should have a default value of admin' do
      expect(subject.role).to eq Role::ADMIN
    end

    Role::all_values.each do |role|
      it "should accept #{role} value" do
        subject.role = role

        expect(subject).to be_valid
      end
    end

    it 'should not accept incorrect role values' do
      subject.role = 'randomstring'

      expect(subject).not_to be_valid
    end
  end

  Role::all_values.each do |role|
    it "should behave according to #{role} role" do
      subject.role = role

      subject.behave_according_to_role

      expect(subject).to be_a Behavior.const_get("#{role.classify}Privilege")
    end
  end
end

require 'spec_helper'
require 'rails_helper'

describe User do
  it 'should provide means to create an instance' do
    expect(User.new).not_to be_nil
  end

  describe 'role attribute' do
    before do
      #exclude non related validation errors
      subject.password = Forgery(:basic).password
      subject.password_confirmation = subject.password
    end

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
      subject.role = Forgery(:basic).text

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

  describe 'password' do
    it('can have unit tests skipped as long as I am not testing a framework, there are tests provided') {}
  end
end

require 'spec_helper'
require 'rails_helper'

describe Review do
  it 'should provide means to create an instance' do
    expect(Review.new).not_to be_nil
  end

  describe 'valid?' do
    let(:user) { User.new }
    before { subject.user = user }

    it 'should be invalid without title' do
      subject.text = 'randomstring'

      expect(subject.valid?).to be_falsey
    end

    it 'should be invalid without text' do
      subject.title = 'randomstring'

      expect(subject.valid?).to be_falsey
    end

    it 'should be valid with all properties provided' do
      subject.text  = 'randomstring'
      subject.title = 'randomstring'

      expect(subject.valid?).to be_truthy
    end
  end
end

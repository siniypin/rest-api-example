require 'spec_helper'
require 'rails_helper'

describe Comment do
  it 'should provide means to create an instance' do
    expect(Comment.new).not_to be_nil
  end

  describe 'valid?' do
    let(:user) { User.new }
    let(:review) { Review.new user: user }
    before { subject.user = user }
    before { subject.review = review }

    it 'should be invalid without text' do
      expect(subject.valid?).to be_falsey
    end

    it 'should be valid with all properties provided' do
      subject.text  = 'randomstring'

      expect(subject.valid?).to be_truthy
    end
  end
end

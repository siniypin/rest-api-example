require 'spec_helper'
require 'rails_helper'

describe Api::ReviewsController, type: :controller do
  it_should_behave_like :basic_auth
  it_should_behave_like :accept_json_mime

  shared_examples_for :read do
    it 'should return review' do
      get :show, id: 1, format: :json

      expect(response.body).to eq Review.first.to_json
    end

    it 'should return all reviews' do
      get :index, format: :json

      expect(response.body).to eq Review.all.to_json
    end
  end

  before do
    request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Basic.encode_credentials('name', 'password')
    allow(User).to receive(:find_by_name).and_return(user)
    allow_any_instance_of(User).to receive(:authenticate).and_return(user)
  end
  before { allow(Review).to receive(:all).and_return(
                              [Review.new(id:    1, user: user,
                                          title: Forgery(:basic).text,
                                          text:  Forgery(:basic).text),
                               Review.new(id:    2, user: user,
                                          title: Forgery(:basic).text,
                                          text:  Forgery(:basic).text),
                               Review.new(id:    3, user: user,
                                          title: Forgery(:basic).text,
                                          text:  Forgery(:basic).text)]) }
  before { allow(Review).to receive(:first).and_return(Review.all.first) }
  let(:review_params) { {title: Forgery(:basic).text, text: Forgery(:basic).text, user_id: user.id} }
  let(:next_id) { Forgery(:basic).number }
  before { allow(Review).to receive(:create!).and_return(Review.new(id:    next_id, user_id: user.id,
                                                                    title: review_params[:title],
                                                                    text:  review_params[:text])) }
  before { Review.stub_chain(:find, :update_attributes!).and_return(Review.all.first) }
  before { Review.stub_chain(:find, :destroy!) }

  context 'given an admin' do
    let(:user) { User.new(id: 1) }

    it_should_behave_like :read

    it 'should accept new reviews' do
      post :create, review: review_params, format: :json

      expect(response).to be_successful
      expect(response).to have_http_status :created
      expect(response.body).to eq({id: next_id}.merge!(review_params).to_json)
      expect(Review).to have_received :create!
    end

    it 'should accept review edits' do
      update_review_params = {id: 1, title: Forgery(:basic).text, text: Forgery(:basic).text, user_id: user.id}

      put :update, id: 1, review: update_review_params, format: :json

      expect(response).to be_successful
      expect(response).to have_http_status :no_content
    end

    it 'should delete review' do
      delete :destroy, id: 1, format: :json

      expect(response).to be_successful
      expect(response).to have_http_status :no_content
    end
  end

  context 'given a regular user' do
    let(:user) { User.new(id: 1, role: Role::USER) }

    it_should_behave_like :read

    it 'should accept new reviews' do
      post :create, review: review_params, format: :json

      expect(response).to be_successful
      expect(response).to have_http_status :created
    end

    context 'when review belongs to another user' do
      before { allow(User).to receive(:find_by_name).and_return(User.new(id: 2, role: Role::USER)) }

      it 'should forbid review edits' do

      end

      it 'should forbid deleting review' do

      end
    end

    context 'when review owned' do
      before { allow(Review).to receive(:find).and_return(Review.new(user: user)) }

      it 'should accept review edits' do
        # put
      end

      it 'should delete review' do

      end
    end
  end

  context 'given a guest' do
    before do
      request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Basic.encode_credentials('name', 'password')
      allow(User).to receive(:find_by_name).and_return(User.new(role: Role::GUEST, id: Forgery(:basic).number))
    end

    it_should_behave_like :read


  end
end

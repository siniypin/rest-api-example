require 'spec_helper'
require 'rails_helper'

class String
  def trim
    self[1..-2]
  end
end


describe Api::ReviewsController, type: :controller do
  it_should_behave_like :basic_auth
  it_should_behave_like :accept_json_mime
  it_should_behave_like :comply_with_hateoas

  before { allow(Review).to receive(:find).and_return(Review.new(id: 1)) }

  context 'CRUD features' do
    shared_examples_for :read_anything do
      it 'should return review' do
        get :show, id: 1, format: :json

        expect(response.body).to include Review.first.to_json.trim
      end

      it 'should return all reviews' do
        get :index, format: :json

        Review.all.each do |x|
          expect(response.body).to include x.to_json.trim
        end
      end
    end

    before do
      request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Basic.encode_credentials('name', 'password')
      allow(User).to receive(:find_by_name).and_return(user)
      allow_any_instance_of(User).to receive(:authenticate).and_return(user)
    end
    before { allow_any_instance_of(User).to receive(:authenticate).and_return(user) }
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
    before { allow(Review).to receive(:find).and_return(Review.all.first) }
    let(:review_params) { {title: Forgery(:basic).text, text: Forgery(:basic).text, user_id: user.id} }
    let(:next_id) { Forgery(:basic).number }
    before { allow(Review).to receive(:create!).and_return(Review.new(id:    next_id, user_id: user.id,
                                                                      title: review_params[:title],
                                                                      text:  review_params[:text])) }
    before { Review.stub_chain(:find, :update_attributes!).and_return(Review.all.first) }
    before { Review.stub_chain(:find, :destroy!) }

    context 'given an admin' do
      let(:user) { User.new(id: 1, role: Role::ADMIN) }
      before { allow_any_instance_of(User).to receive(:authenticate).and_return(user) }

      it_should_behave_like :read_anything

      it 'should accept new reviews' do
        post :create, review: review_params, format: :json

        expect(response).to have_http_status :created
        expect(response.body).to include({id: next_id}.merge!(review_params).to_json.trim)
        expect(Review).to have_received :create!
      end

      it 'should accept review edits' do
        update_review_params = {id: 1, title: Forgery(:basic).text, text: Forgery(:basic).text, user_id: user.id}

        put :update, id: 1, review: update_review_params, format: :json

        expect(response).to have_http_status :no_content
      end

      it 'should delete review' do
        delete :destroy, id: 1, format: :json

        expect(response).to have_http_status :no_content
      end
    end

    context 'given a regular user' do
      let(:user) { User.new(id: 1, role: Role::USER) }

      it_should_behave_like :read_anything

      it 'should accept new reviews' do
        post :create, review: review_params, format: :json

        expect(response).to have_http_status :created
      end

      context 'when review belongs to another user' do
        before { allow_any_instance_of(User).to receive(:authenticate).and_return(User.new(id: 2, role: Role::USER)) }

        it 'should forbid review edits' do
          update_review_params = {id: 1, title: Forgery(:basic).text, text: Forgery(:basic).text}

          put :update, id: 1, review: update_review_params, format: :json

          expect(response).to have_http_status :forbidden
        end

        it 'should forbid deleting review' do
          delete :destroy, id: 1, format: :json

          expect(response).to have_http_status :forbidden
        end
      end

      context 'when review owned' do
        it 'should accept review edits' do
          update_review_params = {id: 1, title: Forgery(:basic).text, text: Forgery(:basic).text, user_id: user.id}

          put :update, id: 1, review: update_review_params, format: :json

          expect(response).to have_http_status :no_content
        end

        it 'should delete review' do
          delete :destroy, id: 1, format: :json

          expect(response).to have_http_status :no_content
        end
      end
    end

    context 'given a guest' do
      let(:user) { User.new(id: 1, role: Role::GUEST) }

      it_should_behave_like :read_anything

      it 'should forbid creating review' do
        post :create, review: review_params, format: :json

        expect(response).to have_http_status :forbidden
      end

      it 'should forbid review edits' do
        update_review_params = {id: 1, title: Forgery(:basic).text, text: Forgery(:basic).text}

        put :update, id: 1, review: update_review_params, format: :json

        expect(response).to have_http_status :forbidden
      end

      it 'should forbid deleting review' do
        delete :destroy, id: 1, format: :json

        expect(response).to have_http_status :forbidden
      end
    end
  end
end

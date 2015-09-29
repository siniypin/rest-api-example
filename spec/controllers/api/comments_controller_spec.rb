require 'spec_helper'
require 'rails_helper'

describe Api::CommentsController, type: :controller do
  it_should_behave_like :basic_auth, {id: 1, review_id: 1, format: :json}
  it_should_behave_like :accept_json_mime, {id: 1, review_id: 1, format: :json}
  let(:review) { Review.new }
  before { allow(Review).to receive(:find).and_return(review) }
  before { review.stub_chain(:comments, :find).and_return(Comment.new) }

  context 'CRUD features' do
    let(:review) { Review.new(id:    1, user: user,
                              title: Forgery(:basic).text,
                              text:  Forgery(:basic).text) }
    let(:comment) { Comment.new(id:        1,
                                user_id:   user.id,
                                review_id: review.id,
                                text:      Forgery(:basic).text) }
    before { allow(Review).to receive(:find).and_return(review) }
    before { review.stub_chain(:comments, :find).and_return(comment) }
    let(:comment_params) { {text: Forgery(:basic).text, user_id: user.id, review_id: review.id} }
    let(:next_id) { Forgery(:basic).number }
    before { allow(Comment).to receive(:create!).and_return(Comment.new(id:        next_id,
                                                                        user_id:   user.id,
                                                                        text:      comment_params[:text],
                                                                        review_id: review.id)) }
    before { allow(comment).to receive(:update_attributes!).and_return(comment) }
    before do
      request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Basic.encode_credentials('name', 'password')
      allow(User).to receive(:find_by_name).and_return(user)
      allow_any_instance_of(User).to receive(:authenticate).and_return(user)
    end

    context 'given a standard user' do
      let(:user) { User.new(id: 1, role: Role::USER) }

      shared_examples_for :allow_edit do
        it 'should accept comment edits' do
          update_comment_params = {id: 1, text: Forgery(:basic).text, user_id: user.id, review_id: review.id}

          put :update, id: comment.id, review_id: review.id, comment: update_comment_params, format: :json

          expect(response).to have_http_status :no_content
        end

        it 'should delete comment' do
          delete :destroy, id: comment.id, review_id: review.id, format: :json

          expect(response).to have_http_status :no_content
        end
      end

      shared_examples_for :forbid_edit do
        it 'should forbid editing comment' do
          update_comment_params = {id: 1, text: Forgery(:basic).text, user_id: user.id, review_id: review.id}

          put :update, id: comment.id, review_id: review.id, comment: update_comment_params, format: :json

          expect(response).to have_http_status :forbidden
        end

        it 'should forbid deleting comment' do
          delete :destroy, id: comment.id, review_id: review.id, format: :json

          expect(response).to have_http_status :forbidden
        end
      end

      context 'when comment owned' do
        context 'on review owned' do
          it_should_behave_like :allow_edit

          it 'should allow to comment' do
            post :create, review_id: review.id, comment: comment_params, format: :json

            expect(response).to have_http_status :created
            expect(Comment).to have_received :create!
          end
        end

        context 'on review that belongs to another user' do
          let(:review) { Review.new(id:    1, user_id: 2,
                                    title: Forgery(:basic).text,
                                    text:  Forgery(:basic).text) }

          it_should_behave_like :allow_edit

          it 'should allow to comment' do
            post :create, review_id: review.id, comment: comment_params, format: :json

            expect(response).to have_http_status :created
            expect(Comment).to have_received :create!
          end
        end
      end

      context 'when comment belongs to another user' do
        before { allow_any_instance_of(User).to receive(:authenticate).and_return(User.new(id: 2, role: Role::USER)) }

        context 'on review owned' do
          let(:review) { Review.new(id:    1, user_id: 2,
                                    title: Forgery(:basic).text,
                                    text:  Forgery(:basic).text) }

          it_should_behave_like :forbid_edit
        end

        context 'on review that belongs to another user' do
          it_should_behave_like :forbid_edit
        end
      end
    end
  end
end

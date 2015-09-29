class Api::CommentsController < ApplicationController
  respond_to :json

  before_action :load_review!
  before_action :load_comment!, except: [:index, :create]
  before_action :authorize!, except: [:index, :show] # NOTE: everyone is permitted to read, why bother checking?

  def index
    respond_with :api, @review, @review.comments
  end

  def show
    respond_with :api, @review, @comment
  end

  def create
    respond_with :api, @review, Comment.create!(params.require(:comment).permit(:text).merge(user_id: @current_user.id, review_id: @review.id))
  end

  def update
    respond_with :api, @review, @comment.update_attributes!(params.require(:comment).permit(:text))
  end

  def destroy
    respond_with :api, @review, @comment.destroy!
  end

  private
  def load_review!
    @review = Review.find params[:review_id]
  end

  def load_comment!
    @comment = @review.comments.find params[:id]
  end

  def authorize!
    unless @current_user.behave_according_to_role.send("can_#{params[:action]}?".to_sym, @comment)
      raise AccessDeniedError, "User #{@current_user.name} cannot #{params[:action]} comment ##{@comment.try :id} on review ##{@review.id}}"
    end
  end
end

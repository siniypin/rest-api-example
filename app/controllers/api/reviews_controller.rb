class Api::ReviewsController < ApplicationController
  respond_to :json

  before_action :load_review!, except: [:index, :create]
  before_action :authorize!, except: [:index, :show] # NOTE: everyone is permitted to read, why bother checking?

  def index
    respond_with :api, Review.all
  end

  def show
    respond_with :api, @review
  end

  def create
    respond_with :api, Review.create!(params.require(:review).permit(:title, :text).merge(user_id: @current_user.id))
  end

  def update
    respond_with :api, @review.update_attributes!(params.require(:review).permit(:title, :text))
  end

  def destroy
    respond_with :api, @review.destroy!
  end

  private
  def load_review!
    @review = Review.find params[:id]
  end

  def authorize!
    unless @current_user.behave_according_to_role.send("can_#{params[:action]}?".to_sym, @review)
      raise AccessDeniedError, "User #{@current_user.name} cannot #{params[:action]} review ##{@review.id}}"
    end
  end
end

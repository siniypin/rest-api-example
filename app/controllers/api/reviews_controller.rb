class Api::ReviewsController < ApplicationController
  respond_to :json

  def index
    respond_with :api, Review.all
  end

  def show
    respond_with :api, Review.first
  end

  def create
    respond_with :api, Review.create!(params.require(:review).permit(:title, :text).merge(user_id: @current_user.id))
  end

  def update
    respond_with :api, Review.find(params[:id]).update_attributes!(params.require(:review).permit(:title, :text))
  end

  def destroy
    respond_with :api, Review.find(params[:id]).destroy!
  end
end

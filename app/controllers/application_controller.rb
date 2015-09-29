class ApplicationController < ActionController::Base
  AccessDeniedError = Class.new(StandardError)

  before_action :authenticate

  rescue_from AccessDeniedError, with: :forbidden
  rescue_from ActiveRecord::RecordNotFound, with: :not_found
  rescue_from ActiveRecord::RecordInvalid, with: :bad_request

  protected
  def authenticate
    authenticate_or_request_with_http_basic do |name, password|
      @current_user = User.find_by_name(name).try(:authenticate, password)
    end
  end

  def forbidden(exception)
    render json: {error: exception.message}, status: :forbidden
  end

  def not_found(exception)
    render json: {error: exception.message}, status: :not_found
  end

  def bad_request(exception)
    render json: {error: exception.message}, status: :bad_request
  end

  def method_missing(name, *args)
    render json: {error: args.first.message}, status: name
  end
end

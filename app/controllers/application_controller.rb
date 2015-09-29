class ApplicationController < ActionController::Base
  AccessDeniedError = Class.new(StandardError)

  before_action :authenticate

  rescue_from AccessDeniedError, with: :deny_access

  protected
  def authenticate
    authenticate_or_request_with_http_basic do |name, password|
      @current_user = User.find_by_name(name).try(:authenticate, password)
    end
  end

  def deny_access(exception)
    render json: {error: exception.message}, status: :forbidden
  end
end

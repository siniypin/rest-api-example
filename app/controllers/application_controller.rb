class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  before_action :authenticate

  protected
  def authenticate
    authenticate_or_request_with_http_basic do |name, password|
      @current_user = User.find_by_name(name).try(:authenticate, password)
    end
  end
end

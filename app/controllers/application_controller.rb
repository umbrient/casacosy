class ApplicationController < ActionController::Base
  check_authorization unless: :devise_controller?
  before_action :authenticate_user!
end

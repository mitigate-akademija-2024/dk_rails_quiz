class ApplicationController < ActionController::Base
  check_authorization unless: :devise_controller?

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_url, alert: 'You are not authorized to perform this action.'
  end

end

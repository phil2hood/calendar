class RegistrationsController < Devise::RegistrationsController
  before_filter :configure_permitted_parameters

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:account_update) { |u| u.permit(:email, :password, :timezone, :snap_to_minutes, :default_calendar_id, :password_confirmation, :current_password) }
  end
end
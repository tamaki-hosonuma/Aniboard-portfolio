class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :authenticate_user!
  before_action :configure_permitted_parameters, if: :devise_controller?

  def set_current_user
    @current_user = current_user
  end

  def authenticate_user
    if @current_user == nil?
      flash[:notice] = "ログインが必要です"
      redirect_to("/top")
    end
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
    devise_parameter_sanitizer.permit(:account_update, keys: [:name, :profile, :image, :remove_image, :password, :current_password])
  end
end

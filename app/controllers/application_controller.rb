class ApplicationController < ActionController::Base
  include Response
  before_action :set_locale

  private

  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end

  def authenticate_user!
    auth_header = request.headers["Authorization"]

    if auth_header.present? && auth_header.starts_with?("Bearer ")
      token = auth_header.split(" ").last
    else
      token = nil
    end

    user_id = Authentication.decode(token)["user_id"] if token

    @current_user = User.find_by(id: user_id)

    return if @current_user

    render json: {error: I18n.t("api.errors.login_required")},
           status: :unauthorized
  end

  def authenticate_admin!
    return if @current_user&.admin?

    render json: {error: I18n.t("api.errors.forbidden_access")},
           status: :forbidden
  end

  def correct_user
    return if @current_user == @user

    render json: {error: I18n.t("api.errors.forbidden_access")},
           status: :forbidden
  end
end

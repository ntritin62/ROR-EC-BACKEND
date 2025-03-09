class ApplicationController < ActionController::Base
  include ParamSnakeCase
  include Response
  skip_before_action :verify_authenticity_token
  before_action :set_locale

  private

  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end

  def current_user
    return @current_user if defined?(@current_user)

    auth_header = request.headers["Authorization"]
    if auth_header.present? && auth_header.starts_with?("Bearer ")
      token = auth_header.split(" ").last
      begin
        decoded_token = Authentication.decode(token)
        user_id = decoded_token["user_id"] if decoded_token
        @current_user = User.find_by(id: user_id)
      rescue JWT::DecodeError
        nil
      end
    end
  end

  def authenticate_user!
    unless current_user
      render json: { error: I18n.t("api.errors.login_required") }, status: :unauthorized
    end
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

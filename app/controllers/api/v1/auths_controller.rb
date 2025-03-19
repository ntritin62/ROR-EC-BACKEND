class Api::V1::AuthsController < ApplicationController
  before_action :set_user, only: :login
  before_action :authenticate_user!, :user_update_params, only: :update
  def login
    if @user&.authenticate(params[:password])
      render_json(
        status: :ok, 
        message: t(".success"), 
        data: { jwt_token: Authentication.encode({ user_id: @user.id }) },
        http_status: :ok
      )
    else
      render_json(
        status: :unauthorized, 
        message: t(".failure"), 
        errors: {detail: t(".failure")},
        http_status: :unauthorized
      )
    end
  end

  def sign_up
    user = User.new user_params
    if user.save
      render_json(
        status: :created, 
        message: t(".success"),
        http_status: :created
      )
    else
      render_json(
        status: :unprocessable_entity, 
        message: t(".failure"), 
        errors: user.errors.full_messages,
        http_status: :unprocessable_entity
      )
    end
  end

  def update
    if current_user.update(user_update_params)
      render_json(
        status: :ok,
        message: t(".success"),
        data: @user,
        http_status: :ok
      )
    else
      render_json(
        status: :unprocessable_entity,
        message: t(".failure"),
        errors: @user.errors.full_messages,
        http_status: :unprocessable_entity
      )
    end
  end

  def show
    render_json(
      status: :ok,
      message: t(".success"),
      data: {
        user: UserSerializer.new(current_user)
      },
      http_status: :ok
    )
  end

  def change_password
    old_password, new_password, confirm_password = password_params.values_at(:old_password, :new_password, :confirm_password)
  
    return unauthorized_error unless current_user.authenticate(old_password)
    return password_mismatch_error if new_password != confirm_password
  
    if current_user.update(password: new_password, password_confirmation: confirm_password)
      render_json(status: :ok, message: t(".success"), http_status: :ok)
    else
      render_json(status: :unprocessable_entity, message: t(".failure"), errors: current_user.errors.full_messages, http_status: :unprocessable_entity)
    end
  end
  

  private
  def set_user
    @user = User.find_by(email: params[:email])
  end

  def user_params
    params.permit User::SIGN_UP_REQUIRE_ATTRIBUTES
  end

  def user_update_params
    params.require(:user).permit(:email, :full_name, :phone_number)
  end

  def password_params
    params.permit(:old_password, :new_password, :confirm_password)
  end
  
  def unauthorized_error
    render_json(status: :unauthorized, message: t(".incorrect_password"), errors: { detail: t(".incorrect_password") }, http_status: :unauthorized)
  end
  
  def password_mismatch_error
    render_json(status: :unprocessable_entity, message: t(".password_mismatch"), errors: { detail: t(".password_mismatch") }, http_status: :unprocessable_entity)
  end
end

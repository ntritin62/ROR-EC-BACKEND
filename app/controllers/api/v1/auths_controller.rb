class Api::V1::AuthsController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:login]
  before_action :set_user, only: :login
  def login
    if @user&.authenticate(params[:password])
      render json: { jwt_token: Authentication.encode({ user_id: @user.id }) }, status: :ok
    else
      render json: { error: "Sai mật khẩu" }, status: :unauthorized
    end
  end

  private
  def set_user
    @user = User.find_by(email: params[:email])
  end
end

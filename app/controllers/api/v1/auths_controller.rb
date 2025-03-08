class Api::V1::AuthsController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:login]
  before_action :set_user, only: :login
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
  

  private
  def set_user
    @user = User.find_by(email: params[:email])
  end
end

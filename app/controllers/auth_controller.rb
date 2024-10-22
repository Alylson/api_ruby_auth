class AuthController < ApplicationController
  skip_before_action :authorize_request, only: [:register, :login]

  # POST /register
  def register
    user = User.new(user_params)
    if user.save
      token = encode(user_id: user.id)
      render json: { token: token, user: user }, status: :created
    else
      render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # POST /login
  def login
    user = User.find_by(email: params[:email])
    if user
      token = encode(user_id: user.id)
      render json: { token: token, user: user }, status: :ok
    else
      render json: { errors: 'Credenciais inválidas' }, status: :unauthorized
    end
  end

  private

  def user_params
    params.require(:auth).permit(:email, :password, :password_confirmation)
  end
end

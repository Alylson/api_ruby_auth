class AuthController < ApplicationController
  skip_before_action :authorize_request, only: [:register, :login]

  # POST /register
  def register
    user = User.new(user_params)
    if user.save
      token = JwtService.encode(user_id: user.id)
      render json: { token: token, user: user.as_json(except: :password_digest) }, status: :created
    else
      render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # POST /login
  def login
    user = User.find_by(email: params[:email])
    if user&.authenticate(params[:password])
      token = JwtService.encode(user_id: user.id)
      render json: { token: token, user: user.as_json(except: :password_digest) }, status: :ok
    else
      render json: { errors: 'Invalid credentials' }, status: :unauthorized
    end
  end

  # POST /logout
  def logout
    render json: { message: 'Logout successful' }, status: :ok
  end

  private

  def user_params
    params.require(:auth).permit(:email, :password, :password_confirmation)
  end
end

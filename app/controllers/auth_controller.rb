class AuthController < ApplicationController

    def register
        user = User.new(user_params)
        if user.save
          token = encode_token({ user_id: user.id })
          render json: { user: user, token: token }, status: :created
        else
          render json: { error: user.errors.full_messages }, status: :unprocessable_entity
        end
    end
  
    def login
        user = User.find_by(email: params[:email])
      
        if user
          token = encode_token({ user_id: user.id })
          render json: { user: { id: user.id, email: user.email }, token: token }, status: :ok
        else
          render json: { error: 'Email ou senha inválidos' }, status: :unauthorized
        end
    end
      

    def logout
      render json: { message: 'Logged out' }
    end
  
    private
  
    def encode_token(payload)
      JWT.encode(payload, 'eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjozfQ.9YqZ784ZHzD73R5F3ydmkSmh6SweEnUFbpAew3nFHSA')  # Substitua com uma chave segura
    end
  
    def user_params
      params.permit(:email, :password, :password_confirmation)
    end
end
  
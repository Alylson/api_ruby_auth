class ApplicationController < ActionController::API
  before_action :authorize_request

  def authorize_request
    header = request.headers['Authorization']
    if header
      token = header.split(' ').last
      begin
        decoded = JwtService.decode(token)
        @current_user = User.find(decoded[:user_id])
      rescue ActiveRecord::RecordNotFound, JWT::DecodeError => e
        render json: { errors: 'Token inválido' }, status: :unauthorized
      end
    else
      render json: { errors: 'Token ausente' }, status: :unauthorized
    end
  end

  def decode(token)
    JWT.decode(token, secret_key, true, algorithm: 'HS256')[0].with_indifferent_access
  end

  def encode(payload)
    JWT.encode(payload, secret_key)
  end

  private

  def secret_key
    'eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjozfQ.9YqZ784ZHzD73R5F3ydmkSmh6SweEnUFbpAew3nFHSA'
  end
end

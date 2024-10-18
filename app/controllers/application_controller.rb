class ApplicationController < ActionController::API
  before_action :authorize

  def authorize
    header = request.headers['Authorization']
    token = header.split(' ').last if header
    begin
      decoded = decode_token(token)
      @current_user = User.find(decoded[:user_id])
    rescue ActiveRecord::RecordNotFound => e
      render json: { errors: 'Usuário não encontrado' }, status: :unauthorized
    rescue JWT::DecodeError => e
      render json: { errors: 'Token inválido' }, status: :unauthorized
    end
  end

  def decode_token(token)
    JWT.decode(token, 'eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjozfQ.9YqZ784ZHzD73R5F3ydmkSmh6SweEnUFbpAew3nFHSA', true, algorithm: 'HS256')[0].with_indifferent_access
  end

  def encode_token(payload)
    JWT.encode(payload, 'eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjozfQ.9YqZ784ZHzD73R5F3ydmkSmh6SweEnUFbpAew3nFHSA')
  end
end

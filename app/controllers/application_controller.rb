class ApplicationController < ActionController::API
  before_action :authorize_request

  def authorize_request
    header = request.headers['Authorization']
    if header.present?
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
end

class JwtService
    SECRET_KEY = Rails.application.secrets.secret_key_base.to_s
  
    def self.encode(payload)
      #payload[:exp] = exp.to_i
      JWT.encode(payload, SECRET_KEY)
    end
  
    def self.decode(token)
      decoded = JWT.decode(token, SECRET_KEY, true, { algorithm: 'HS256' })[0]
      HashWithIndifferentAccess.new(decoded)
    rescue JWT::DecodeError => e
      nil
    end
end
  
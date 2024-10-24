class JwtService
  SECRET_KEY = ENV['SECRET_KEY_BASE'] || '2f065a163e8a73347a2aed1ffab0daf2'

  def self.encode(payload)
    JWT.encode(payload, SECRET_KEY, 'HS256')
  end

  def self.decode(token)
    decoded = JWT.decode(token, SECRET_KEY, true, { algorithm: 'HS256' })[0]
    HashWithIndifferentAccess.new(decoded)
  end
end

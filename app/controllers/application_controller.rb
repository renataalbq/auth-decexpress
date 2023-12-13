class ApplicationController < ActionController::API

    def current_user
        if decode_token
          user_id = decode_token[0]['user_id']
          @current_user ||= User.find(user_id)
        end
      rescue ActiveRecord::RecordNotFound
        nil
    end
    
    def encode_token(payload)
        JWT.encode(payload, 'secret')
    end

    def decode_token
        auth_header = request.headers['Authorization']
        if auth_header
            token = auth_header.split(' ').last
            begin
                JWT.decode(token, 'secret', true, algorithm: 'HS256')
            rescue JWT::DecodeError
                nil
            end
        end
    end
end
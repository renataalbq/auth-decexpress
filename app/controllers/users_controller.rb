class UsersController < ApplicationController
    def create
        @user = User.create(user_params)
        if @user.valid?
          if @user.isAdmin
            @user.save
          else
            current_year = Time.now.year % 100
            random_numbers = "%09d" % rand(1000000000) 
            
            matricula = "#{current_year}#{random_numbers}"
            @user.matricula = matricula
          end

          if @user.save
            token = encode_token({user_id: @user.id})
            render json: {user: @user, token: token}, status: :ok
          else
            render json: { error: 'Falha ao salvar o usuário' }, status: :unprocessable_entity
          end
        else
            render json: {error: 'Campos inválidos'}, status: :unprocessable_entity
        end
    end
    
    def login
        @user = User.find_by(email: user_params[:email])
        if @user && @user.authenticate(user_params[:password])
            token_payload = { user_id: @user.id, isAdmin: @user.isAdmin, name: @user.name, matricula: @user.matricula }
            token = encode_token(token_payload)
            render json: {user: @user, token: token}, status: :ok
        else
            render json: {error: 'Campos inválidos'}, status: :unprocessable_entity
        end
    end

    def index
        @users = User.all
        render json: @users, status: :ok
    end

    def destroy
        @user = User.find(params[:id])
        if @user.destroy
          render json: { message: 'Usuário excluído com sucesso' }, status: :ok
        else
          render json: { error: 'Erro ao excluir o usuário' }, status: :unprocessable_entity
        end
    end

    def validate_token
        token = params[:token]
        if token
          if valid_token?(token)
            render json: { valid: true }
          else
            render json: { valid: false }
          end
        else
          render json: { message: 'Token ausente' }, status: :bad_request
        end
      end
    
      private
    
      def valid_token?(token)
        begin
          decoded_payload = JWT.decode(token, 'secret', true, algorithm: 'HS256')
          return true
        rescue JWT::DecodeError
          return false
        end
      end
    
    private
        
    def user_params
        params.permit(:name, :password, :email, :isAdmin)
    end
end

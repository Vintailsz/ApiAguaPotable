class AuthController < ApplicationController
    SECRET_KEY = Rails.application.secret_key_base

    def login
        user = User.find_by(username: params[:login]) || 
               User.find_by(email: params[:login]) 

        if user&.authenticate(params[:password])
            token = JWT.encode(
                { user_id: user.id, exp: 24.hours.from_now.to_i },
                SECRET_KEY
            )

            render json: { token: token }, status: :ok
        else
            render json: { error: "Invalid Credentials" }, status: :unauthorized
        end
    end

    # TO IMPLEMENTD
    # def logout
    #     token = request.headers["Authorization"]&.split(" ")&.last

    #     BlacklistedToken.create!(token: token)

    #     render json: { message: "Logged out successfully" }
    # end
end

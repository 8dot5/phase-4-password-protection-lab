class SessionsController < ApplicationController

    # for logging in
    # find_by username
    def create
        user = User.find_by(username: params[:username])
        # if user is true and bcrypt can authenticate the password (user.authenticate)
        if user&.authenticate(params[:password])
            # save the user's id to the session
            session[:user_id] = user.id
            render json: user, status: :ok
        else
        render json: {}, status: :unauthorized
        end
    end

    # for logging out
    def destroy
        session.delete(:user_id)
        head :no_content
    end
end

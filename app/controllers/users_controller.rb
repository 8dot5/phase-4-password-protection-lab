class UsersController < ApplicationController
    
    # before_action: a filter method that runs before this controller;  it throws a 401/unauthorized unless user is logged in
    before_action :authorize

    # this is a class method that tells Rails to skip the authorize filter for the Create action
    skip_before_action :authorize, only: [:create]

    rescue_from ActiveRecord::RecordInvalid, with: :render_unprocessable_entity
    

    # create a new user
    def create
        user = User.create!(user_params)
        session[:user_id] = user.id
        render json: user, status: :created
    end

    def show
        user = User.find(session[:user_id])
        render json: user, status: :ok
    end

    private

    def user_params
        params.permit(:username, :password, :password_confirmation)
    end

    def render_unprocessable_entity(invalid)
        render json: { errors: invalid.record.errors }, status: :unprocessable_entity
    end

    def authorize
        return render json: { error: "Not authorized" }, status: :unauthorized unless session.include? :user_id
    end
end

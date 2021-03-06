# frozen_string_literal: true

module Api
  module V1
    # Controller responsible to sign_up, sign_in and update the users
    class UsersController < ApplicationController
      before_action :user_authenticated?, only: %i[update reset_password validate_token]
      before_action :set_user, only: %i[update reset_password]

      def sign_up
        @user = User.new(user_params)

        if @user.save
          session[:user_id] = @user.id

          token = AuthenticationTokenService.call(@user.id)
          render json: { token: token }, status: 201
        else
          render json: { error: @user.errors.full_messages }, status: 400
        end
      rescue StandardError => e
        render json: { error: e.message }, status: 500
      end

      def sign_in
        @user = User.find_by(email: email_param)&.authenticate(password_param)

        if @user
          session[:user_id] = @user.id

          token = AuthenticationTokenService.call(@user.id)
          render json: { token: token }, status: 200
        else
          render json: { error: 'Email and/or password are incorrect' }, status: 400
        end
      rescue StandardError => e
        render json: { error: e.message }, status: 500
      end

      def update
        if @user.update(user_params)
          render json: { message: 'User updated' }, status: 200
        else
          render json: { error: @user.errors.full_messages }, status: 400
        end
      rescue StandardError => e
        render json: { error: e.message }, status: 500
      end

      def reset_password
        if @user.update(reset_password_params)
          render json: { message: 'Password updated' }, status: 200
        else
          render json: { error: @user.errors.full_messages }, status: 400
        end
      rescue StandardError => e
        render json: { error: e.message }, status: 500
      end

      def validate_token
        render json: { message: 'Valid token' }, status: 200
      end

      private

      def user_params
        params.require(:user).permit(:name, :email, :password, :password_confirmation)
      end

      def email_param
        request.headers['email'].to_s
      end

      def password_param
        Base64.decode64 request.headers['password'].to_s
      end

      def set_user
        @user = User.find(session[:user_id])
      end

      def reset_password_params
        params.require(:user).permit(:password, :password_confirmation)
      end
    end
  end
end

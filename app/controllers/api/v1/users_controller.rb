# frozen_string_literal: true

module Api
  module V1
    class UsersController < ApplicationController
      include ActionController::HttpAuthentication::Token::ControllerMethods
      # before_action :authenticate

      def show
        user = User.find(params[:id])
        render json: { data: user }
      end

      def create 
        user = User.new(user_params)
        if user.save
          render json: { data: user }
        else
          render  status: :unprocessable_entity, json: { message: user.errors.full_messages }
        end
      end

      def login
        user = User.find_by(name: params[:name])
        if !user.nil?
          render json: { data: user }
        else
          render status: :unprocessable_entity, json: { message: "ログインに失敗しました" }
        end
      end

      def current_user
        if !current_send_user.nil?
          render json: { data: current_user }
        else
          render status: :unprocessable_entity, json: { message: "ユーザーの取得に失敗しました" }
        end
      end

      private
        def user_params
          params.permit(:name)
        end

        def current_send_user
          authenticate_or_request_with_http_token do |token, _options|
            User.find_by(token: token)
          end
        end

        def authenticate
          authenticate_or_request_with_http_token do |token, _options|
            User.exists?(token: token)
          end
        end
    end
  end
end

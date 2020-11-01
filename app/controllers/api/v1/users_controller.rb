# frozen_string_literal: true

module api
  module v1
    class UsersController < ApplicationController
      # def index
      #   companies = User.for_send
      #   render json: { status: 'SUCCESS', data: companies }
      # end
      skip_before_action :authenticate_user, only: %i[create]

      def show
        user = User.find(params[:id])
        render json: { status: 'SUCCESS', data: user }
      end

      def create
        user = User.new(user_params)
        if user.save
          render json: { status: 'SUCCESS', data: user }
        else
          render json: { status: 'ERROR', message: user.errors.full_messages }
        end
      end

      def login
        user = User.find_by(name: params[:name])
        if user&.authenticate(params[:password])
          log_in(user)
          render json: { status: 'SUCCESS', data: user }
        else
          render json: { status: 'ERROR', message: 'ログインに失敗しました' }
        end
      end

      def logout
        log_out
      end

      private

      def user_params
        params.permit(:name)
      end
    end
  end
end

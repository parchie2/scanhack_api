module Api
  module V1
    module Users
      class ItemsController < ApplicationController
        include ActionController::HttpAuthentication::Token::ControllerMethods
        # before_action :authenticate
        def index
          items = current_send_user.items
          render json: { data: items }
        end

        # def show
        #   item = Item.find(params[:id])
        #   render json: { data: item }
        # end

        def create
          item = Item.new(item_params.merge(user_id: current_send_user.id))
          if item.save
            render json: { data: item }
          else
            render  status: :unprocessable_entity, json:{ message: item.errors.full_messages }
          end
        end

        private
        def item_params
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
end

# frozen_string_literal: true

class TestController < ApplicationController
  def index
    render json: { massege: "SUCCESS!" }
  end
end

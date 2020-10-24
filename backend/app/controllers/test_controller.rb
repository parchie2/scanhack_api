class TestController < ApplicationController
	def index
		render json: { massege: "SUCCESS!" } 
	end
end

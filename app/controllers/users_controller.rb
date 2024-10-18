class UsersController < ApplicationController
    before_action :authorize, only: [:index]

    def index
      users = User.all
      render json: users, status: :ok
    end
end
  
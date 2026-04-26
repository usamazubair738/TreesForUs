class UsersController < ApplicationController
  def index
    @users = User.all
  end

  def new
       @user = User.new
       @user.parent_id = params[:parent_id]
       @user.identification_type = params[:identification_type]
       @user.identification_number = params[:identification_number]
       @user.status = params[:status]
       @user.role = params[:role]   
    
    end

    def create
      @user = User.new(user_params)
      @user.parent_id = params[:parent_id]
      @user.identification_type = params[:identification_type]
      @user.identification_number = params[:identification_number]
      @user.status = params[:status]
      @user.role = params[:role]
      @user.save
      redirect_to user_profiles_show_path
    end

    def update
      @user = User.find(params[:id])
      @user.first_name = params[:first_name]
      @user.last_name = params[:last_name]
      @user.identification_type = params[:identification_type]
      @user.identification_number = params[:identification_number]
      @user.status = params[:status]
      @user.role = params[:role]
      @user.save
      redirect_to user_profiles_path
    end

    def destroy
      @user = User.find(params[:id])
      @user.destroy
      redirect_to user_profiles_path
    end

  private
    def user_params
      params.require(:user).permit(:first_name, :last_name, :identification_type, :identification_number, :status, :role)
    end
      
      
  def show    
    @user = User.find(params[:id])

  end

  def edit      
     @user = User.find(params[:id])
     @user.parent_id = params[:parent_id]
     @user.identification_type = params[:identification_type]
     @user.identification_number = params[:identification_number]
     @user.status = params[:status]
      @user.role = params[:role]
  end
end

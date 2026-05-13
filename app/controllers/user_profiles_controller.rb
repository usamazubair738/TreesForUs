class UserProfilesController < ApplicationController
  def index
    @user = current_user
  end

  def show
    @user = current_user
    @user_profile = @user.user_profile || @user.create_user_profile
  end

  def new
  end

  def edit
    @user = current_user
    @user_profile = @user.user_profile 
  end

  def update
    @user_profile = current_user.user_profile
    if @user_profile.update(user_profile_params)
       if params[:user_profile][:avatar].present?
        @user_profile.avatar.attach(params[:user_profile][:avatar])
      end
      redirect_to user_profile_path(current_user)
    else
      render :new
    end

    
  end

private

def user_profile_params
  params.require(:user_profile).permit(
    :avatar,
    :birth_date,
    :gender,
    :marital_status,
    :occupation,
    :address,
    :city,
    :state,
    :zip,
    :country,
    :phone,
    :nationality
  )
end
end

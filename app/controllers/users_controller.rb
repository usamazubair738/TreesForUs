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
  @user.parent_id             = params[:parent_id]
  @user.identification_type   = params[:identification_type]
  @user.identification_number = params[:identification_number]
  @user.status                = params[:status]
  @user.role                  = params[:role]
  @user.login_enabled = params[:login_enabled] == "true"
  unless @user.login_enabled?
    @user.email                 = nil
    @user.password              = nil
    @user.password_confirmation = nil
  end
  if @user.save
    if params[:family_id].present?
      FamilyMembership.create(
        user: @user,
        family_id: params[:family_id],
        membership_type: params[:membership_type] || :birth
      )
    end

    redirect_to user_profiles_show_path,
                notice: "Family member created successfully."
  else
    render :new, status: :unprocessable_entity
  end
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

  private

def user_params
  params.require(:user).permit(
    :first_name,
    :last_name,
    :email,
    :password,
    :password_confirmation,
    :login_enabled,
    user_profile_attributes: [
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
    ]
  )
end
end

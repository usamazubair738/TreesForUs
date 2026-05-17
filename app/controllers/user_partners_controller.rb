

class UserPartnersController < ApplicationController
  before_action :set_user

  def new
    @user_partner =UserPartner.new
    @available_users = User.where.not(id: @user.id)
  end

  def create
    @user_partner = UserPartner.new(user_partner_params)
    @user_partner.user = @user

    if @user_partner.save
      redirect_to @user, notice: "Spouse added successfully."
    else
      @available_users = User.where.not(id: @user.id)
      render :new, status: :unprocessable_entity
    end
  end

  private

  def set_user
    @user = User.find(params[:user_id])
  end

  def user_partner_params
    params.require(:user_partner).permit(:partner_id)
  end
end
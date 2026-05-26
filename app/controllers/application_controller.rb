class ApplicationController < ActionController::Base
  allow_browser versions: :modern
  include PublicActivity::StoreController

  before_action :set_current_user

  layout "application"

  def index
    if user_signed_in?
      redirect_to dashboard_path
    else
      redirect_to new_user_session_path
    end
  end

  private

  def set_current_user
    @user = current_user
  end
end
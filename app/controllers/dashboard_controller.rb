class DashboardController < ApplicationController
  def index
    @user = current_user
    @user_profile = @user.user_profile
    @root_member = User.includes(
    user_profile: { avatar_attachment: :blob },
    children: {
      user_profile: { avatar_attachment: :blob },
      children: { user_profile: { avatar_attachment: :blob } }
    }
  ).find(current_user.id)
    
  end
end

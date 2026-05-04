class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern
   layout "application"
   def index
    if user_signed_in?
      redirect_to dashboard_path 
    else
      redirect_to new_user_session_path
    end
  end
end

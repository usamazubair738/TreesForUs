
class InvitationsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_invitee

  def new
  
  end

  def create
    if @invitee.login_enabled?
      return respond_with_error("#{@invitee.first_name} already has app access.")
    end

    if @invitee.email.present? && @invitee.invitation_sent_at&.> 10.minutes.ago
      return respond_with_error("An invitation was already sent recently.")
    end

    email = params.dig(:invitation, :email).to_s.strip

    if email.blank?
      @invitee.errors.add(:email, "can't be blank")
      return render :new, status: :unprocessable_entity
    end

    # Persist email now so the mailer can address it
    @invitee.email = email
    raw_token = @invitee.invite!(invited_by: current_user)

    InvitationMailer.invite(@invitee, raw_token).deliver_later

    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: [
          turbo_stream.replace("modal", ""),
          turbo_stream.replace(
            "user_card_#{@invitee.id}",
            partial: "dashboard/family_tree_invited_badge",
            locals:  { node_user: @invitee }
          )
        ]
      end
      format.html { redirect_back fallback_location: root_path, notice: "Invitation sent!" }
    end
  end

  private

  def set_invitee
    @invitee = User.find(params[:user_id])
  end

  def respond_with_error(msg)
    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: turbo_stream.replace(
          "modal",
          partial: "shared/flash",
          locals:  { message: msg, type: :alert }
        )
      end
      format.html { redirect_back fallback_location: root_path, alert: msg }
    end
  end
end
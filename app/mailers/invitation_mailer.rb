class InvitationMailer < ApplicationMailer
  def invite(user, raw_token, email)
    @user         = user
    @invitation_url = accept_invitation_url(token: raw_token)
    mail(to: email, subject: "You've been invited to the family tree — set up your account")
  end
end
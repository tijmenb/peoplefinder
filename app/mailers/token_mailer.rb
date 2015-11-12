class TokenMailer < ApplicationMailer

  def new_token_email(token)
    @token = token

    mail to: @token.user_email
  end
end

class TokenMailerPreview < ActionMailer::Preview

  def new_token_email
    TokenMailer.new_token_email(FactoryGirl.build(:token))
  end
end

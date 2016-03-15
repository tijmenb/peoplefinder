require "omniauth/clientcert"

OmniAuth.config.full_host = ENV['FULL_HOST']

OmniAuth.config.on_failure = Proc.new { |env|
  OmniAuth::FailureEndpoint.new(env).redirect_to_failure
}

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :gplus, ENV['GPLUS_CLIENT_ID'], ENV['GPLUS_CLIENT_SECRET'],
    scope: 'openid,profile,email'
  provider :clientcert
end

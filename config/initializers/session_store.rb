# Be sure to restart your server when you modify this file.

require 'uri'
uri = URI(ENV['FULL_HOST'])
Rails.application.config.session_store :cookie_store, key: '_co_peoplefinder_session', domain: uri.host
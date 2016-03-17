# Be sure to restart your server when you modify this file.

if  Rails.env.production? or Rails.env.staging?
	Rails.application.config.session_store :cookie_store, :key => '_co_peoplefinder_session', :domain => 'peoplefinder.cabinetoffice.gov.uk'
else
	Rails.application.config.session_store :cookie_store, :key => '_co_peoplefinder_session'
end
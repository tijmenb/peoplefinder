module SpecSupport
  module AppConfig
    def app_title
      Rails.configuration.app_title
    end

    def brand
      Rails.configuration.brand
    end
  end
end

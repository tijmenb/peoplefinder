require 'omniauth'
require 'openssl'

module OmniAuth
  module Strategies
    class Clientcert
      include OmniAuth::Strategy

      uid do
        request.env['HTTP_SSL_CLIENT_SERIAL']
      end

      info do
        @info
      end

      def request_phase
        redirect callback_path
      end

      def callback_phase
        result = request.env['HTTP_SSL_CLIENT_VERIFY']
        if result != "SUCCESS"
          return fail!(:invalid_credentials, OmniAuth::Error.new('Invalid client certificate supplied by user'))
        end

        name = OpenSSL::X509::Name.parse request.env["HTTP_SSL_CLIENT_DN"]
        @info = {
          name: name,
          first_name: "Luke",
          last_name: "Sands",
          email:  "lsands@no10.x.gsi.gov.uk"
        }
        puts @info
        super
      end
    end
  end
end
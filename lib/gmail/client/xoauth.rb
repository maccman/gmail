require 'gmail_xoauth'

module Gmail
  module Client
    class XOAuth < Base
      attr_reader :token

      def initialize(username, options={})
        @token           = options.delete(:token)

        super(username, options)
      end

      def login(raise_errors=false)
        @imap and @logged_in = (login = @imap.authenticate('XOAUTH2', username, token)) && login.name == 'OK'
      rescue
        raise_errors and raise AuthorizationError, "Couldn't login to given GMail account: #{username}"
      end

      def smtp_settings
        [:smtp, {
           :address => GMAIL_SMTP_HOST,
           :port => GMAIL_SMTP_PORT,
           :domain => mail_domain,
           :user_name => username,
           :password => token,
           :authentication => :xoauth2,
           :enable_starttls_auto => true
         }]
      end
    end # XOAuth

    register :xoauth, XOAuth
  end # Client
end # Gmail

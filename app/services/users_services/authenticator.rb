module UsersServices
  class Authenticator
    class AuthenticationError < StandardError; end
    class ApiError < StandardError; end

    attr_reader :code, :user, :access_token

    PROVIDER = 'google'.freeze
    TOKEN_URL = 'https://www.googleapis.com/oauth2/v3/token'.freeze
    PROFILE_URL = 'https://www.googleapis.com/plus/v1/people/me/openIdConnect?access_token=%{access_token}'.freeze

    def initialize(code)
      @code = code
    end

    def perform
      raise AuthenticationError if code.blank?
      raise AuthenticationError if token.try(:error).present?

      prepare_user
      set_access_token
    end

    private

    def token
      @token ||= begin
        response = HTTParty.post(TOKEN_URL, token_options)
        print "TOKEN RESPONSE\n\n\n\n\n\n"
        print response
        response.parsed_response['access_token']
      end
    end

    def prepare_user
      user_data = get_user(token)
      @user = if User.exists?(login: user_data[:login])
                User.find_by(login: user_data[:login])
              else
                User.create(user_data.merge(provider: PROVIDER))
              end
    end

    def set_access_token
      @access_token = if user.access_token.present?
                        user.access_token
                      else
                        user.create_access_token
                      end
    end

    def get_user(access_token)
      @get_user ||= begin
        get_request(user_url(access_token)).parsed_response.symbolize_keys
      end
    end

    def user_url(access_token)
      PROFILE_URL % { access_token: access_token }
    end

    def token_options
      @token_options ||= {
        body: {
          code: code,
          client_id: ENV['GOOGLE_CLIENT_ID'],
          client_secret: ENV['GOOGLE_CLIENT_SECRET'],
          redirect_uri: 'postmessage',
          grant_type: 'authorization_code'
        }
      }
    end

    def get_request(url)
      response = HTTParty.get(url)
      unless response.code == 200
        Rails.logger.warn "#{PROVIDER} API request failed with status #{response.code}."
        Rails.logger.debug "#{PROVIDER} API error response was:\n#{response.body}"
        raise AuthenticationError
      end
      response
    end
  end
end
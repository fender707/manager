class AccessTokensController < ApplicationController
  before_action :authorize!, only: :destroy

  def create
    authenticator = UsersServices::Authenticator.new(authentication_params)
    authenticator.perform

    render json: authenticator.access_token, status: :created
  end

  def destroy
    current_user.access_token.destroy
  end

  private

  def authentication_params
    print "params.permit(:code)\n\n\n\n"
    print params.permit(:code)
    print "authentication_params \n\n\n\n\n\n\n\n"
    print params.permit(:code).to_h.symbolize_keys
    params.permit(:code).to_h.symbolize_keys
  end
end

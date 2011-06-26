class OpenidSessionsController < ApplicationController
  skip_before_filter :verify_authenticity_token

  def new
    response.headers['WWW-Authenticate'] = Rack::OpenID.build_header(
        :identifier => "https://www.google.com/accounts/o8/id",
        :required => ["http://axschema.org/contact/email",
                      "http://axschema.org/namePerson/first",
                      "http://axschema.org/namePerson/last"],
        :return_to => openid_sessions_url,
        :method => 'POST')
        head 401
  end 

  def create 
    if openid = request.env[Rack::OpenID::RESPONSE]
      case openid.status
      when :success
        ax = OpenID::AX::FetchResponse.from_success_response(openid)
        user = User.where(:openid_identifier => openid.display_identifier).first
        user ||= User.create!(:openid_identifier => openid.display_identifier,
                              :email => ax.get_single('http://axschema.org/contact/email'))
        @current_user = user
        session[:user_id] = user.id
        redirect_to user_path :id => user.id
      when :failure
        puts "complete failure :("
        p openid 
        redirect_to new_user_session_path
      end
    else
      redirect_to new_user_session_path
    end
  end 

end 

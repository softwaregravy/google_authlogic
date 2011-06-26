class UserSessionsController < ApplicationController
  before_filter :require_no_user, :only => [:new, :create]
  before_filter :require_user, :only => :destroy
  skip_before_filter :verify_authenticity_token

  def new
    response.headers['WWW-Authenticate'] = Rack::OpenID.build_header(
        :identifier => "https://www.google.com/accounts/o8/id",
        :required => ["http://axschema.org/contact/email",
                      "http://axschema.org/namePerson/first",
                      "http://axschema.org/namePerson/last"],
        :return_to => user_sessions_url,
        :method => 'POST')
        head 401
    #@user_session = UserSession.new
  end

  def create
    if openid = request.env[Rack::OpenID::RESPONSE]
      case openid.status
      when :success
        ax = OpenID::AX::FetchResponse.from_success_response(openid)
        user = User.where(:openid_identifier => openid.display_identifier).first
        user ||= User.create!(:openid_identifier => openid.display_identifier,
                              :email => ax.get_single('http://axschema.org/contact/email'))
        session[:user_id] = user.id
        redirect_to(session[:redirect_to] || root_path)
      when :failure
        raise "balls"
      end
    else
      redirect_to new_user_session_path
    end
#    if params['commit'].match(/Google/)
#      # probably want to build in a better way than this
#      open_id_authentication
#    else 
#      @user_session = UserSession.new(params[:user_session])
#
#      @user_session.save do |result|
#        if result
#          successful_login
#        else
#          failed_login
#        end
#      end
#    end 
  end

  def destroy
    session[:user_id] = nil
#    current_user_session.destroy
#    flash[:notice] = "Logout successful!"
    redirect_back_or_default new_user_session_url
  end

  private 

  def successful_login 
    session[:user_id] = @current_user.id
    flash[:notice] = "Login successful!"
    redirect_back_or_default new_user_session_url
  end 

  def failed_login(message = nil) 
    render :action => :new
  end 

  def open_id_authentication 
    authenticate_with_open_id("john.hinnegan@gmail.com") do |result, identity_url, ax_response|
      if result.successful?
        p ax_response
        email = ax_response['http://axschema.org/contact/email'].first()
        p email
        if @current_user = User.find_by_email(email)
          successful_login
        else
          failed_login "Sorry, no user by that identity URL exists (#{identity_url})"
        end
      else
        failed_login result.message
      end
    end
  end 
end


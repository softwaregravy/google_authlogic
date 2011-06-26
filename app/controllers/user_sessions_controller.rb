class UserSessionsController < ApplicationController
  before_filter :require_no_user, :only => [:new, :create]
  before_filter :require_user, :only => :destroy

  def new
    @user_session = UserSession.new
  end

  def create
    @user_session = UserSession.new(params[:user_session])
    @user_session.save do |result|
      if result
        session[:user_id] = @current_user.id
        flash[:notice] = "Login successful!"
        redirect_to user_path(@user)
      else
        render :action => :new
      end
    end
  end

  def destroy
    session[:user_id] = nil
    current_user_session.destroy 
    flash[:notice] = "Logout successful!"
    redirect_back_or_default new_user_session_url
  end

end


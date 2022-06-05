class SessionsController < ApplicationController

  def new
    
  end

  # the create action logs in a user
  def create
    # fail
    # when we submit data through a form that has the url option instead of the model option, we get all the submitted params on the top level

    # 1. Authenticate the user 
    # First check if the email exists in the db
    # if it does not, user will be equal to nil, otherwise we get back to user object
    user = User.find_by(email: params[:email])

    # then we need to check if the typed in password matches the password in the db.
    # the has_secure_password option in the user model provides an authenticate method for this
    # if the passwords match, the user object is returned, if they don't we get back false

    # first, we check if the user is not nil, then try to authenticate him
    if user && user.authenticate(params[:password])
      # if the user is authenticated, we store his id in the session
      session[:user_id] = user.id
      flash[:notice] = "Welcome back, #{user.name}!"
      # if we setup an intended url before we got redirected to this action, then after signing in, we'll get redirected to the intended url. If not, we get redirected to our profile page
      redirect_to (session[:intended_url] || user_path(user))
      # then we need to clear the intended_url key from the session
      session[:intended_url] = nil
    else
      # render does NOT issue a new http request
      # but by default flash messages only appear at the next new request
      # so, to flash the message right away, we need to use flash.now
      flash.now[:alert] = "Invalid email or password! Try again!"
      render :new
    end
  end

  def destroy
    # signing out a user by deleting his id from the session
    session[:user_id] = nil
    redirect_to events_url, notice: "You are now signed out!"
  end
end

class ApplicationController < ActionController::Base

  # private methods are not exposed as actions. This means we cannot make a route that runs these methods
  private

  def current_user
    # we fetch the currently signed in user only if there is a signed in user
    User.find(session[:user_id]) if session[:user_id]
  end

  # this declaration makes the current_user method available as a view helper as well
  helper_method :current_user

  # this method checks if the passed in user is the same as the currently signed in user
  def current_user?(user)
    current_user == user
  end

  helper_method :current_user?

  def current_user_admin?
    current_user && current_user.admin?
  end

  helper_method :current_user_admin?

  # put this method in the ApplicationController, so it is available to all controllers
  def require_signin
    # if user is already signed in (current_user is not nil) the method will not redirect
    unless current_user
      # we put the url a not logged in user tries to visit in the session hash
      # the request.url method stores the url we try to visit
      # the session will be set in a cookie and will be sent to the sign in page when we redirect
      puts "REQUESTED URL: #{request.url}"
      session[:intended_url] = request.url
      redirect_to new_session_url, alert: "You have to be signed in first!"
    end
  end

  def require_admin
    unless current_user_admin?
      redirect_to events_url, alert: "Unauthorized access"
    end
  end

  

end

class UsersController < ApplicationController

  # set up a gatekeeper method
  # it will redirect to the user to the signin page before every action, except new and create
  # require_signin is defined in the ApplicationController, so it is available from any controllers
  before_action :require_signin, except: [:new, :create]

  # the second gatekeeper method makes sure that the action only run if the currently signed in user is the correct user
  before_action :require_correct_user, only: [:edit, :update, :destroy]

  # The order of before_action methods matter. They are executed from top to bottom. 
  # If any of them redirects, the before_actions below it won't run


  def index
    @users = User.all
  end

  def show
    @user = User.find(params[:id])
    @registrations = @user.registrations
    @liked_events = @user.liked_events
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    if @user.save
      # if a new user account is created we immediately sign her in by putting her id in the session
      session[:user_id] = @user.id
      flash[:notice] = "Thanks for signing up"
      redirect_to user_path(@user)
    else
      render :new
    end
  end

  def edit
    # we can remove this line from the edit, update and destroy actions, since it is defined in the require_correct_user method
    # @user = User.find(params[:id])
  end

  def update
    if @user.update(user_params)
      redirect_to @user, notice: "Account was successfully updated"
    else
      render :edit
    end
  end

  def destroy
    @user.destroy
    # when a user deletes his account, we also need to clear his id from the session
    session[:user_id] = nil
    redirect_to events_url, alert: "Account successfully deleted"
  end



  private

    def user_params
      params.require(:user)
        .permit(:name, :email, :password, :password_confirmation)
    end

    # since require_correct_user will only be used in the UsersController, we can define it here
    def require_correct_user
      # first we fetch the user whose profile page we want to access
      @user = User.find(params[:id])
      # then we check if this user is the same as the currently signed in user
      # current_user? is defined in the ApplicationController
      redirect_to events_url, alert: "Unauthorized action!" unless current_user?(@user)
    
    end
end

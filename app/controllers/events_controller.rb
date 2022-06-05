class EventsController < ApplicationController

  before_action :require_signin, except: [:index, :show]
  before_action :require_admin, except: [:index, :show]
  before_action :set_event, only: [:show, :edit, :update, :destroy]

  def index
    case params[:show_only]
    when "upcoming" 
      @events = Event.upcoming
    when "free"
      @events = Event.free
    when "recent"
      @events = Event.recent
    when "past"
      @events = Event.past
    else
      @events = Event.all
    end
  end

  def show
    # fail
    # params[:id] contains the slug, not the actual id of the event
    # so we need to change how we find an event
    # @event = Event.find(params[:id])
    # @event = Event.find_by!(slug: params[:id])
    @likers = @event.likers

    # we need to determine whether the current user already liked this event or not
    # we can check if there is a row in the likes table that has this event's id and the current user's id

    # current_user.likes returns only those row where the user_id coloum equals the current_user's 
    # then we can further run the find_by method on the subset of records to further scope down to those records where the event_id coloum equals the this event's is
    # Rails will generate only one SQL query to do this
    # this query returns a like object or nil
    # we only want to query for the like object if the user is signed in
    if current_user
      @like = current_user.likes.find_by(event_id: @event.id)
    end

    @categories = @event.categories
  end

  def edit
    # @event = Event.find(params[:id])
  end

  def update
    # @event = Event.find(params[:id])
    if @event.update(event_params)
      flash[:notice] = "Event successfully updated"
      redirect_to @event
    else
      render :edit
    end
    
  end

  def new
    @event = Event.new
  end

  def create
    @event = Event.new(event_params)
    if @event.save
      redirect_to @event, notice: "Event successfully created"
    else
      render :new
    end
  end

  def destroy
    # @event = Event.find(params[:id])
    @event.destroy
    redirect_to events_url
  end

  private

  def event_params
    params
      .require(:event)
      # the category_ids attribute will be passed as an array, so we need to specify it as an array
      .permit(:name, :description, :location, :price, :starts_at, :capacity, :image_file_name, category_ids: [])
  end

  def set_event
    @event = Event.find_by!(slug: params[:id])
  end
end

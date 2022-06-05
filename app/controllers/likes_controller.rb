class LikesController < ApplicationController

  before_action :require_signin

  def create
    # to create a like, we need to two pieces of information
    # an event and a user
    # the event id is embedded in the url as a url param
    @event = Event.find_by!(slug: params[:event_id])
    # the user is the currently signed in user, current_user
    # current_user should never be nil, because we only show the like button is the user is signed in
    # but as a safe guard, it's best to require a signed in user in the controller
    @like = @event.likes.create!(user: current_user)

    redirect_to event_path(@event)
  end

  def destroy
    # we have to make sure we can only delete the like that belongs to the current user
    like = current_user.likes.find(params[:id])
    like.destroy

    # redirect to the event's show page
    event = Event.find_by!(slug: params[:event_id])
    redirect_to event
  end
end

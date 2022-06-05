class RegistrationsController < ApplicationController

  before_action :require_signin
  before_action :set_event

  def index
    # passing the event id in a query parameter, ...?event_id=1
    # the the params hash also captures url paramters, like :id
    # @event = Event.find(params[:event_id])
    @registrations = @event.registrations
  end

  def new
    @registration = @event.registrations.new
  end

  def create
    @registration = @event.registrations.new(registration_params)
    @registration.user = current_user

    if @registration.save
      flash[:notice] = "Thanks for registering"
      redirect_to event_registrations_path(@event)
    else
      render :new
    end
  end

  private

    def registration_params
      params.require(:registration).permit(:how_heard)
    end

    def set_event
      @event = Event.find_by!(slug: params[:event_id])
    end
end

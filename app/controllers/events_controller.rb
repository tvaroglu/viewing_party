class EventsController < ApplicationController

  def new
    @event = Event.new
  end

  def create
    event = event_params
    event[:event_time] = Time.parse(event_params['event_time(1i)'] + '-' + event_params['event_time(2i)'] + '-' + event_params['event_time(3i)'] + '-' + event_params['event_time(4i)'] + '-' + event_params['event_time(5i)'])
    new_event = current_user.events.create(event)
    # if new_event.runtime < movie_runtime...
      # render :new
      # redirect_to new_event_path(params[:movie_id]) <-- movie details params
      # flash[:alert] = "Error: Event runtime cannot be less than the movie runtime."
    if new_event.save
      params[:invited].each { |user| Attendee.create(event: new_event, user: User.find_by(email: user)) }
      Attendee.create(event: new_event, user: current_user)
      redirect_to dashboard_path(current_user.id)
      flash[:alert] = "New viewing party successfully created for #{new_event.movie_title}!"
    else
      # require "pry"; binding.pry
      redirect_to new_event_path
      flash[:alert] = "Error: #{error_message(new_event.errors)}"
    end
  end



  private

  def event_params
    params.require(:event).permit(:user_id, :movie_title, :event_date, :event_time, :runtime)
  end
end

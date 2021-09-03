class EventsController < ApplicationController
  def new
    @event = Event.new
  end

  def create
    event_params[:event_time] = ApplicationRecord.parse_event_time(event_params)
    new_event = current_user.events.create(event_params)
    if new_event.save && !params[:invited].nil?
      params[:invited].each { |user| Attendee.create(event: new_event, user: User.find_by(email: user)) }
      Attendee.create(event: new_event, user: current_user)
      redirect_to dashboard_path(current_user.id)
      flash[:alert] = "New viewing party successfully created for #{new_event.movie_title}!"
    else
      redirect_to new_event_path({ movie_id: event_params[:movie_id], movie_title: event_params[:movie_title], runtime: event_params[:runtime] })
      flash[:alert] = "Error: #{error_message(new_event.errors)}"
      if params[:invited].nil?
        new_event.destroy if new_event
        flash[:alert] = "Error: You must invite followers to your party, #{error_message(new_event.errors)}"
      end
    end
  end

  private

  def event_params
    params.require(:event).permit(:user_id, :movie_id, :movie_title, :event_date, :event_time, :runtime)
  end
end

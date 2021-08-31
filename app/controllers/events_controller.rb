class EventsController < ApplicationController

  def new
    @event = Event.new
  end

  def create
    require "pry"; binding.pry
    new_event = Event.create(event_params)
    # if new_event.runtime < movie_runtime...
      # render :new
      # redirect_to new_event_path(params[:movie_id]) <-- movie details params
      # flash[:alert] = "Error: Event runtime cannot be less than the movie runtime."
    if new_event.save
      redirect_to dashboard_path(current_user.id)
      flash[:alert] = "New viewing party successfully created for #{new_event.movie_title}!"
    else
      redirect_to new_event_path
      flash[:alert] = "Error: #{error_message(new_event.errors)}"
    end
  end



  private

  def event_params
    params.require(:event).permit(:movie_title, :event_date, :event_time, :runtime)
  end
end

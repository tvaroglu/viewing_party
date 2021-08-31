class MoviesController < ApplicationController
  def discover
    if params[:format]
      @results = MovieFacade.search_results(params[:format])
    end
  end

  def search
    search_criteria = params[:search_criteria]
    redirect_to discover_path(search_criteria)
  end

  def most_popular
    @results = MovieFacade.most_popular
  end

  def show
    movie_id = params[:format]
    @movie = MovieFacade.movie_details(movie_id)
  end
end

class MoviesController < ApplicationController
  def discover
    if params[:format]
      @config_details = MovieFacade.config
      @results = MovieFacade.search_results(params[:format])
    end
  end

  def search
    search_criteria = params[:search_criteria]
    redirect_to discover_path(search_criteria)
  end

  def most_popular
    @config_details = MovieFacade.config
    @results = MovieFacade.most_popular
  end

  def upcoming
    @config_details = MovieFacade.config
    @results = MovieFacade.upcoming
  end

  def show
    movie_id = params[:format]
    @config_details = MovieFacade.config
    @movie = MovieFacade.movie_details(movie_id)
    @reviews = MovieFacade.movie_reviews(movie_id)
    @cast = MovieFacade.movie_cast(movie_id)
  end
end

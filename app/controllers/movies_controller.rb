class MoviesController < ApplicationController
  def discover
    if params[:format]
      @search_results = MovieService.search_results(params[:format])
    end
  end

  def search
    search_criteria = params[:search_criteria]
    redirect_to discover_path(search_criteria)
  end

  def top_rated; end
end

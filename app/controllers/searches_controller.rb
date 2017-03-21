class SearchesController < ApplicationController

  def new
  end

  def create
    search = SearchService.new(search_params)
    @search_query = search.search_query
    @results = search.results
  end

  private
    def search_params
      params.require(:search).permit(:query)
    end


end
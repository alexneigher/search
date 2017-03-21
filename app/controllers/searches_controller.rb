class SearchesController < ApplicationController
  before_action :find_popular_searches, except: :create

  def new
  end

  def create
    search = SearchService.new(search_params)
    @search_query = search.search_query
    @results = search.results
  end

  def show
    @search = ProductSearch.includes(:results).find_by(query: params[:query])
    redirect_to root_path and return unless @search
  end

  private
    def search_params
      params.require(:search).permit(:query)
    end

    def find_popular_searches
      @popular_searches = ProductSearch.popular_searches
    end


end
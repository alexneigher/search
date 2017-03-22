module Admin
  class SearchesController < ApplicationController
    layout 'admin'

    def index
      @cached_product_searches = ProductSearch.recently_cached
      @expired_product_searches = ProductSearch.cache_expired
    end

    def show
      @product_search = ProductSearch.find(params[:id])
    end

    def update
      @product_search = ProductSearch.find(params[:id])
      @product_search.update(admin_product_search_params)
      redirect_to admin_searches_path
    end

    def new
      @product_search = ProductSearch.new
    end

    def create
      PrefetchCacheJob.perform_later(admin_product_search_params[:query])
      flash[:warning] = 'Fetching and caching the results now!'
      redirect_to admin_searches_path
    end

    #non restful route
    def fetch_new_cache
      @product_search = ProductSearch.find(params[:search_id])
      query = @product_search.query
      
      PrefetchCacheJob.perform_later(query)

      flash[:warning] = 'This task may take some time'
      
      redirect_to admin_searches_path
    end

    private
      def admin_product_search_params
        params.require(:product_search).permit(:cached_at, :query)
      end

  end

end
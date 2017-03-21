class SearchService

  attr_accessor :search_query

  def initialize(search_params)
    @search_query = search_params[:query].downcase
  end

  def results
    if cached_product_search.present?
      product_search = cached_product_search
    else
      product_search = create_product_search!
    end

    product_search.results
  end

  private

    def cached_product_search
      # caching strategy here refreshes a result 1 time per week.
      # read all about pros/cons at ~/README.md

      @cached_product_search ||= ProductSearch
                                  .includes(:results)
                                  .where(query: search_query)
                                  .where('cached_at >= ?', 7.days.ago)
    end

    def create_product_search!
      SearchCreatorService.new(search_query).perform
    end
end
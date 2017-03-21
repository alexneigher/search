require 'semantics3'

class SearchCreatorService

  def initialize(query)
    @query = query
  end

  def perform
    sem3.products_field("search", @query)
    data = sem3.get_products()
    populate_product_search_and_results(data)
  end

  private

    def populate_product_search_and_results(data)
      raise "API Error" unless data["results"].present?

      product_search = ActiveRecord::Base.transaction do
                        product_search = create_or_refresh_product_search
                        populate_results(product_search, data)
                        return product_search
                       end

    end

    def create_or_refresh_product_search
      product_search = ProductSearch.expired_result_for(@query)
      
      if product_search.present?
        product_search.cached_at = Date.current
        product_search.results.destroy_all #TODO, can refactor into SQL "delete from results, where..."
      else
        #create a new one
        product_search = ProductSearch.create(query: @query, cached_at: Date.current)
      end

      return product_search
    end

    def populate_results(product_search, data)
      results = []
      
      50.times do
        results << product_search.results.new(description: 'hey')
      end

      Result.import results
    end

    def sem3
      @sem3 ||= Semantics3::Products.new(ENV['SEMANTICS_KEY'], ENV['SEMANTICS_SECRET'])
    end

end
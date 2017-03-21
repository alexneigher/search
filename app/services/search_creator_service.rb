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

      product_search = create_or_refresh_product_search

      5.times do
        product_search.results.build(description: 'description')
      end

      return product_search if product_search.save!
    end

    def create_or_refresh_product_search
      product_search = ProductSearch.expired_result_for(@query)
      
      if product_search.present?
        product_search.cached_at = Date.current
        product_search.results.destroy_all
      else
        #create a new one
        product_search = ProductSearch.create(query: @query, cached_at: Date.current)
      end

      return product_search
    end

    def sem3
      @sem3 ||= Semantics3::Products.new(ENV['SEMANTICS_KEY'], ENV['SEMANTICS_SECRET'])
    end

end
class PrefetchCacheJob < ApplicationJob

  def perform(query)
    SearchCreatorService.new(query).perform
  end
end
class ArticleUpdateJob < ApplicationJob
  queue_as :default

  def perform()
    Journal.find_each(&:refresh)
  end
end

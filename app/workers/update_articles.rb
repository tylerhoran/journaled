require 'sidekiq-scheduler'

class UpdateArticles
  include Sidekiq::Worker

  def perform
    Journal.refresh
  end
end

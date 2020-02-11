class Journal < ApplicationRecord
  has_and_belongs_to_many :users
  has_many :articles, dependent: :destroy
  validates :issn, uniqueness: true

  def self.refresh
    find_each(&:refresh)
  end

  def refresh
    tries = 0
    new_articles = []
    backlog = true
    begin
      if articles.any?
        response = Serrano.journals(
          ids: issn,
          limit: 500,
          sort: 'published',
          works: true,
          order: 'desc',
          filter: { "from-pub-date" => (Date.yesterday - 1.day).to_s}
        )
        backlog = false
      else
        response = Serrano.journals(
          ids: issn,
          limit: 1000,
          sort: 'published',
          works: true,
          order: 'desc'
        )
      end
    rescue => e
      tries += 1
      Rails.logger.debug(e)
      retry if tries < 3
    end
    response.each do |journal_articles|
      journal_articles['message']['items'].each do |article|
        found = Article.find_by(doi: article['DOI'])
        unless found
          new_article = Article.create(
            date: article['created']['date-time'],
            journal: Journal.find_by(issn: article['ISSN']),
            author: article['author'] ? article['author'].map { |a| "#{a['family']}, #{a['given']}" }.to_sentence : nil,
            name: article['title']&.first,
            doi: article['DOI']
          )
          new_articles << new_article if new_article.persisted?
        end
      end
    end
    if new_articles.length > 0 && backlog == false
      users.each do |user|
        begin
          UserMailer.notify_new_issue(user, self, new_articles).deliver_now if user.issue_alerts
        rescue => e
          Rails.logger.debug e
        end
      end
    end
  end
end

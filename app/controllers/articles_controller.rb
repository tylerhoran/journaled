class ArticlesController < ApplicationController
  before_action :authenticate_user!
  before_action :check_for_journals

  def index
    @q = Article.ransack(params[:q])
    @q.sorts = 'date desc' if @q.sorts.empty?
    @articles = @q.result(distinct: true).includes(:journal, :users).where(users: { id: current_user.id }).page(params[:page])
  end

  def show
    @article = Article.find(params[:id])
  end

  def create
    current_user.refresh_articles
    redirect_to articles_path
  end

  private

  def check_for_journals
    redirect_to new_journal_path if current_user.journals.empty?
  end
end

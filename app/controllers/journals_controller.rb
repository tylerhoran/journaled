class JournalsController < ApplicationController
  before_action :authenticate_user!

  def index
    @journals = current_user.journals.page(params[:page])
  end

  def destroy
    @journal = Journal.find(params[:id])
    current_user.journals.delete(@journal)
    redirect_to journals_path
  end

  def new
    if params[:journal] && params[:journal][:name]
      @journals = Serrano.journals(query: journal_params[:name])
    end
    @journal = Journal.new
  end

  def create
    @journal = Journal.find_or_create_by(journal_params)
    unless current_user.journals.include?(@journal)
      current_user.journals << @journal
    end
    redirect_to journals_path
  end

  private

  def journal_params
    params.require(:journal).permit(:issn, :name)
  end

end

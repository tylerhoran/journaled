class UserMailer < ApplicationMailer
  def notify_new_issue(user, journal, new_articles)
    @journal = journal
    @articles = new_articles
    mail(to: user.email, from: "journal@notifier.com", subject: "Articles Available in New Issue of #{journal.name}")
  end
end

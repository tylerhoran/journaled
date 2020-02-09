require 'clockwork'
require './config/boot'
require './config/environment'
include Clockwork

handler do |job|
  puts "Running #{job}"
end

every(6.hours, 'update.articles') { ArticleUpdateJob.perform_later }

require 'nokogiri'
require 'open-uri'

class Falcor
  include ScheduledJob

  run_every 60.seconds

  def perform
    # poll Brandon's redmine feed and whenever we have a new
    # item, play the falcor sound
    feed = "https://redmine.spice.spiceworks.com/activity.atom?key=1d13e8fa38daa2807cbd919a6ce1a23facabff4d&show_issues=1&user_id=110"
    doc = Nokogiri::HTML(open(url))
    @last_poll = DateTime.now - 60.seconds
    doc.css("entry").each do |commit|
      if should_alert?(commit)
        `wget http://scary/play/Falcor`
      end
    end
  end

  def should_alert?(commit)
    (Date.parse(commit.css('updated')) > @last_poll) && commit.css('title') =~ /\(New\)/
  end

end

require 'nokogiri'
require 'open-uri'

class Falcor
  include ScheduledJob

  run_every 60.seconds

  def perform
    poll
  end

  def poll
    # poll Brandon's redmine feed and whenever we have a new
    # item, play the falcor sound
    feed = "https://redmine.spice.spiceworks.com/activity.atom?key=1d13e8fa38daa2807cbd919a6ce1a23facabff4d&show_issues=1&user_id=110"
    doc = Nokogiri::XML(open(feed))
    @last_poll = DateTime.now - 60.seconds
    should_play = false
    doc.css("entry").each do |commit|
      if is_recent?(commit) && should_alert?(commit)
        should_play = true
        break
      end
    end
    if should_play
      puts "Unleashing the dragon!"
      `curl http://scary/play/Falcor`
    end
  end

  def is_recent?(commit)
    return Date.parse(commit.css('updated').first.content) > @last_poll
  end

  def should_alert?(commit)
    return commit.css('title').first.content =~ /\(New\)/ && 
    ConfigurationValue.participants.include?(get_assignee(commit)[:name])
  end

  def get_assignee(commit)
    # get the commit to pull out the assignee
    # returns a hash with the user's ID and name
    ticket_url = commit.css('link').first['href']
    ticket = Nokogiri::HTML(open(ticket_url))
    assigned_to = ticket.css('td.assigned-to a').first
    {
      :id => assigned_to['href'].split('/').last,
      :name => assigned_to.content
    }
  end

end

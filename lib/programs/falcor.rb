require 'nokogiri'
require 'open-uri'

class Falcor
  include ScheduledJob

  run_every 60.seconds

  def feed
    "https://redmine.spice.spiceworks.com/activity.atom?key=1d13e8fa38daa2807cbd919a6ce1a23facabff4d&show_issues=1&user_id=110"
  end

  def perform
    poll
  end

  def poll
    # poll Brandon's redmine feed and whenever we have a new
    # item, play the falcor sound
    doc = Nokogiri::XML(open(feed))
    should_play = false
    commits = doc.css("entry")
    commits.each do |commit|
      if is_recent?(commit) && should_alert?(commit)
        should_play = true
        break
      end
    end
    unleash_the_dragon if should_play
    # store last time, commits are most recent first
    ConfigurationValue.create_or_update('falcor_last_time_logged', get_time(commits.first).to_s)
  end

  def is_recent?(commit)
    unless @last_checked
      date = ConfigurationValue.value('falcor_last_time_logged') || (Time.now - 60.seconds).to_s
      @last_checked = Time.parse(date)
    end
    return get_time(commit) > @last_checked
  end

  def should_alert?(commit)
    return (commit.css('title').first.content =~ /\(New|Reopened\)/ || 0) > 0 && 
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

  def get_time(commit)
    return Time.parse(commit.css('updated').first.content)
  end

  def unleash_the_dragon
    puts "Unleashing the dragon!"
    `curl http://scary/play/Falcor`
  end

end

require 'test_helper'

class FalcorTest < ActiveSupport::TestCase

  test "can scrape assignee of ticket from HTML" do

    mock_redmine_ticket_request
    assignee = Falcor.new.get_assignee(mock_commit)
    assert_equal "Jack Jones", assignee[:name]
  end

  test "should_alert? works as expected" do
    ConfigurationValue.stubs(:participants).returns(['Jack Jones'])
    falcor = Falcor.new
    # this should return true
    mock_redmine_ticket_request
    assert falcor.should_alert?(mock_commit)
    # this shouldn't return true
    assert !falcor.should_alert?(mock_commit("Verified Internal"))
    # this shouldn't return true
    mock_redmine_ticket_request "Frank White"
    assert !falcor.should_alert?(mock_commit)
  end

  test "can scrape time of ticket from HTML" do
    falcor = Falcor.new
    assert_equal Time.parse('2012-07-02T05:15:23-05:00'), falcor.get_time(mock_commit)
  end

  test "is_recent? works as expected" do
    # this should return true
    falcor = Falcor.new
    test_date = Time.parse('2012-07-02T05:15:23-05:00') - 100.seconds
    ConfigurationValue.create_or_update('falcor_last_time_logged', test_date.to_s)
    assert falcor.is_recent?(mock_commit)
    # this should return false
    falcor = Falcor.new
    test_date = Time.parse('2012-07-02T05:15:23-05:00') + 100.seconds
    ConfigurationValue.create_or_update('falcor_last_time_logged', test_date.to_s)
    assert !falcor.is_recent?(mock_commit)
  end

  test "poll attempts to play Falcor sound" do
    # we have to have an item in the feed 
    feed = "http://example.com/feed/user/1"
    Falcor.any_instance.stubs(:feed).returns(feed)
    mock_redmine_feed_request(feed)
    # that is assigned to a participant, 
    ConfigurationValue.stubs(:participants).returns(['Jack Jones'])
    # that is also recent enough
    test_date = Time.parse('2012-07-02T05:15:23-05:00') - 100.seconds
    ConfigurationValue.create_or_update('falcor_last_time_logged', test_date.to_s)
    # to play the sound
    Falcor.any_instance.expects(:unleash_the_dragon).once
    falcor = Falcor.new
    falcor.poll
  end

  test "poll doesn't attempt to play Falcor sound due to no participants" do
    # we have to have an item in the feed 
    feed = "http://example.com/feed/user/1"
    Falcor.any_instance.stubs(:feed).returns(feed)
    mock_redmine_feed_request(feed)
    # that is not assigned to a participant, 
    ConfigurationValue.stubs(:participants).returns(['Frank White'])
    # that is also recent enough
    test_date = Time.parse('2012-07-02T05:15:23-05:00') - 100.seconds
    ConfigurationValue.create_or_update('falcor_last_time_logged', test_date.to_s)
    # to play the sound
    Falcor.any_instance.expects(:unleash_the_dragon).never
    falcor = Falcor.new
    falcor.poll
  end

  test "poll doesn't attempt to play Falcor sound due to old commits" do
    # we have to have an item in the feed 
    feed = "http://example.com/feed/user/1"
    Falcor.any_instance.stubs(:feed).returns(feed)
    mock_redmine_feed_request(feed)
    # that is assigned to a participant, 
    ConfigurationValue.stubs(:participants).returns(['Jack Jones'])
    # that is too old
    test_date = Time.parse('2012-07-02T05:15:23-05:00') + 100.seconds
    ConfigurationValue.create_or_update('falcor_last_time_logged', test_date.to_s)
    # to play the sound
    Falcor.any_instance.expects(:unleash_the_dragon).never
    falcor = Falcor.new
    falcor.poll
  end

  test "poll sets the correct last checked date" do
    test_date = Time.parse('2012-07-02T06:07:57-05:00') - 100.seconds
    ConfigurationValue.create_or_update('falcor_last_time_logged', test_date.to_s)
    # stub the feed so we don't actually hit Redmine
    feed = "http://example.com/feed/user/1"
    Falcor.any_instance.stubs(:feed).returns(feed)
    mock_redmine_feed_request(feed)
    # stub the play method so we don't actually play the sound
    Falcor.any_instance.stubs(:unleash_the_dragon)
    # poll
    falcor = Falcor.new
    falcor.poll
    # check timestamp
    assert_equal (test_date + 100.seconds).to_s, ConfigurationValue.find_by_key('falcor_last_time_logged').value
  end

  test "falcor doesn't bomb on the first run" do
    # stub the feed so we don't actually hit Redmine
    feed = "http://example.com/feed/user/1"
    Falcor.any_instance.stubs(:feed).returns(feed)
    mock_redmine_feed_request(feed)
    # stub the play method so we don't actually play the sound
    Falcor.any_instance.stubs(:unleash_the_dragon)
    # poll
    falcor = Falcor.new
    falcor.poll
  end

  private

  def mock_commit(type = "New")
    Nokogiri::XML(
      <<-eos
      <entry>
        <title>Desktop - Bug #12345 (#{type}): A Test Bug</title>
        <link href="https://example.com/issues/12345" rel="alternate"/>
        <id>https://example.com/issues/12345</id>
        <updated>2012-07-02T05:15:23-05:00</updated>
        <author>
          <name>Joe Smith</name>
          <email>joe@example.com</email>
        </author>
        <content type="html">
          This is a test ticket
        </content>
      </entry>
      eos
    )
  end

  def mock_redmine_ticket_request(assignee = "Jack Jones")
    FakeWeb.register_uri(:get, "https://example.com/issues/12345", :body => mock_redmine_ticket(assignee))
  end

  def mock_redmine_ticket(assignee = "Jack Jones")
    return <<-eos
    <div class="issue status-9 priority-2 closed details">
      <img class="gravatar" alt="" title="" width="50" height="50" src="https://secure.gravatar.com/avatar/f28aa6dfe085b81917957b0881d3b840?rating=PG&amp;size=50&amp;default=monsterid">
      <div class="subject">      
        <div><h3>A Test Bug</h3></div>
      </div>
      <p class="author">
        Added by <a href="/users/1">Joe Smith</a> <a href="/projects/desktop/activity?from=2012-06-29" title="06/29/2012 09:43 am">3 days</a> ago.
        Updated <a href="/projects/desktop/activity?from=2012-07-02" title="07/02/2012 05:58 am">21 minutes</a> ago.
      </p>
      <table class="attributes">
        <tbody>
          <tr>
            <th class="status">Status:</th><td class="status">Verified Internal</td>
            <th class="start-date">Start date:</th><td class="start-date">06/29/2012</td>
          </tr>
          <tr>
            <th class="priority">Priority:</th><td class="priority">Normal</td>
            <th class="due-date">Due date:</th><td class="due-date"></td>
          </tr>
          <tr>
            <th class="assigned-to">Assignee:</th><td class="assigned-to"><img class="gravatar" alt="" title="" width="14" height="14" src="https://secure.gravatar.com/avatar/230e56ec39f3de3d2a7a40529aaae401?rating=PG&amp;size=14&amp;default=monsterid"><a href="/users/2">#{assignee}</a></td>
            <th class="progress">% Done:</th><td class="progress"><table class="progress" style="width: 80px;"><tbody><tr><td class="closed" style="width: 100%;"></td></tr></tbody></table><p class="pourcent">100%</p></td>
          </tr>
          <tr>
            <th class="category">Category:</th><td class="category">App/Test</td>
          </tr>
          <tr>
            <th class="fixed-version">Target version:</th><td class="fixed-version"><a href="/versions/show/267">App Triage</a></td>
          </tr>
          <tr>
            <th>Community DisplayName:</th><td></td>
          </tr>
        </tbody>
      </table>
      <hr>
      <div class="contextual">
        <a class="icon icon-comment" href="#" onclick="new Ajax.Request('/issues/12345/quoted', {asynchronous:true, evalScripts:true, parameters:'authenticity_token=' + encodeURIComponent('Y/E3oofcRWpwYrSB9HgoETo3iXYfqTINooQhkF+Yr5Y=')}); return false;">Quote</a>
      </div>
      <p><strong>Description</strong></p>
      <div class="wiki">
        <p>This is an update</p>
      </div>
      <hr>
      <div id="issue_tree">
        <div class="contextual">
          <a href="/projects/desktop/issues/new?issue%5Bparent_issue_id%5D=12345">Add</a>
        </div>
        <p><strong>Subtasks</strong></p>
      </div>
      <hr>
      <div id="relations">
        <div class="contextual">
          <a href="#" onclick="Element.toggle('new-relation-form'); Form.Element.focus('relation_issue_to_id'); return false;">Add</a>
        </div>
        <p><strong>Related issues</strong></p>
        <form action="/issues/12345/relations/12345" id="new-relation-form" method="post" onsubmit="new Ajax.Request('/issues/12345/relations/12345', {asynchronous:true, evalScripts:true, method:'post', onComplete:function(request){Form.Element.focus('relation_issue_to_id');}, parameters:Form.serialize(this)}); return false;" style="display: none;"><div style="margin:0;padding:0;display:inline"><input name="authenticity_token" type="hidden" value="Y/E3oofcRWpwYrSB9HgoETo3iXYfqTINooQhkF+Yr5Y="></div>
          <p>
            <select id="relation_relation_type" name="relation[relation_type]" onchange="setPredecessorFieldsVisibility();">
              <option value="relates">related to</option>
              <option value="duplicates">duplicates</option>
              <option value="duplicated">duplicated by</option>
              <option value="blocks">blocks</option>
              <option value="blocked">blocked by</option>
              <option value="precedes">precedes</option>
              <option value="follows">follows</option>
            </select>
            Issue #<input id="relation_issue_to_id" name="relation[issue_to_id]" size="10" type="text" autocomplete="off">
          </p>
          <div id="related_issue_candidates" class="autocomplete" style="display: none; "></div>
          <script type="text/javascript">
          //<![CDATA[
          observeRelatedIssueField('/issues/auto_complete?id=12345&amp;project_id=desktop')
          //]]>
          </script>
          <span id="predecessor_fields" style="display: none; ">
            Delay: <input id="relation_delay" name="relation[delay]" size="3" type="text"> days
          </span>
          <input name="commit" type="submit" value="Add">
          <a href="#" onclick="Element.toggle('new-relation-form'); this.blur(); return false;">Cancel</a>
          <p></p>
          <script type="text/javascript">
          //<![CDATA[
          setPredecessorFieldsVisibility();
          //]]>
          </script>
        </form>
      </div>
    </div>
    eos
  end

  def mock_redmine_feed_request(url)
    FakeWeb.register_uri(:get, url, :body => mock_redmine_feed)
  end

  def mock_redmine_feed
    return <<-eos
    <?xml version="1.0" encoding="UTF-8"?>
    <feed xmlns="http://www.w3.org/2005/Atom">
      <title>Initech: Joe Smith</title>
      <link href="https://example.com/activity.atom?key=1d13e8fa38daa2807cbd919a6ce1a23facabff4d&amp;amp;show_issues=1&amp;amp;user_id=1" rel="self"/>
      <link href="https://example.com/activity?show_issues=1&amp;amp;user_id=1" rel="alternate"/>
      <id>https://example.com/</id>
      <updated>2012-07-02T06:07:57-05:00</updated>
      <author>
        <name>Initech</name>
      </author>
      <generator uri="http://www.redmine.org/">
    Redmine  </generator>
      <entry>
        <title>Desktop - Bug #67890 (Verified Internal): Another Test Bug</title>
        <link href="https://example.com/issues/67890#change-137948" rel="alternate"/>
        <id>https://xample.com/issues/67890#change-137948</id>
        <updated>2012-07-02T06:07:57-05:00</updated>
        <author>
          <name>Joe Smith</name>
          <email>joe@example</email>
        </author>
        <content type="html">
        </content>
      </entry>
      <entry>
        <title>Desktop - Bug #12345 (New): A Test Bug</title>
        <link href="https://example.com/issues/12345#change-137929" rel="alternate"/>
        <id>https://example.com/issues/12345#change-137929</id>
        <updated>2012-07-02T05:15:23-05:00</updated>
        <author>
          <name>Joe Smith</name>
          <email>joe@example.com</email>
        </author>
        <content type="html">
          This is a test ticket
        </content>
      </entry>
    </feed>
    eos
  end

end
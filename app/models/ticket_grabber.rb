class TicketGrabber
	include ScheduledJob

	run_every 5.minutes

	def perform
		username = ConfigurationValue.value 'redmine_username'
		password = ConfigurationValue.value 'redmine_password'
		return if username.nil? || password.nil?
		last_names = ConfigurationValue.participants.map { |n| "'#{n.split.last}'" }

		# connect to our redmine server
		db = PGconn.new('redmine', 5432, nil, nil, 'redmine', username, password)	

		# grab the tickets we care about, and collate them with our own tickets
		db.exec("SELECT authors.firstname as author_first, authors.lastname as author_last, issues.project_id, issues.id, issues.created_on, users.lastname, issues.subject, issues.description FROM issues, users, users as authors WHERE issues.author_id = authors.id AND issues.assigned_to_id = users.id AND users.lastname IN (#{last_names.join(',')})").each { |t| RedmineTicket.create_or_update(t) }
		rescue Exception => e
			`say "I failed to grab the tickets from redmine."`
	end	
end

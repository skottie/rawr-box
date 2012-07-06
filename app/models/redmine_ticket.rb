class RedmineTicket < ActiveRecord::Base
	def self.create_or_update(ticket_hash)
		t = RedmineTicket.find_by_ticket_id(ticket_hash['id'])
		attribute_hash = {
			:author_name => "#{ticket_hash['author_first']} #{ticket_hash['author_last']}",
			:ticket_id => ticket_hash['id'],
			:ticket_created_at => ticket_hash['created_on'],
			:project_id => ticket_hash['project_id'],
			:subject    => ticket_hash['subject'],
			:assigned_to => ConfigurationValue.participants.find { |p| p =~ /#{ticket_hash['lastname']}/ },
			:description => ticket_hash['description']
		}

		
		t ?	t.update_attributes(attribute_hash) : t = RedmineTicket.create(attribute_hash)
		t
	end
end

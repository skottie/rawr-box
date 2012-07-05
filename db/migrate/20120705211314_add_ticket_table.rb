class AddTicketTable < ActiveRecord::Migration
  def self.up
  	create_table :redmine_tickets do |t|
			t.integer  :project_id
			t.integer  :ticket_id
	
			t.datetime :ticket_created_at
			t.string   :assigned_to
			t.string   :subject
			t.string   :description
		
			t.timestamps
		end
	end

  def self.down
		drop_table :redmine_tickets
  end
end

class AddTicketStatus < ActiveRecord::Migration
  def self.up
  	add_column :redmine_tickets, :ticket_status, :string
			
		add_index :redmine_tickets, :ticket_status
	end

  def self.down
		remove_column :redmine_tickets, :ticket_status
  end
end

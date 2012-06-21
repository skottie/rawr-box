class AddCommits < ActiveRecord::Migration
  def self.up
  	create_table :commits do |t|
			t.string :team_handle
			t.string :changeset
			t.timestamps
		end
	end

  def self.down
		drop_table :commits
  end
end

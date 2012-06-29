class AddBranchToCommit < ActiveRecord::Migration
  def self.up
  	add_column :commits, :branch, :text
	end

  def self.down
		remove_column :commits, :branch
  end
end

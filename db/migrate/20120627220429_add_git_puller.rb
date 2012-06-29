class AddGitPuller < ActiveRecord::Migration
  def self.up
  	GitPuller.new.perform_with_schedule
	end

  def self.down
  end
end

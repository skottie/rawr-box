class AddAudioDirectory < ActiveRecord::Migration
  def self.up
  	`mkdir #{Dir.pwd}/uploads`
	end

  def self.down
		`rm -rf #{Dir.pwd}/uploads`
  end
end

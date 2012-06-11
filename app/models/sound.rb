class Sound < ActiveRecord::Base
	named_scope :label, lambda {|l| {:conditions => ['label = ?', l]}}
	before_destroy :delete_file

	def delete_file
		`rm #{path}`	
	end

	def play
		system("afplay #{path}")
	end
end

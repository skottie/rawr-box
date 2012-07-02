class Sound < ActiveRecord::Base
	named_scope :label, lambda {|l| {:conditions => ['label = ?', l]}}
	before_destroy :delete_file

	def delete_file
		`rm #{path}`	
	end

	# options => {:volume => ... }
	def delay_play(options = {})
    self.delay.play(options)
	end

	def play(options)
		volume = options[:volume] ? "-v #{options[:volume]}" : ""
    `afplay #{volume} #{path}`
	end
end

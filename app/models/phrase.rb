class Phrase < ActiveRecord::Base
	def delay_play 
		self.delay.play
	end

	def play
		voice_flag = voice !~ /default/ ? "-v '#{voice}'" : ""
		`say #{voice_flag} "#{phrase}"`	
	end
end

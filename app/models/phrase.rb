class Phrase < ActiveRecord::Base
	def play
		voice_flag = voice !~ /default/ ? "-v '#{voice}'" : ""
		puts "say command: say #{voice_flag} \"#{phrase}\""
		`say #{voice_flag} "#{phrase}"`
	end
end

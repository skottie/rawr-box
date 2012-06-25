class Phrase < ActiveRecord::Base
	def play
		voice_flag = voice !~ /default/ ? "-v '#{voice}'" : ""
		AsyncActions.command_line(`say #{voice_flag} "#{phrase}"`)
	end
end

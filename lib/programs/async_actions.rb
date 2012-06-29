# module for async one-liners
class AsyncActions 
	# voice command for playing daily progress
	def self.play_progress
		commit_count = Commit.today.count
		command_line "say 'There has been #{commit_count} commits today.'"
	end

	# play an async sound
	def self.play_sound(path, options = {})
		volume = options[:volume] ? "-v #{options[:volume]}" : ""
		command_line "afplay #{volume} #{path}"
	end

	# run an async command
	def self.command_line(cmd)
		t = Time.now
		AsyncActions.delay.delayed_command(cmd)
		s = Time.now
		puts "TIME ELAPSED: #{s - t}"
	end

	# where everything actually gets piped to
	def self.delayed_command(cmd)
		puts "command: #{cmd}"
		response = `#{cmd}`
		puts "response: #{response}"
	end
end

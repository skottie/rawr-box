class Redeploy
	def perform
		# add deploy steps here
		deploy_steps = {
			'Pulling Git Repository' => 'git pull',
			'Running migrations'     => 'rake db:migrate'
		}

		# run each deploy step and collect failures
		failures = deploy_steps.each_with_object([]) do |(title, command), memo|
			response = `#{command}`
			if $?.to_i > 0
				`say "#{title} has failed."`
				memo << title
			end
			Rails.logger.info("command: #{command}")
			Rails.logger.info("response: #{response}")
		end

		# give a message on the status of the deploy
		if !failures.empty?
			author = Grit::Repo.new('.').commits.last.author.name
			`say "There is a good chance #{author} broke the build."`
		else
			`say "Redeploy Successful."`
		end	
	end
end

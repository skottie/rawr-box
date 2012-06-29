class GitPuller 
  include ScheduledJob

  run_every 60.seconds

  def perform
		repository = ConfigurationValue.find_by_key 'git_repo'
		return unless (repository) 
		response = `cd #{repository.value}; git pull`
		puts 'Done pulling git:'
		puts response
	end
end

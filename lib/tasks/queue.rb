namespace :rawrbox do
	namespace :queue do
		desc "Reset the queue with just the jobs we want."
		task :reset => [:environment] do
			Delayed::Job.destroy_all
		
			GitPuller.new.perform_with_schedule
			TicketGrabber.new.perform_with_schedule
		end
	end
end

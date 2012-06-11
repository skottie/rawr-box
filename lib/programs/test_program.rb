class TestProgram
	include ScheduledJob

	run_every 20.seconds

	def perform
		`wget http://scary/say/children`
	end
end

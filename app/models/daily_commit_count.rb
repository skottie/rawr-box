class DailyCommitCount
	def perform
	 	commit_count = Commit.today.count
   	`say 'There has been #{commit_count} commits today.'`
	end
end

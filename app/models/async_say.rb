class AsyncSay < Struct.new(:phrase)
	def perform
		`say "#{phrase}"`
	end

	def self.proclaim(phrase)
		Delayed::Job.enqueue AsyncSay.new(phrase)
	end
end

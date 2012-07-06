class UnrealCommit < Struct.new(:path)
	def perform
    `afplay -v .3 #{path}`
	end
end

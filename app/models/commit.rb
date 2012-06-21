class Commit < ActiveRecord::Base
	named_scope :team_handle, lambda { |handle| {:conditions => ['team_handle = ?', handle]} }
	named_scope :today, lambda { {:conditions => 'date(created_at) = date("now")'} }
end

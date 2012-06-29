class ConfigurationValue < ActiveRecord::Base
	def self.create_or_update(key, value)
		c = ConfigurationValue.find_by_key(key)
		if c
			c.update_attribute :value, value
		else
			c = ConfigurationValue.create({:key => key, :value => value})
		end
		c	
	end

  def self.participants
    participants = find_by_key('participants')
    unless participants.nil?
      return participants.value.split(',').collect{|v| v.strip}
    end
    return []
  end
end

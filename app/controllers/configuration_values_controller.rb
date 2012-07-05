class ConfigurationValuesController < ApplicationController
	# we do this to make sure we don't serialize stray parameters into
	# configuration values.
	ACCEPTED_CONFIG_NAMES = %w{git_repo participants redmine_username redmine_password}

	def index
		@configuration_values = ACCEPTED_CONFIG_NAMES.each_with_object({}) { |k, memo| memo[k] = ConfigurationValue.find_by_key(k) }
	end

	def save
		params.each { |key, value|
			# filter out all the parameters rails adds	
			next unless ACCEPTED_CONFIG_NAMES.include?(key)
			# update the configuration value
			ConfigurationValue.create_or_update(key, value)
		}
		flash[:notice] = 'Saved!'
		flash[:notice_class] = 'ok'
		redirect_to '/configuration_values'
	end
end

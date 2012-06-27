# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
	def sexy_button(label)
		"<button class='sexy-button'><span>#{label}</span></button>"
	end

	def clearfix
		"<div style='clear: both;'></div>"
	end
end

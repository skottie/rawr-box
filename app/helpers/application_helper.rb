# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
	def sexy_button(label, options = {})
		extra_class = options[:class] || ''
		"<button class='sexy-button #{extra_class}'><span>#{label}</span></button>"
	end

	def sexy_button_to_remote(label, url, options = {})
		content_tag(:button, content_tag(:span, label, :class => 'inner icon'), {
			:type => :submit,
			:class => "sexy-button #{options[:class] || ''}",
			:onclick => "#{remote_function(:url=>url)}; return false",
		})
	end	

	def clearfix
		"<div style='clear: both;'></div>"
	end
end

# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all 

	def index
	end
	
	def play
		@sound = Sound.find_by_id(params[:id]) || Sound.find_by_label(params[:id])
		response = @sound.delay.play if @sound 
		puts "Response: #{response}"
		render :nothing => true
	end

	def say
		@phrase = Phrase.find_by_id(params[:id]) || Phrase.find_by_label(params[:id])
		response = @phrase.delay.play if @phrase
		puts "Response: #{response}"
		render :nothing => true
	end

	def forget
		p = Phrase.find_by_id params[:id]
		p.destroy if p
		respond_to do |format|
			format.js { render :update do |page|
				page.redirect_to '/'
			end }
		end
	end

	def delete
		s = Sound.find_by_id params[:id]
		s.destroy if s
		respond_to do |format|
			format.js {
				render :update do |page|
					page.redirect_to '/'
				end
			}
		end
	end

	def upload
		full_path = "#{Dir.pwd}/uploads/#{params[:file].original_filename}" 
		`cp #{params[:file].path} #{full_path}` 
		Sound.create({
			:path => full_path,
			:label => params[:label],
			:filename => params[:file].original_filename	
		})
		redirect_to '/' 
	end

	def learn
		p = Phrase.create({
			:phrase => params[:phrase],
			:label  => params[:label],
			:voice  => params[:voice]
		})
		redirect_to '/'
	end
end

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
		`chmod 777 #{full_path}` # file is owned by root because we are running on port 80.	
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

	def commit
		@commit = Commit.create({:team_handle => params[:id], :changeset => params[:changeset]})

		team_commit_count = Commit.today.count
		commit_count = Commit.team_handle(params[:id]).today.count
		path = ''
	
		if team_commit_count == 1
			path = 'default_audio/firstblood.wav'	
		elsif commit_count == 1
			path = 'default_audio/headshot.wav'
		elsif commit_count == 2
			path = 'default_audio/doublekill.wav'
		elsif commit_count == 3
			path = 'default_audio/triplekill.wav'
		elsif commit_count == 4 
			path = 'default_audio/multikill.wav'
		elsif commit_count == 5 
			path = 'default_audio/rampage.wav'
		elsif commit_count == 6 
			path = 'default_audio/killingspree.wav'
		elsif commit_count == 7 
			path = 'default_audio/dominating.wav'
		elsif commit_count == 8 
			path = 'default_audio/unstoppable.wav'
		elsif commit_count == 9 
			path = 'default_audio/megakill.wav'
		elsif commit_count == 10 
			path = 'default_audio/ultrakill.wav'
		elsif commit_count == 11
			path = 'default_audio/ownage.wav'
		elsif commit_count == 12
			path = 'default_audio/teamkiller.wav'
		else
			path = 'default_audio/godlike.wav'
		end
		ApplicationController.delay.play_commit_sound(path)	
		render :nothing => true
	end

	def self.play_commit_sound(path)
		`afplay #{path}`
	end
end

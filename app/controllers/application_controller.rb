# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all 

	COMMIT_WAV_LEVELS = %w{headshot doublekill triplekill multikill rampage killingspree dominating unstoppable megakill ultrakill ownage teamkiller}	
	
	def index
	end

	# Play a WAV file directly	
	def play
		@sound = Sound.find_by_id(params[:id]) || Sound.find_by_label(params[:id])
		response = @sound.play if @sound 
		render :nothing => true
	end

	# Say a pre-configured phrase
	def say
		@phrase = Phrase.find_by_id(params[:id]) || Phrase.find_by_label(params[:id])
		response = @phrase.play if @phrase
		puts "Response: #{response}"
		render :nothing => true
	end

	# Delete a pre-configured phrase
	def forget
		p = Phrase.find_by_id params[:id]
		p.destroy if p
		respond_to do |format|
			format.js { render :update do |page|
				page.redirect_to '/'
			end }
		end
	end

	# Delete a wav file from the server
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

	# Upload a new WAV file to the server
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

	# Teaches rawr-box a new phrase
	def learn
		p = Phrase.create({
			:phrase => params[:phrase],
			:label  => params[:label],
			:voice  => params[:voice]
		})
		redirect_to '/'
	end

	# posted from post-commit hook to create commit entry in server
	def commit
		@commit = Commit.create({:team_handle => params[:id], :changeset => params[:changeset], :branch => params[:branch]})
		
		# determine the commit counts for the day
		team_commit_count = Commit.today.count
		commit_count = Commit.team_handle(params[:id]).today.count
		path = ''

		# we could easily reduce this further by renaming the wavs '#.wav'
		path = if team_commit_count == 1
			'default_audio/firstblood.wav'
		elsif commit_count > COMMIT_WAV_LEVELS.size 
			'default_audio/godlike.wav'
		else
			"default_audio/#{COMMIT_WAV_LEVELS[commit_count-1]}.wav"
		end	
		
		# delay the sound playing so we don't bind on the web request
		AsyncActions.play_sound(path, :volume => 0.3 )
		render :nothing => true
	end

	# tells how many commits there were today over the PA
	def progress 
		AsyncActions.play_progress
		render :nothing => true
	end
end

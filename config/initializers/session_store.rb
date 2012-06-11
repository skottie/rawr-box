# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_rawr-box_session',
  :secret      => '5fb94991f7e11c929f4a8d62bea031d8a2ddd5ba08500bd3c3d0a195f1fb4d3182defef99aed2e4f121fcc6b8a737734ccd7087d5dcd22ba1f0f2f14fefe309d'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store

# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_juksite_session',
  :secret      => '422e651bae9856a3edb4dd32a04e17e4e76115c35229995bdc054d6d9d49e58dc5d250cfee3bbe41a6d1da4dc7b01a17f29698866cd609a6b639e813d3fb4ed5'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store

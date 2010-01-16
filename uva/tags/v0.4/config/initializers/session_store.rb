# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_uva_session',
  :secret      => '3a256386c5f0b36397e43f37042055e31a8a6bed2b30767361dc4e95fcb1618927d6421f42cecde65cc42754cff802b9a202ab211375dc98973f0235a7a9d3c8'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store

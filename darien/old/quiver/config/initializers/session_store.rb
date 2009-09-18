# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_quiver_session',
  :secret      => '178c2c1c9f01a4229b0e3124e654a5400c01277df697a26dcd3cdac5bc31c6025f1fb2ced22c697e74198d242afc69d3b7ae0ab4a8e3195f73997296a79abbec'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store

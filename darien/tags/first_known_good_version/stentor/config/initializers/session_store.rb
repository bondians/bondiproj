# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_stentor_session',
  :secret      => '49564b0ca00016c4cf90f86de76ad1f0a952affcb319e85a74fec8d1caeffdd4c4d3e39ca8f65d97f3245534feaa8674eeb50e2ba2057609a12a104d38f6d89c'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store

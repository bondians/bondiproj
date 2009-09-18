# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_pontoon_session',
  :secret      => '5522fe2058ca13485fbba495eea938bcd9854c1a8eeb3fb10ec60c47d794068268432200cdc5d13cf8ed9492955964acb54dd30b4c8f25461b59e80d90f817b1'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store

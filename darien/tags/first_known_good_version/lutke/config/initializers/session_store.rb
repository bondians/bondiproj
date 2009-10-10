# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_lutke_session',
  :secret      => '47c085cfeb41bf46885c287350ffb219c2fd4dc3601a9e21df9290a024c41b77b139304f6bdc78c47b528cb2771a3ed56ed0787325d7da257a84297f2e7fcd0c'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store

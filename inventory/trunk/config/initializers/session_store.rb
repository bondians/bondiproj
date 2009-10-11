# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_inventory_session',
  :secret      => '294172b9a4fc164c69152dad60c809aa76ffcb6fe8f050caa6740df2de834d76f7da7fe88fea14fa6a98e8ca8bbe8ad3eb09dc4c5c372a5846856cbf489091ed'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store

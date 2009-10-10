# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_borg_session',
  :secret      => 'a61eda8eae606515473fda12b21743aa13f448f5ee4a3171507d5c4b1ca8e3aad93b9ba3f2bc873bd6712617175b6864b1fb0a037de29eb74c50766192cc3c8f'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store

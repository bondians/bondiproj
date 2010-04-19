# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_sanford_session',
  :secret      => '214e622419c7eff4e2f63dcbbcdcdcc27eb46e97ee2c6011fe5ccc6417d3ff2c505755d6de63a04cab9217a83e477332310e17355c978f205b88af5aecfe70d2'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store

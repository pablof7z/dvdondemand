# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_vinilly_session',
  :secret      => '25bfbc1b3d48f9aa59e995c014947a08b44f22f91ecc2dc8c9d1d852edecbcc9aa49116e57cd74fdb0a83a058f57918122df123c9761af34425893710e2b10d9'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store

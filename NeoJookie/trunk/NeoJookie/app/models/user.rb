require "digest/sha1"

class User < ActiveRecord::Base
  validates_presence_of :name
  validates_uniqueness_of :name
  
  has_many :playlists
  
  # accessor for password confirmation
  attr_accessor :password_confirmation
  validates_confirmation_of :password
  
  # validation: require a password to be set
  def validate
    errors.add_to_base("No password set") if password_hashed.blank?
  end
  
  # User.authenticate - returns User object on success, nil on failure
  def self.authenticate(name, password)
    user = self.find_by_name(name);
    
    if user
      hashed = encrypted_password(password, user.password_salt)
      
      if user.password_hashed != hashed
        user = nil
      end
    end
    
    return user
  end
  
  # accessors for raw password (doesn't go into db, only sets password_hashed)
  def password
    @password
  end
  
  def password=(pwd)
    @password = pwd
    
    create_new_salt
    self.password_hashed = User.encrypted_password(self.password, self.password_salt)
  end
  
  
  private
  
  # methods related to hashing
  def self.encrypted_password(password, salt)
    string_to_hash = password + "655321" + salt
    Digest::SHA1.hexdigest(string_to_hash)
  end
  
  def create_new_salt
    self.password_salt = self.object_id.to_s + rand.to_s
  end
end

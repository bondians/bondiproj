class Newsitem < ActiveRecord::Base
  belongs_to :newsfeed
  belongs_to :user, :class_name =>"Goldberg::User"
  validates_presence_of :title, :message => "You must specify a Title"
  validates_presence_of :body, :message => "Body of news cannot be blank"
end

class Usertime < ActiveRecord::Base
  belongs_to :user, :class_name =>"Goldberg::User"
  
  def self.buildtimes(user)
    times = []
    (1 .. 24).each do |t|
      this_time = (user.usertimes.find_by_keytime t) || user.usertimes.build(:attributes => {:keytime => t})
      times.push this_time
    end
    return times
  end
  
  def self.reversetimes(user)
    usertimes = Usertime.buildtimes user
    times = []
    usertimes.each do |t|
      times.push [!!t.sun, !!t.mon, !!t.tue, !!t.wed, !!t.thu, !!t.fri, !!t.sat]
    end
    times.transpose
  end
  
end

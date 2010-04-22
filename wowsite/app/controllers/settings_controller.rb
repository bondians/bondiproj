class SettingsController < ApplicationController
  def select
    @mymembers = Goldberg.user.members
    @unused = Member.unassigned
  end
end

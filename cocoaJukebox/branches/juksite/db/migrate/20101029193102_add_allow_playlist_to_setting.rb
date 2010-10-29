class AddAllowPlaylistToSetting < ActiveRecord::Migration
  def self.up
    add_column :settings, :allowplaylist, :boolean
  end

  def self.down
    remove_column :settings, :allowplaylist
  end
end

#!/usr/bin/env ruby

require 'yaml'
require 'awesome_print'
require 'soundcloud'
require 'base64'
require 'active_support/core_ext'


Config = YAML.load_file('oauth-details.yaml')
page_size = 200  # pagination size. 200 is the max

puts "Connecting to SoundCloud API..."
# create client object with app and user credentials
client = Soundcloud.new(:client_id => Config['client_id'],
                        :client_secret => Config['client_secret'],
                        :username => Config['username'],
                        :password => Base64.decode64(Config['password_base64']))

# get playlists from SC
puts "Getting your playlists..."
playlists = client.get("/me/playlists", :limit => page_size)

puts "Getting your favorites..."
favs = client.get("/me/favorites", :limit => page_size)


# see if the playlists already exists
# note that SoundCloud represents this as Date.today.strftime("%B-%y").downcase ; e.g. => 'november-14' 
# whereas we create them as Date.today.strftime("%B '%y") ; e.g. => 'November '14'
this_month_playlist = playlists.select {|i| i.permalink == (Date.today.strftime("%B-%y").downcase) }.first

# create playlists if it doesn't exist
unless this_month_playlist
  print "playlist #{Date.today.strftime("%B-%y").downcase} not found, will create it..."
  begin
    this_month_playlist = client.post("/me/playlists", 
      :playlist => { 
        :title => Date.today.strftime("%B '%y"), 
        :sharing => 'public' 
      } 
    )
    puts "Created."
  rescue
    abort("Playlist creation failed. Please create #{Date.today.strftime("%B '%y")} manually and try again.")
  end
end

# Create a list of tracks CREATED this month
# NOTE NOTE NOTE: if the track was created more than a month ago, consider changing this to i.last_modified
# however, last_modified brings a different set of issues, as tracks could be modified
favs_this_month = favs.select {|i| i.created_at > DateTime.now.utc.beginning_of_month }


# checks to see if each favorite track ID is included in an array of [this_month_playlist track IDs]
# consider the following logically-equivalent:
=begin
  favz = [1,2,3]
  pl = [1,2,3,4,5]
  favz.all? {|id| pl.include?(id)}
=end
unless favs_this_month.map(&:id).all? {|track_id| this_month_playlist.tracks.map(&:id).include?(track_id) }
  # :tracks is a unique set of favs_this_month IDs and this_month_playlist IDs in format [{:id => XXXX}, {:id => YYYY}, ... ]
  begin
    puts ">>>>> Not all of your favorites are already on the playlist this month! Adding them... <<<<<"
    puts "Tracks to Add"
    puts "==============="
    ap (favs_this_month - this_month_playlist.tracks).map(&:title)
    client.put(this_month_playlist.uri,
      :playlist => {
        :tracks => (favs_this_month.map(&:id) + this_month_playlist.tracks.map(&:id)).uniq.map { |id| {:id => id} }
      }
    )
    puts "OK !!!"
  rescue
    ap this_month_playlist
    ap favs_this_month
    abort("Couldn't update playlist. this_month_playlist and favs_this_month are above.")
  end
else
  puts ">>>>> It looks like everything you've favorited is already in the playlist for this month. <<<<<"
end

puts "Favorites"
puts "==========="
ap favs_this_month.map(&:title)
puts "#{Date.today.strftime("%B '%y")} (your Playlist AKA Set)"
puts "==========================================="
ap this_month_playlist.tracks.map(&:title)
puts "Done !!!"
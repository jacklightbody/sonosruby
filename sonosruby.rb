require 'rubygems'
require 'sonos'
require 'osaka'
require 'time'
system = Sonos::System.new # Auto-discovers your system
speaker = system.speakers.first
song = speaker.now_playing.dup
tolerance = 0.03 # margin that the two systems should minimally be synced up by
while 1==1
  if song[:title] != speaker.now_playing[:title] # if they aren't playing the same song
     #Attempt to sync them up but really leave it to the next if
    # new song, update itunes
    song = speaker.now_playing.dup
    scriptplay = 'tell application "iTunes"
      set mySongs to every track of library playlist 1 whose artist is "'+song[:artist]+'" and name is "'+song[:title]+'"
      repeat with aSong in mySongs
          play aSong
      end repeat
    end tell'
    start = Time.now
    Osaka::ScriptRunner.execute(scriptplay)
    iTunesTime = Time.now - start
    scriptreset = 'tell application "iTunes"
    set player position to 0
end tell'
    speakerThread=Thread.new{
      speaker.now_playing[:current_position] = '00:00:01'
    }
    Osaka::ScriptRunner.execute(scriptreset)
    speakerThread.join
  end
end

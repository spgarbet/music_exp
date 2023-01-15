  #############################################################################
 #
# Stochastic Drone
#
# Creates a midi file that has no time signature. Drone notes trigger
# in a sequence (maybe pseudo random) at random times. Best midi programs
# to use are those with long release times, long pads.
#
# Based on the tampura method by John Pitts in "How to Play Indian Sitar Ragas
# on a Piano"
# 
# IMPORTANT: Look below for the parameters to configure
#

require 'distribution'
require 'midilib/sequence'
require 'midilib/consts'

include MIDI

  #############################################################################
 #
# Grace note class
#
class Grace
  attr_reader :first, :second

  def to_ary; [first, second] end
  alias_method :to_a, :to_ary

  private

  attr_writer :first, :second

  def initialize(first, second)
    self.first, self.second = first, second
  end

  class << self; alias_method :[], :new end
end


  #############################################################################
 #
# Patterns from John Pitts
#
classical  = [-5, 0, 0, -12]                     # works for just about anything
alternate  = [-7, 0, 0, -12]                     # works for asian scales or sus tonic chord pieces
latangi    = [-5, -1,  0, 0, -12, -5, 2, 0, -12] # major 7, 9
todi       = [-4,  1,  0, -12]                   # Blues complement
vachaspati = [-5, -2, 0, -12]                    # Mixolydian
patdeep    = [-5, -1, 0, -12, 3]                 # Minor 
desh       = [-5, -1, 0, -12, -5, 0, 2, 0, -12]  # Sharp 6
malhar     = [-5, 0, 0, -12, -5, 2, 0, 0, -12]   # 9
chayanat   = [-5, 2, -12, -5, 4, 2, -12]         # tritone

bliss          = [ 0, 7, 9, 7, 9, [0, 2, 4, 5], Grace.new(-12, -7), [-10, -19, -24]] # straight (bliss)
mountain_stream= [-5, 0, 0, 2, 0, -2, 0, -12]        # minor 
little_girl    = [-5, 0, 0, -12, -1, 0, [-5], [4], [2], [-1]] 
landscape      = [ 7, 11, 12, 12, 14, [7], [9], [11], Grace.new(-5, 0),  [-5], [-12], [-17]] # sweeping landscape
wise_man       = [-5, -2, 0, 0, [2], [4], [-10], -12] # major
gezelle        = [-5, [-4], 0, 0, [1], [4], [-1], -12] # occasional head butts
moonlight      = [ 7, 12, 14, 10, 12, [8, 10, -2], 0] 
waiting_bride  = [-5, 0, 0, 2, [2, 3, 5], -12]
sleep          = [-7, -5, -2, 0, -12, -7, -5, 0, 2, -2, 0, -12]
pollen_breeze  = [ 7, 8, [11], 8, [6], 0, [1] ]
elegant_mischief=[ [-7], -8, -7, Grace.new(1, 0), 0, -12]
saffron_aroma  = [-5, [0], [0, 1], 0, -12]
ruddy_goose    = [-5, 0, 0, -12, 4, Grace.new(1, 0), -12]
intense_coffee = [-5, [-1], 0, 0, -12]
morning_sun    = [-5, 4, [1], Grace.new(-2, 0), [0], Grace.new(-2, 0), 
                  [-11], [-14], -12, -8]
mourning       = [-5, [-2], 0, 0, -11, -12, -5, 1, 0, -12]
full_of_hope   = [-12, -5, Grace.new(0, 2), Grace.new(2, 3),
                  [Grace.new(-4, -2)], [-14], [Grace.new(-2, 0)] ]
lady_lost_in_forest = [-16, [Grace.new(-17,-16)], -11, -12, -24]
lunchtime_bell = [-17, -12, -12, -24]

# Note, for flowing honey, stealing_my_heart set
# optional = [true, false, false, false]
flowing_honey  = [-5, [-3,-1,0], 0, 2, [6, 7, 9, 11, 12], -12, [-10],
                  -5, [-3,-1,0], 0, 2, [6, 7, 9, 11, 12], -12,
                  0, -5, [-3,-1,0], -12, [6,7,9,11,12,-10], 2,
                  -5, [-3,-1,0], 0, 2, [6, 7, 9, 11, 12], -12, [-10],
                  -5, [-3,-1,0], 0, -12, [6, 7, 9, 11, 12], 2,
                  0, -5, [-3,-1,0], 2, [6,7,9,11,12,-10], -12,]
stealing_my_heart = [ [-24], [-17], -12, 7, 2, [-24], 8, 0, 10, 6, 12]
#

beautiful_hair = [-5, -4, 0, 2, 0, 2, 2, 4, 2, 4, Grace.new(-17, -12),
                  [-17, -24, -29]]
from_the_east  = [-5, 0, -12, -4, [1, 4]]
satisfaction   = [-15, -11, -12, -24, -13, -12, -12, -24]

  #############################################################################
 #
# Pollen Breeze has an opening drone that swells with 2 parts, an upper and
# lower. Use this program with repeat set to 1, and create the upper and lower
# as an intro, with the same tonic, tempo and random number generator
# Maybe add some swells in post
#
# This is followed by the drone above, and the melody is allowed to develop
#
na = nil
pollen_br_lwr  = [ 7, 8, 8, 0, 7, 8, 8, 0, 7, 8, 8, 0, 7, 8, 8, 0, 
                  7, 8, 8,11, 0, 7, 8, 8,11, 1, 0,
                  7, 8, 8,11, 1, 8, 0, 7, 8, 8,11, 1, 8, 0, 5,
                  7, 8, 8,11, 1, 8, 0, 5]
pollen_br_up  = [na,na,na,na,na,na,na,na,20,13,12,20,13,12,20,13,
                 12,20,19,13,12,20,19,13,12,20,19,
                 13,11,12,20,19,13,11,12,20,19,13,11,12,16,20,
                 19,13,11,12,15,20,13,12]

seq = Sequence.new

  #############################################################################
 #
# Configuration Parameters, i.e. Change these to suit your needs
#
tampura  = lady_lost_in_forest
#tonic    = 48    # Low C in midi is center
tonic    = 60   # Middle C
bpm      = 120
# rng      = lambda {1}                         # For a fixed time pulse on a quarter note
rng      = Distribution::Exponential.rng(1)   # rng must always return a positive number
note_len = 4*seq.note_to_delta('quarter')
repeats  = 24
program  = 89 # General Midi Pad Patch
optional = [true, false, false, false] # A 1 in 4 chance
filename = 'stoch_drone.mid'

  #############################################################################
 #
# Construct the midi track from the parameters
#
# Create a first track for the sequence. This holds tempo events and stuff
# like that.
track = Track.new(seq)
seq.tracks << track
track.events << Tempo.new(Tempo.bpm_to_mpq(bpm))
track.events << MetaEvent.new(META_SEQ_NAME, 'Stochastic Drone')

# Create a track to hold the notes. Add it to the sequence.
track = Track.new(seq)
seq.tracks << track
track.name = 'StochDrone'
track.instrument = GM_PATCH_NAMES[program-1]

# Add events to the track: a major scale. Arguments for note on and note off
# constructors are channel, note, velocity, and delta_time. Channel numbers
# start at zero. We use the new Sequence#note_to_delta method to get the
# delta time length of a single quarter note.
track.events << ProgramChange.new(0, program, 0)
pause = 0
repeats.times do
  tampura.each do |offset|
    if offset.class == Grace   or 
       offset.class == Integer 
      note = offset
    elsif offset.class == NilClass
      note = nil
      pause += (note_len*rng.call).to_i
    else 
      if optional.sample
        note = offset.sample       
      else
        note = nil
      end
    end
    unless note.class == NilClass
      if note.class == Grace
         track.events << NoteOn.new(0, tonic + note.first, 100, pause)
         pause=0
         track.events << NoteOff.new(0, tonic + note.first, 100, (note_len/32).to_i)
         note = note.second
      end
      track.events << NoteOn.new(0, tonic + note, 100, pause)
      pause=0
      track.events << NoteOff.new(0, tonic + note, 100,
        (note_len * rng.call).to_i)
    end
  end
end

File.open(filename, 'wb') { |file| seq.write(file) }
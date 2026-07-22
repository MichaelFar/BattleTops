extends Node3D

class_name MusicManager

@export var transitionStream : AudioStreamWAV
@export var downtimeLoopStream : AudioStreamWAV
@export var chorusPartOne : AudioStreamWAV
@export var chorusPartTwo : AudioStreamWAV
@export var chorusIntro : AudioStreamWAV
@export var audioPlayer : AudioStreamPlayer

var shouldTransitionIntoDowntime : bool = false

var loopTimer : float = 0.0

signal finished_loop

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	audioPlayer.playing = true
	#GlobalStats.round_ended.connect(set_should_transition_into_downtime.bind(true))
	GlobalStats.player_died.connect(play_transition_into_downtime)
	#GlobalStats.next_round_started.connect(set_should_transition_into_downtime.bind(false))
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	loopTimer += delta
	
	if(loopTimer >=audioPlayer.stream.get_length()):
		loopTimer = 0.0
		finished_loop.emit()

func _on_finished_loop() -> void:
	if(shouldTransitionIntoDowntime):
		play_downtime()
		shouldTransitionIntoDowntime = false
		
	
	
func play_transition_into_chorus():
	if(audioPlayer.stream != chorusPartOne):
		disconnect_finished_signal_connections()
		audioPlayer.stream = transitionStream
		audioPlayer.playing = true
		audioPlayer.finished.connect(play_chorus)

func play_transition_into_downtime():
	disconnect_finished_signal_connections()
	audioPlayer.stream = transitionStream
	audioPlayer.playing = true
	audioPlayer.finished.connect(play_downtime)

func play_downtime():
	audioPlayer.stream = downtimeLoopStream
	audioPlayer.playing = true
	disconnect_finished_signal_connections()

func play_chorus():
	if(audioPlayer.stream != chorusPartOne && audioPlayer.stream != chorusPartTwo):
		play_chorus_part_one()
		
func play_chorus_intro():
	if(audioPlayer.stream != chorusPartOne && audioPlayer.stream != chorusPartTwo && audioPlayer.stream != chorusIntro):
		audioPlayer.stream = chorusIntro
		audioPlayer.playing = true
		disconnect_finished_signal_connections()
		audioPlayer.finished.connect(play_chorus)
func play_chorus_part_one():
	audioPlayer.stream = chorusPartOne
	audioPlayer.playing = true
	disconnect_finished_signal_connections()
	audioPlayer.finished.connect(play_chorus_part_two)

func play_chorus_part_two():
	audioPlayer.stream = chorusPartTwo
	audioPlayer.playing = true
	disconnect_finished_signal_connections()
	audioPlayer.finished.connect(play_chorus_part_one)

func disconnect_finished_signal_connections():
	for i in audioPlayer.finished.get_connections():
		audioPlayer.finished.disconnect(i["callable"])

func set_should_transition_into_downtime(new_value : bool):
	shouldTransitionIntoDowntime = new_value

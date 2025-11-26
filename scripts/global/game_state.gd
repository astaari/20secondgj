extends Node

signal score_changed(score)

var score : int = 0 : 
	set(value):
		score = value
		score_changed.emit(value)
	get():
		return score

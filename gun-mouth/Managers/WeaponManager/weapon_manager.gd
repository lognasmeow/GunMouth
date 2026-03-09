extends Node3D

signal shooting
signal stoppedShooting
		
func _process(_delta):
	if Input.is_action_pressed("shoot"):
		shooting.emit()
	elif Input.is_action_just_released("shoot"):
		stoppedShooting.emit()

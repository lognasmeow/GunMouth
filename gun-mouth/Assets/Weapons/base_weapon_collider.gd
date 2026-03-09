extends Node3D

signal weaponPickedUp(referenceWeapon: PackedScene, ammoToPickup: int)

@export var referenceWeapon: PackedScene
@export var ammoToPickup: int = 0

var movementAmplitude: float = 0.25
var movementFrequency: float = 2.0
var initialY: float

func _ready():
	initialY = position.y
	weaponPickedUp.connect(get_parent().get_node("Player")._on_weapon_picked_up)


func _process(delta):
	var verticalOffset = sin(Time.get_ticks_msec() * 0.001 * movementFrequency) * movementAmplitude
	position.y = initialY + verticalOffset
	rotation.y += 0.1


func _on_area_3d_body_entered(body):
	if body.name == "Player":
		weaponPickedUp.emit(referenceWeapon, ammoToPickup)
	queue_free()

extends Node3D

signal shoot

enum Weapons {
	PISTOL,
	MACHINE_GUN,
	SHOTGUN,
}

var activeWeapon: Weapons = Weapons.PISTOL
var isActiveWeaponAutomatic: bool = false

func _input(event):
	setActiveWeapon()
	
func _unhandled_input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.is_pressed():
			shoot.emit()
			print("shoot")

func setActiveWeapon() -> void:
	if Input.is_action_just_pressed("weapon1") and activeWeapon != Weapons.PISTOL:
		activeWeapon = Weapons.PISTOL
		isActiveWeaponAutomatic = false
	if Input.is_action_just_pressed("weapon2") and activeWeapon != Weapons.MACHINE_GUN:
		activeWeapon = Weapons.MACHINE_GUN
		isActiveWeaponAutomatic = true
	if Input.is_action_just_pressed("weapon3") and activeWeapon != Weapons.SHOTGUN:
		activeWeapon = Weapons.SHOTGUN
		isActiveWeaponAutomatic = false

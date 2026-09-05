extends Sprite2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@export var requires_double_click: bool = false

var doubleclick_timer: float

var ConnectedPage: String
signal animation_finished

var is_correct: bool = false

func PreOpen() -> void:
	animation_player.play("opened")

func TryToOpen() -> void:
	if not SaveSystem.SavedData.keys().has(ConnectedPage):
		animation_player.play("what")
		await animation_player.animation_finished
		animation_finished.emit()
		return
	elif not SaveSystem.SavedData[ConnectedPage]["has_been_touched"]:
		animation_player.play("what")
		await animation_player.animation_finished
		animation_finished.emit()
		return
	var save = SaveSystem.SavedData[ConnectedPage]
	
	if save["is_solved"]:
		animation_player.play("correct")
		is_correct = true
	else:
		animation_player.play("incorrect")
		is_correct = false
	
	await animation_player.animation_finished
	animation_finished.emit()
	

func _process(delta: float) -> void:
	if doubleclick_timer > 0:
		doubleclick_timer -= delta
	
func _on_button_button_down() -> void:
	if doubleclick_timer > 0 or (not requires_double_click):
		PageScroll.GoToPageByPath(ConnectedPage, true)
		return
	doubleclick_timer = 0.2

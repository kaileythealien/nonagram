extends Sprite2D

const LOCK_NUMBER = preload("uid://t74b87u52m8t")
@onready var ring: Sprite2D = $Ring

@export var PagesToOpen: Array[PackedScene]
@export var ringsize: float = 275.0
@onready var page: Page = $"../.."
var is_open: bool = false
var is_opening: bool = false

var number_locks: Array[Sprite2D]

#TODO: The actual unlocking i guess
#TODO: add a variable to not let you double lock? check what happens
#		when you leave page while unlocking maybe not allow???
#TODO: theyre not in the correct order tho for some reason

@onready var animation_player: AnimationPlayer = $LockSprites/AnimationPlayer

func _ready() -> void:
	PlaceLocks()

func PlaceLocks() -> void:
	var lock_circle_size: int = PagesToOpen.size()
	for lock in lock_circle_size:
		var NumInstance = LOCK_NUMBER.instantiate()
		
		NumInstance.ConnectedPage = PagesToOpen[lock-1].resource_path
		
		# PLACE NODES IN A CIRCLE
		var circlejerk: float = PI*2/lock_circle_size*lock-PI
		NumInstance.position = Vector2(
			sin(circlejerk)*ringsize,
			cos(circlejerk)*ringsize
			)
		
		ring.add_child(NumInstance)
		
		number_locks.append(NumInstance)

func SkipToWin() -> void:
	page.is_next_page_locked = false
	animation_player.play("Opened")
	for number_lock in number_locks:
		number_lock.animation_player.play("opened")

func TryToOpen():
	is_opening = true
	var will_open: bool = true
	for number_lock in number_locks:
		number_lock.TryToOpen()
		await number_lock.animation_finished
		if number_lock.animation_finished.get_object().is_correct:
			print_rich("[color=green]Lock unlocked.[/color]")
		else:
			will_open = false
			print_rich("[color=red]Lock not unlocked.[/color]")
	if will_open:
		Open()
	else:
		is_opening = false

func Open():
	animation_player.play("Open")
	await animation_player.animation_finished
	page.is_next_page_locked = false
	is_opening = false

func _input(event: InputEvent) -> void:
	if is_open: return
	if is_opening: return
	if event.is_action_pressed("NextPage"):
		TryToOpen()

func _on_button_button_down() -> void:
	if is_open: return
	if is_opening: return
	TryToOpen()

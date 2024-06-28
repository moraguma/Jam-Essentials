extends Node

var current_scene = null
var current_path = ""
var transitioning = false
var call_queued = false

var queued_method
var queued_parameters


func _ready():
	var root = get_tree().get_root()
	current_scene = root.get_child(root.get_child_count() - 1)
	
	current_path = current_scene.scene_file_path


## Queues a transition and stores a method to call with the specified parameters
## on the root node of the next scene once the transition finishes
func goto_scene_and_call(path, method_name, parameters):
	call_queued = true
	queued_method = method_name
	queued_parameters = parameters
	
	goto_scene(path)


## Queues a transition. If instantaneous_transition is true, will immediately
## go to the next scene. Otherwise, the next scene will only load once the method
## finish_transition is called. This can be extended to call a transition
## animation that will call finish_transition at the appropriate time
func goto_scene(path: String) -> void:
	if not transitioning:
		current_path = path
		
		transitioning = true
		
		GlobalCamera.start_transition_animation()
		await GlobalCamera.finish_transition
		call_deferred("_finish_transition")


## Instantiates the scene specified on the last goto_scene call. If a method has
## been queued, will call that method on the root not of that new scene
func _finish_transition():
	if transitioning:
		transitioning = false
		
		current_scene.free()
		
		var s = ResourceLoader.load(current_path)
		current_scene = s.instantiate()
		
		if call_queued:
			current_scene.callv(queued_method, queued_parameters)
			call_queued = false
		
		get_tree().get_root().add_child(current_scene)
		get_tree().set_current_scene(current_scene)


## Queues a transition to the current scene
func restart() -> void:
	goto_scene(current_path)

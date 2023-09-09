# Moraguma's Jam Essentials

Hey! This here is a compilation of a couple of autoloads and scripts I use for pretty much every jam game I make. You can play those games [on my itch page!](https://moraguma.itch.io/)

## SceneManager

Autoload used to manage transitions between scenes

|Return type|Method|Description|
|---|---|---|
|void|goto_scene(path: String)|Transitions to the specified scene|
|void|goto_scene_and_call(path:String, method_name: String, parameters: Array)|Transitions to the specified scene and calls the specified method on its root node|
|void|restart()|Transitions to the current scene, effectively restarting it|

## GlobalCamera

Autoload used to manage camera movement and animate transitions. At every frame, will linearly interpolate its position to the specified aim, if any

|Return type|Method|Description|
|---|---|---|
|void|add_trauma(amount: float = 0.5)|Adds camera shake|
|void|follow_node(node: Node2D)|Sets camera to follow the specified node|
|void|follow_pos(pos: Vector2)|Sets camera to follow the specified position|
|void|snap_to_aim()|Instantly snaps position to the given aim, if any|

## SoundController

Autoload used to play SFX and music. AudioStreamPlayers containing the SFX and music should be added as children of SFX and Music nodes. Sounds should be referred to by their node names

This node will interpolate between songs

|Return type|Method|Description|
|---|---|---|
|void|play_music(music_name: String)|Plays the specified music|
|void|play_sfx(sfx_name: String)|Plays the specified SFX|
|void|mute_music()|Mutes all music|

## Buttons

The button scripts have simple functions that can be modified through the exported values

### TransitionButton

Transitions to a scene through the SceneManager once clicked

|Type|Variable|Description|
|---|---|---|
|String|transition_path|Transition scene's path|

### CameraFocusButton

Focuses the GlobalCamera on the specified position. The given position should be the center of the screen we want to focus on.

|Type|Variable|Description|
|---|---|---|
|Vector2|aim_pos|The position we wish to focus on|
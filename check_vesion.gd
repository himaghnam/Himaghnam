extends Node

const version:String = "version"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var url:String = "https://project.firebaseio.com/Version.json"
	$HTTPRequest.request(url)
	pass # Replace with function body.



func _on_HTTPRequest_request_completed(result: int, response_code: int, headers: PoolStringArray, body: PoolByteArray) -> void:
	var check_version = JSON.parse(body.get_string_from_ascii()).result 
	print(check_version)
	if version != check_version :
		#popup update
		_on_Update()
		pass
		
	pass # Replace with function body.

func _on_Update() -> void:
# warning-ignore:return_value_discarded
	OS.shell_open("market://details?id=com.yourGame.ID=en")

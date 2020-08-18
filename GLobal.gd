extends Node


var Global_Speed:int


func firebase_loads() -> void:
	var http:HTTPRequest = HTTPRequest.new()
	http.connect("request_completed",self,"_on_Firebase_loads")
	add_child(http)
	# users down below is a collectionId , FirebaseHttp.user_info.id is field , saves is sub collectionid
	FirebaseHttp.get_document("users/%s" % FirebaseHttp.user_info.id +"/saves",http)
	pass


func _on_Firebase_loads(result: int, response_code: int, headers: PoolStringArray, body: PoolByteArray)-> void:
	var result_body := JSON.parse(body.get_string_from_ascii()).result as Dictionary
	var trim:String  = "projects/"+FirebaseHttp.PROJECT_ID+"/databases/(default)/documents/users/"+String(FirebaseHttp.user_info.id)+"/saves/"

	for i in result_body.documents.size():
		match String(result_body.documents[i].name.trim_prefix(trim)):
			"Global_Details":
				Global_Speed   = int(result_body.documents[i].fields["0"].arrayValue.values[0].stringValue)

func firebase_saves() -> void:
	var http:HTTPRequest = HTTPRequest.new()
	http.connect("request_completed",self,"_on_HTTPRequest_request_completed")
	add_child(http)
	#firebase save is field in database
	var Firebase_Save :Dictionary = {"arrayValue":{"values":
				[{"stringValue":"0"}, {"stringValue":"true"}]}} 
	FirebaseHttp.update_document("users/%s" % FirebaseHttp.user_info.id +"/collectionID1/SubCollectionId",Firebase_Save, http)
	remove_child(http)











var email: String
var password :String

func _on_Register_firebase_pressed() -> void:
	FirebaseHttp.register(email,password,$HTTPRequest)

func _on_Login_firebase_pressed() -> void:
	FirebaseHttp.login(email,password,$HTTPRequest)

#connect httpRequest node's signal complected 
func _on_HTTPRequest_request_completed(result: int, response_code: int, headers: PoolStringArray, body: PoolByteArray) -> void:
	var result_body := JSON.parse(body.get_string_from_ascii()).result as Dictionary
	print(result_body)
	if result_body.has("error"):
#		print(result_body["error"].message)
#		print(result_body)
#		print(result )
#		print(response_code)
		$Notification.text = String(result_body["error"].message)

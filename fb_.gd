extends Node

const fb_app_id = ""#dev id
var fb
var id #device unique id(showcasing different func of module)
var Token

func _ready() -> void:
	if (Engine.has_singleton("GodotFacebook")):
		print("Facebook was detected")
		fb = Engine.get_singleton("GodotFacebook")
		fb.init(fb_app_id)
		fb.setFacebookCallbackId(get_instance_id())
		id = fb.getFacebookCallbackId()


func _on_Facebook_pressed() -> void:
	if fb.isLoggedIn() : 
		pass
		#Use Token 
	elif fb:
		var permission:Array = ["email","public_profile"]
		fb.login(permission)
	pass # Replace with function body.


func login_success(token):
	Token = token
	fb.userProfile(id,"request_success_profile")


func isLoggedIn() -> bool:
	if !fb:
		print("Pls loggin")
		return false
	return fb.isLoggedIn()


func request_success_profile(profile)->void:
	fb.callApi("me",{"fields":"email"},id,"request_data")
	pass


func request_data(data):
#	print(data)
	var email:String = data.email



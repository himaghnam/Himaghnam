extends Node

const API_KEY := ""
const PROJECT_ID := ""
const WEB_CLIENT_SECRET := ""
const WEB_CLIENT_ID := ""

const REGISTER_URL := "https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=%s" % API_KEY
const LOGIN_URL := "https://www.googleapis.com/identitytoolkit/v3/relyingparty/verifyPassword?key=%s" % API_KEY
const FIRESTORE_URL := "https://firestore.googleapis.com/v1/projects/%s/databases/(default)/documents/" % PROJECT_ID
const EMAIL_VERIFICATION_URL := "https://identitytoolkit.googleapis.com/v1/accounts:sendOobCode?key=%s" % API_KEY
const EMAIL_CONFIRMATION_URL := "https://identitytoolkit.googleapis.com/v1/accounts:lookup?key=%s" % API_KEY
const EMAIL_PASSWORD_RESET := "https://identitytoolkit.googleapis.com/v1/accounts:sendOobCode?key=%s" % API_KEY
const OAuth_URL := "https://identitytoolkit.googleapis.com/v1/accounts:signInWithIdp?key=%s" % API_KEY

var user_info := {}
var verified_email:bool = false 

signal login_successful

func _get_user_info(result: Array) -> Dictionary:
	var result_body := JSON.parse(result[3].get_string_from_ascii()).result as Dictionary
#	print(result_body)
	return {
		"token": result_body.idToken,
		"id": result_body.localId,
		"email": result_body.email
	}


func _get_request_headers() -> PoolStringArray:
	return PoolStringArray([
		"Content-Type: application/json",
		"Authorization: Bearer %s" % user_info.token
	])


func register(email: String, password: String, http: HTTPRequest) -> void:
	var body := {
		"email": email,
		"password": password,
	}
	
	http.request(REGISTER_URL, [], false, HTTPClient.METHOD_POST, to_json(body))
	
	var result := yield(http, "request_completed") as Array 
	if result[1] == 200:
		user_info = _get_user_info(result)
		var E_Verify := {
			"requestType": "VERIFY_EMAIL",
			"idToken": String(user_info.token),
			}
		http.request(EMAIL_VERIFICATION_URL,[], false, HTTPClient.METHOD_POST, to_json(E_Verify))

func login(email: String, password: String, http: HTTPRequest) -> void:
	var body := {
		"email": email,
		"password": password,
		"returnSecureToken": true
	}
	
	http.request(LOGIN_URL, [], false, HTTPClient.METHOD_POST, to_json(body))

	var result := yield(http, "request_completed") as Array
	if result[1] == 200:
		
#	var token := {"idToken": String(user_info.token)}
#	http.request(EMAIL_CONFIRMATION_URL, [], false, HTTPClient.METHOD_POST, to_json(token))
#	var result_token := yield(http, "request_completed") as Array
#	var paylod:Dictionary = JSON.parse(result_token[3].get_string_from_ascii()).result as Dictionary
#	if paylod.users[0].emailVerified:
		if bool((JSON.parse(result[3].get_string_from_ascii()).result as Dictionary).registered) == true:
			print("verified email")
			user_info = _get_user_info(result)
	

func save_document(path: String, fields: Dictionary, http: HTTPRequest) -> void:
	var document := { "fields": fields }
	var body := to_json(document)
	var url := FIRESTORE_URL + path
	http.request(url, _get_request_headers(), false, HTTPClient.METHOD_POST, body)

func get_document(path: String, http: HTTPRequest) -> void:
	var url := FIRESTORE_URL + path
	http.request(url, _get_request_headers(), false, HTTPClient.METHOD_GET)


func update_document(path: String, fields: Dictionary, http: HTTPRequest) -> void:
	var document := { "fields": fields }
	var body := to_json(document)
	var url := FIRESTORE_URL + path
	http.request(url, _get_request_headers(), false, HTTPClient.METHOD_PATCH, body)

func delete_document(path: String, http: HTTPRequest) -> void:
	var url := FIRESTORE_URL + path
	http.request(url, _get_request_headers(), false, HTTPClient.METHOD_DELETE)
	

func test_query(http: HTTPRequest):
	#query can be use for global leaderboard and you can seperate countries and even cities player using query
	#you need to create composite index in firebase which pre-sort these values
	var query = {"structuredQuery": {
			"from": [
			{"collectionId": "test"}],
		
		"where": {"fieldFilter": {
			"field": {"fieldPath": "country"},
			"op": "EQUAL",
			"value": {"stringValue": "IN"}}},
		"orderBy": [
			{"field": {"fieldPath": "score"},"direction": "ASCENDING"}],
		}
		}
	var req = to_json(query)
	var url := "https://firestore.googleapis.com/v1/projects/"+ PROJECT_ID +"/databases/(default)/documents:runQuery?key=%s" % API_KEY
	http.request(url,_get_request_headers(),false,HTTPClient.METHOD_POST,req)
	pass

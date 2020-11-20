extends Control

const TEST_ITEM_SKU:Array = ["inapp1","inapp2"]
const SUBS_SKU:Array = ["free_ads1"]

var payment = null
var test_item_purchase_token = null


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if Engine.has_singleton("GodotGooglePlayBilling"):
		payment = Engine.get_singleton("GodotGooglePlayBilling")
		# No params.
		payment.connect("connected", self, "_on_connected")
		# No params.
		payment.connect("disconnected", self, "_on_disconnected")
		# Response ID (int), Debug message (string).
		payment.connect("connect_error", self, "_on_connect_error")
		# Purchases (Dictionary[]).
		payment.connect("purchases_updated", self, "_on_purchases_updated")
		# Response ID (int), Debug message (string).
		payment.connect("purchase_error", self, "_on_purchase_error")
		# SKUs (Dictionary[]).
		payment.connect("sku_details_query_completed", self, "_on_sku_details_query_completed")
		# Response ID (int), Debug message (string), Queried SKUs (string[]).
		payment.connect("sku_details_query_error", self, "_on_sku_details_query_error")
		# Purchase token (string).
		payment.connect("purchase_acknowledged", self, "_on_purchase_acknowledged")
		# Response ID (int), Debug message (string), Purchase token (string).
		payment.connect("purchase_acknowledgement_error", self, "_on_purchase_acknowledgement_error")
		# Purchase token (string).
		payment.connect("purchase_consumed", self, "_on_purchase_consumed")
		# Response ID (int), Debug message (string), Purchase token (string).
		payment.connect("purchase_consumption_error", self, "_on_purchase_consumption_error")
		
		payment.startConnection()


func _on_connected():
	print("PurchaseManager connected")
	payment.querySkuDetails(TEST_ITEM_SKU,"inapp")
	
	
	var query_subs = payment.queryPurchases("subs") # Use "subs" for subscriptions.
	print((query_subs))
	
	if query_subs.status == OK:
		for purchase in query_subs.purchases:
			match purchase.sku:
				"free_ads_1":
					"don't load ads"
					pass
			if !purchase.is_acknowledged:
				purchased_subs = true
				purchased_inapp = purchase.sku
				payment.acknowledgePurchase(purchase.purchase_token)
				
	
	var query_inapp = payment.queryPurchases("inapp") # Use "subs" for subscriptions.
	print((query_inapp))
	if query_inapp.status == OK:
		for purchase in query_inapp.purchases:
			match purchase.sku:
				"inapp1":
					"allow it's use"
					pass
				"inapp2":
					"allow it's use"
					pass
				
			if !purchase.is_acknowledged:
				purchased_inapp = purchase.sku
				payment.acknowledgePurchase(purchase.purchase_token)


	
	
var purchasable_inapp:Dictionary
var subs:bool = false
func _on_sku_details_query_completed(sku_details):
	if !subs:
		for available_sku in sku_details:
			purchasable_inapp[available_sku.sku] = available_sku
			"{inapp1:{data},inapp2:{data}}" 
		subs = true
		payment.querySkuDetails(SUBS_SKU,"subs")
	else: #or if subs:
		for available_sku in sku_details:
			if available_sku.sku == "free_ads1":
				pass
		"Loading.hide()"

	
	

func _on_purchases_updated(purchases):
	print("Purchases updated: %s" % to_json(purchases))
	purchased_inapp = to_buy_item
	# See _on_connected
	for purchase in purchases:
		if !purchase.is_acknowledged:
			print("Purchase " + str(purchase.sku) + " has not been acknowledged. Acknowledging...")
			payment.acknowledgePurchase(purchase.purchase_token)

	if purchases.size() > 0:
		test_item_purchase_token = purchases[purchases.size() - 1].purchase_token



var purchased_inapp:String
var purchased_subs:bool = false
# warning-ignore:unused_argument
func _on_purchase_acknowledged(purchase_token):
#	print("Purchase acknowledged: %s" % purchase_token)
	if !purchased_subs:
		"open functions of purchased_inapp"
# warning-ignore:standalone_expression
		match purchased_inapp:
			"inapp1":
				pass
			"inapp2":
				pass
	else:
		"subscription func"
		purchased_subs = false
	"Global._save_game()"


	"or"
	match purchased_inapp:
		"inapp1":
			pass
		"inapp2":
			pass
		"free_ads_1":
			pass
	"Global._save_game()"
	
	
#func _on_purchase_consumed(purchase_token):
#	print("Purchase consumed successfully: %s" % purchase_token)
#
#
#func _on_purchase_error(code, message):
#	print("Purchase error %d: %s" % [code, message])
#
#
#func _on_purchase_acknowledgement_error(code, message):
#	print("Purchase acknowledgement error %d: %s" % [code, message])
#
#
#func _on_purchase_consumption_error(code, message, purchase_token):
#	print("Purchase consumption error %d: %s, purchase token: %s" % [code, message, purchase_token])
#
#
#func _on_sku_details_query_error(code, message):
#	print("SKU details query error %d: %s" % [code, message])


func _on_disconnected():
#	print("GodotGooglePlayBilling disconnected. Will try to reconnect in 10s...")
	yield(get_tree().create_timer(10), "timeout")
	payment.startConnection()




var to_buy_item:String

func _on_Button_pressed() -> void:
	payment.purchase("inapp1")
	to_buy_item = "inapp1"
	pass # Replace with function body.


func _on_Button2_pressed() -> void:
	payment.purchase("inapp2")
	to_buy_item = "inapp2"
	pass # Replace with function body.


func _on_Button3_pressed() -> void:
	purchased_subs = true
	payment.purchase("free_ads1")
	to_buy_item = "free_ads1"
	pass # Replace with function body.

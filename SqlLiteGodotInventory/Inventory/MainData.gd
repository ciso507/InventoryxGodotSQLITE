extends Node

const SQLite = preload("res://addons/godot-sqlite/bin/gdsqlite.gdns")
var db #path
var db_name = "res://DataStore/databasex"


var id = 1

func _ready():
	commitDataToDB()
#	stacker(1)
#	db = SQLite.new()
#	db.path = db_name
#	db.open_db()



func commitDataToDB():
	db = SQLite.new()
	db.path = db_name
	db.open_db()



func stacker(_id):
	db.query("select StackSize from ItemData where id =" + str(_id))
	for i in range(db.query_result.size()):
#		print(_id, "kalisto")
#		print(db.query_result[i]["StackSize"], db.query_result[i], "queries for each items within StackSize column")
		return db.query_result[i]["StackSize"]


#NEW NEW
func item_category(_id):    #usefull because we will be able to link this to our equip... if is shirt shoes or pants we can add to equipment slots
	db.query("select ItemCategory from ItemData where id =" + str(_id))
	for i in range(db.query_result.size()):
		return db.query_result[i]["ItemCategory"]


func item_name(_id):
	db.query("select Name from ItemData where id =" + str(_id))
	for i in range(db.query_result.size()):
		return db.query_result[i]["Name"]

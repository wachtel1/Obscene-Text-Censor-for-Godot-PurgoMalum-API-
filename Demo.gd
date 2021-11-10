extends Control

export var start_url = "https://community-purgomalum.p.rapidapi.com/"
export var host = "community-purgomalum.p.rapidapi.com"
export var key = "REPLACE ME"

export var add = ""
	#A comma separated list of words to be added to the profanity list. 
	#Accepts letters, numbers, underscores (_) and commas (,). 
	#Accepts up to 10 words (or 200 maximum characters in length). 
	#The PurgoMalum filter is case-insensitive, so the case of you entry is not important.

export var fill_text = ""	
	#Text used to replace any words matching the profanity list.
	#Accepts letters, numbers, underscores (_) tildes (~), exclamation points (!), dashes/hyphens (-), 
	#equal signs (=), pipes (|), single quotes ('), double quotes ("), asterisks (*), 
	#open and closed curly brackets ({ }), square brackets ([ ]) and parentheses (). 
	#Maximum length of 20 characters. When not used, the default is an asterisk (*) fill.
	
export var fill_char = ""
	#Single character used to replace any words matching the profanity list. 
	#Fills designated character to length of word replaced. Accepts underscore (_) tilde (~), dash/hyphen (-), equal sign (=), pipe (|) and asterisk (). 
	#When not used, the default is an asterisk (*) fill.

var url = ""
var headers =  ["x-rapidapi-host: " + host, "x-rapidapi-key: " + key]

onready var TextInput = $VBoxContainer/LineEdit
onready var ReplaceButton = $VBoxContainer/ReplaceText
onready var CheckButton = $VBoxContainer/CheckText
onready var Result = $VBoxContainer/Result
var text = ""

var http_request = HTTPRequest.new()
const error_scene = preload("res://ErrorMessage.tscn")

func _ready():
	ReplaceButton.connect("pressed", self, "replace_text")
	CheckButton.connect("pressed", self, "check_text")
	add_child(http_request)
	http_request.connect("request_completed", self, "_http_request_completed")

func replace_text():
	http_request.cancel_request()
	text = TextInput.text.percent_encode()
	url = start_url + "json?text=" + text + "&add=" + add + "&fill_text=" + fill_text + "&fill_char=" + fill_char
	_create_request(url, headers)

func check_text():
	http_request.cancel_request()
	text = TextInput.text.percent_encode()
	url = start_url + "/containsprofanity?text=" + text
	_create_request(url, headers)

func _create_request(request_url, request_headers):
	var error = http_request.request(request_url, request_headers)
	if error != OK:
		var error_message = error_scene.instance()
		error_message.position = Vector2(500, 285)
		add_child(error_message)

func _http_request_completed(result, _response_code, _headers, body):
	if result != 0:
		var error_message = error_scene.instance()
		error_message.position = Vector2(500, 285)
		add_child(error_message)
		return
	var json = JSON.parse(body.get_string_from_utf8())
	if json.result is bool:
		Result.set_text(str(json.result))
	else:
		Result.set_text(json.result.get("result"))

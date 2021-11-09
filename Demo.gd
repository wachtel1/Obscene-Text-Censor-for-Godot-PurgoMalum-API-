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

onready var text_input = $VBoxContainer/LineEdit
onready var replace_button = $VBoxContainer/ReplaceText
onready var check_button = $VBoxContainer/CheckText
onready var result = $VBoxContainer/Result
var text = ""
var result_text = ""

var http_request = HTTPRequest.new()

func _ready():
	#Prepare the scene and add the HTTPRequest node
	replace_button.connect("pressed", self, "replace_text")
	check_button.connect("pressed", self, "check_text")
	add_child(http_request)
	http_request.connect("request_completed", self, "_http_request_completed")

func replace_text():
	text = text_input.text.percent_encode()
	url = start_url + "json?text=" + text + "&add=" + add + "&fill_text=" + fill_text + "&fill_char=" + fill_char
	var error = http_request.request(url, headers)
	if error != OK:
		push_error("An error occurred")

func check_text():
	text = text_input.text.percent_encode()
	url = start_url + "/containsprofanity?text=" + text
	var error = http_request.request(url, headers)
	if error != OK:
		push_error("An error occurred")

func _http_request_completed(_result, _response_code, _headers, body):
	var json = JSON.parse(body.get_string_from_utf8())
	if json.result is bool:
		result.set_text(str(json.result))
	else:
		result.set_text(json.result.get("result"))
extends Node

const ANTHROPIC_API_KEY = "put key here"
const API_URL = "https://api.anthropic.com/v1/messages"

var conversation_history = []

func _ready() -> void:
	send_message("Hey Claude, can you describe an Apple?")
	
	
func send_message(user_message: String) -> void:
	var http_request = HTTPRequest.new()
	add_child(http_request)
	http_request.request_completed.connect(_on_request_completed)
	
	var headers = [
		"Content-Type: application/json",
		"x-api-key: " + ANTHROPIC_API_KEY,
        "anthropic-version: 2023-06-01"
	]
	
	var body = JSON.stringify({
		"model": "claude-sonnet-4-6",
		"max_tokens": 1024,
		"messages": [
			{"role": "user", "content": user_message}
		]
	})
	
	http_request.request(API_URL, headers, HTTPClient.METHOD_POST, body)

func _on_request_completed(result, response_code, headers, body):
	if response_code == 200:
		var json = JSON.parse_string(body.get_string_from_utf8())
		var reply = json["content"][0]["text"]
		print("Claude: ", reply)
	else:
		print("Error: ", response_code, body.get_string_from_utf8())

extends Node

func focus_message_edit():
	if not %message_edit.focus_mode:
		%message_edit.focus_mode = Control.FOCUS_ALL

	%message_edit.grab_focus()

func _ready() -> void:
	if $Networking.username:
		get_viewport().focus_entered.connect(focus_message_edit)

func _on_send_pressed() -> void:
	%message_edit.text_submitted.emit(%message_edit.text)
	focus_message_edit()

func _on_message_edit_text_submitted(message: String) -> void:
	$Networking.serve_message(message)
	%message_edit.clear()

func _on_username_prompt_submit(username: String) -> void:
	$Networking.username = username
	$Networking.create_or_join()
	focus_message_edit()

func _on_messages_focus_entered() -> void:
	if $Networking.username:
		focus_message_edit()
	else:
		%username.grab_focus()

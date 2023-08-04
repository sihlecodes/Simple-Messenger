extends Node

func _on_send_pressed() -> void:
	%message_edit.text_submitted.emit(%message_edit.text)
	%message_edit.grab_focus()

func _on_message_edit_text_submitted(message: String) -> void:
	$Networking.serve_message.rpc_id(1, message)
	%message_edit.clear()

func _on_messages_focus_entered() -> void:
	%message_edit.grab_focus()

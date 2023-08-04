extends Node

func _on_send_pressed() -> void:
	%text_edit.text_submitted.emit(%text_edit.text)
	%text_edit.grab_focus()

func _on_text_edit_text_submitted(new_text: String) -> void:
	$Networking.send.rpc(new_text)
	%text_edit.clear()

func _on_messages_focus_entered() -> void:
	%text_edit.grab_focus()

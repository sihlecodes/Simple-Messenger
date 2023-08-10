extends Panel

signal submit(username: String)

func _ready() -> void:
	%username.grab_focus()
	%username.text_submitted.connect(func(username): submit.emit(username))

func _on_confirm_pressed() -> void:
	%username.text_submitted.emit(%username.text)

func _on_username_text_submitted(username: String) -> void:
	var text = %username.text

	if not text:
		%username.placeholder_text = "Username can't be empty."
		return

	submit.emit(%username.text)
	hide()

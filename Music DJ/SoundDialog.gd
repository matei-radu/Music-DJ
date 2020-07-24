extends PopupDialog

onready var main = get_parent()

var instrument_index
var column
var pressed_button_index = 0
var genre_index = 0
onready var item_list = $VBoxContainer/ItemList


func _ready():
	
	var text = ["Groove 1", "Groove 2", "Salsa 1", "Salsa 2", "Reggae 1", "Reggae 2", "Techno 1", "Techno 2"]
	var category = ["Introduction", "Verse", "Chorus", "Solo"]
	var color = [Color(0.678, 0.847, 90.2), Color(0.565, 0.933, 0.565), Color(1, 0.502, 1), Color(1, 0.894, 0.71)]
	var button_index = -1
	
	for i in 4:
		var scroll_container = $VBoxContainer/ScrollContainer/VBoxContainer
		
		var separator = HSeparator.new()
		separator.set("custom_constants/separation", 10)
		separator.modulate = Color(1, 1, 1, 0.01)
		scroll_container.add_child(separator)
		
		var label = Label.new()
		label.text = category[i]
		label.theme = preload("res://assets/theme 2.tres")
		scroll_container.add_child(label)
		
		var separator2 = HSeparator.new()
		separator2.theme = preload("res://assets/theme 2.tres")
		scroll_container.add_child(separator2)
		
		# Icon
		var image = Image.new()
		var texture = ImageTexture.new()
		image.create(32, 32, false, Image.FORMAT_RGBA4444)
		image.lock()
		for v in 32:
			for h in 32:
				image.set_pixel(h, v, color[i])
		image.unlock()
		texture.create_from_image(image)
		
		# Buttons
		for g in 8:
			button_index += 1
			var button = Button.new()
			button.text = " "+text[g]
			button.theme = preload("res://assets/theme 2.tres")
			button.icon = texture
			button.align = Button.ALIGN_LEFT
			button.mouse_filter = Button.MOUSE_FILTER_PASS
			button.connect("pressed", self, "on_Button_selected", [button_index, g])
			button.name = str(button_index)
			button.focus_mode = Control.FOCUS_CLICK
			scroll_container.add_child(button)
			

func _on_SoundDialog_about_to_show():
	$VBoxContainer/HBoxContainer/OkButton.disabled = true
	
	var instrument
	
	if instrument_index == 0:
		instrument = "Drums"
	elif instrument_index == 1:
		instrument = "Bass"
	elif instrument_index == 2:
		instrument = "Keys"
	elif instrument_index == 3:
		instrument = "Trumpet"

	$VBoxContainer/Label.text = instrument

func on_Button_selected(index, genre):
	var offsets = {0:1, 9:2, 18:3, 27:4}
	var offset = 0

	print(str(instrument_index)+"/"+str(index+1))
	$AudioStreamPlayer.stream = load("res://sounds/"+str(instrument_index)+"/"+str(index+1)+".wav")
	$AudioStreamPlayer.play()
	$VBoxContainer/HBoxContainer/OkButton.disabled = false
	pressed_button_index = index
	genre_index = genre

func _on_OkButton_pressed():
	# Button
	var step = main.get_node("HBoxContainer/StepContainer/HBoxContainer").get_child(column)
	var button = step.get_child(instrument_index+1)
	var style_box = StyleBoxTexture.new()
	
	button.text = str(genre_index+1)
	
	style_box.texture = get_node("VBoxContainer/ScrollContainer/VBoxContainer/"+str(pressed_button_index)).icon
	button.set("custom_styles/normal", style_box)
	
	main.song[instrument_index][column] = pressed_button_index+1

	$VBoxContainer/ItemList.get_v_scroll().set_value(0.0)
	hide()
	column = 0


func _on_ClearButton_pressed():
	var step = main.get_node("HBoxContainer/StepContainer/HBoxContainer").get_child(column)
	var button = step.get_child(instrument_index+1)
	button.text = ""
	button.set("custom_styles/normal", null)
	
	main.song[instrument_index][column] = 0

	hide()


func _on_CancelButton_pressed():
	hide()


func _on_SoundDialog_popup_hide():
	$VBoxContainer/ScrollContainer.scroll_vertical = 0

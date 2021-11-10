extends Node2D

func _on_TryAgain_pressed():
	queue_free()

func _on_Quit_pressed():
	get_tree().quit()

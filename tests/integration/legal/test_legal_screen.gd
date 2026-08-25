extends GdUnitTestSuite


func test_legal_screen_exposes_shipping_notices() -> void:
	var packed := load("res://ui/legal/legal.tscn") as PackedScene
	var legal := auto_free(packed.instantiate()) as LegalScreen
	add_child(legal)
	await await_idle_frame()
	var text := String(legal.get_node("Margin/Content/Scroll/LegalText").text)
	assert_str(text).contains("Godot Engine 4.7.2")
	assert_str(text).contains("Hull Breach does not require an account")
	assert_object(legal.get_node("Margin/Content/BackButton")).is_instanceof(Button)

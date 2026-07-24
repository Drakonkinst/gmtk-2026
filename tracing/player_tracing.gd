class_name PlayerTracing
extends Node2D

var trace_data_array: Array[PackedInt64Array]

func _input(event: InputEvent) -> void:
    if event.is_action_pressed("draw"):
        var new_line := TraceLine.new()
        add_child(new_line)

func _on_child_entered_tree(node: Node) -> void:
    if node is TraceLine:
        trace_data_array.append(node.trace_data)

func get_tracing_info() -> Array:
    return trace_data_array

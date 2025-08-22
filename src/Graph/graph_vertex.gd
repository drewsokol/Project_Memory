# Represents a vertex (node) in the graph
class_name GraphVertex

var id: String
var data: Dictionary
var neighbors: Array[GraphVertex]

func _init(_id: String):
	id = _id
	data = {}
	neighbors = []

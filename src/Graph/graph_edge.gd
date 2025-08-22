# Represents an edge (connection) in the graph
class_name GraphEdge

var from: GraphVertex  # Starting vertex
var to: GraphVertex    # Ending vertex
var data: Dictionary  # Custom data (e.g., weight, cost, etc.)

func _init(_from: GraphVertex, _to: GraphVertex):
	from = _from
	to = _to
	data = {}

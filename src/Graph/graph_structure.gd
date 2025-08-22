class_name GraphStructure extends Resource

var vertices: Array[GraphVertex] = []
var edges: Array[GraphEdge] = []
var is_directed: bool = false  # Directed or undirected graph

func _init(directed: bool = false):
	is_directed = directed

# Add a vertex to the graph
func add_vertex(id: String) -> GraphVertex:
	var vertex = GraphVertex.new(id)
	vertices.append(vertex)
	return vertex

# Add an edge between two vertices
func add_edge(from: GraphVertex, to: GraphVertex, data: Dictionary = {}) -> GraphEdge:
	var edge = GraphEdge.new(from, to)
	edge.data = data
	edges.append(edge)
	from.neighbors.append(to)
	if not is_directed:
		# For undirected graphs, add reverse neighbor
		to.neighbors.append(from)
	return edge

# Remove a vertex and its associated edges
func remove_vertex(vertex: GraphVertex) -> void:
	vertices.erase(vertex)
	edges = edges.filter(func(edge): return edge.from != vertex and edge.to != vertex)
	for v in vertices:
		v.neighbors.erase(vertex)

# Remove an edge
func remove_edge(from: GraphVertex, to: GraphVertex) -> void:
	edges = edges.filter(func(edge): return not (edge.from == from and edge.to == to))
	from.neighbors.erase(to)
	if not is_directed:
		to.neighbors.erase(from)

# Get all edges connected to a vertex
func get_edges(vertex: GraphVertex) -> Array[GraphEdge]:
	return edges.filter(func(edge): return edge.from == vertex or (not is_directed and edge.to == vertex))

# Get all neighbors of a vertex
func get_neighbors(vertex: GraphVertex) -> Array[GraphVertex]:
	return vertex.neighbors.duplicate()

# Check if two vertices are connected by an edge
func has_edge(from: GraphVertex, to: GraphVertex) -> bool:
	return edges.any(func(edge): return edge.from == from and edge.to == to)

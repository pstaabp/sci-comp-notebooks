module WeightedGraphs

import Graphs: SimpleGraph, add_vertices!, add_edge!

export Vertex, Edge, WeightedGraph, addVertex!, addEdge!

"""
A vertex in a graph. Takes a symbol as an argument.

### Examples

```
v1 = Vertex(:a)
v2 = Vertex(:b)
v3 = Vertex(:c)
```
"""
struct Vertex
  name::Symbol
end

"""
An edge in a graph. The arguments are the starting vertex (as a symbol), the ending vertex (as a Symbol) and the third is the weight, a non-negative real number.

### Examples

```
e1 = Edge(:a,:b,3)
e2 = Edge(:a,:c,10)
```

"""
struct Edge
  start::Symbol
  finish::Symbol
  weight::Real
end

"""
A weighted graph, that is a graph with edges that are weighted. 

### Examples
```
g = WeightedGraph()
```
makes a new Weighted Graph with no vertices or edges.
"""
struct WeightedGraph
  vertices::Vector{Vertex}
  edges::Vector{Edge}
  graph::SimpleGraph
  
  function WeightedGraph(v::Vector{Vertex}, e::Vector{Edge}, g::SimpleGraph)
    new(v,e,g)
  end
  
  function WeightedGraph()
    new([],[],SimpleGraph())
  end
end

"""
Adds an `Edge` to the `WeightedGraph`

### Example
```
g = WeightedGraph()
v1 = Vertex(:a)
v2 = Vertex(:b)
v3 = Vertex(:c)
addVertex!(g,v1)
addVertex!(g,v2)
addVertex!(g,v3)

e1 = Edge(:a,:b,3)
e2 = Edge(:a,:c,10)
addEdge!(g,e1)
addEdge!(g,e2)
```
"""
function addEdge!(g::WeightedGraph, e::Edge)
  i = findfirst(n -> n.name == e.start, g.vertices)
  i != nothing || throw(ArgumentError("The node with name $(edge.start) does not exist."))
  j = findfirst(n -> n.name == e.finish, g.vertices)
  j != nothing || throw(ArgumentError("The node with name $(edge.finish) does not exist."))
  e.weight >0 || throw(ArgumentError("The weight of $(edge.weight) must be positive"))
  push!(g.edges,e)
  add_edge!(g.graph,i,j)
end

"""
Adds a `Vertex` to the `WeightedGraph`

### Example
```
g = WeightedGraph()
v1 = Vertex(:a)
v2 = Vertex(:b)
v3 = Vertex(:c)
addVertex!(g,v1)
addVertex!(g,v2)
addVertex!(g,v3)
```
"""
function addVertex!(g::WeightedGraph, v::Vertex)
  i = findfirst(n -> n.name == v.name, g.vertices)
  if i == nothing 
    add_vertices!(g.graph,1)
    push!(g.vertices,v)
  else
    throw(ArgumentError("The vertex with name $(v.name) already exists."))
  end
end

end
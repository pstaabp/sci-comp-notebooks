module Points

export Point2D

struct Point2D{T <: Real}
  x::T
  y::T
  
  Point2D(x::T,y::T) where {T <: Real} = new{T}(x,y)
end

end # module Points
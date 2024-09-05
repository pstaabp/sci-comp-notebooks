module Points

export Point2D

struct Point2D{T <: Real}
  x::T
  y::T
  
  Point2D(x::T,y::T) where {T <: Real} = new{T}(x,y)
  
  function Point2D(x::T,y::S) where {T <: Real, S <: Real}
    local Type = promote_type(T,S)
    new{Type}(convert(Type,x),convert(Type,y))
  end
end

end # module Points
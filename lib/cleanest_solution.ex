# This improves the solution a bit by allowing multiple args for the shape protocol.
defmodule Square do
  defstruct [:side]
end

# we have to defstruct still because protocols...
defmodule Area do
  defstruct []
end

defprotocol Shape do
  def calculate(calculation, shape)
end

defprotocol AreaProtocol do
  def calculate(shape)
end

defimpl AreaProtocol, for: Square do
  def calculate(%Square{side: side}) do
    side * side
  end
end

defimpl Shape, for: Area do
  def calculate(%Area{}, shape) do
    AreaProtocol.calculate(shape)
  end
end

Shape.calculate(%Area{}, %Square{side: 2})

# Okay, now lets add a new shape

defmodule Circle do
  defstruct [:radius]
end

defimpl AreaProtocol, for: Circle do
  def calculate(%Circle{radius: radius}) do
    3.14 * radius * radius
  end
end

Shape.calculate(%Area{}, %Circle{radius: 2})

# Easy enough. But what about a perimeter?

defmodule Perimeter do
  defstruct []
end

defprotocol PerimeterProtocol do
  def calculate(shape)
end

defimpl Shape, for: Perimeter do
  def calculate(%Perimeter{}, shape) do
    PerimeterProtocol.calculate(shape)
  end
end

# Now we can implement the PerimeterProtocol for any shape:

defimpl PerimeterProtocol, for: Square do
  def calculate(%Square{side: side}) do
    side * 4
  end
end

Shape.calculate(%Perimeter{}, %Square{side: 10})

# Boom!

# Okay so what if we switch the order of the arguments so that we can pipe in the shapes
# rather than the calculation structs?

defmodule Square do
  defstruct [:side]
end

defmodule Area do
  defstruct []
end

defprotocol Shape do
  def calculate(shape, calculation)
end

defprotocol SquareProtocol do
  def calculate(calculation, shape)
end

defimpl SquareProtocol, for: Area do
  def calculate(%Area{}, %Square{side: side}) do
    side * side
  end
end

defimpl Shape, for: Square do
  def calculate(shape = %Square{}, calculation) do
    SquareProtocol.calculate(calculation, shape)
  end
end

%Square{side: 2}
|> Shape.calculate(%Area{})



defprotocol Shape do
  def area(shape)
end


defimpl Shape, for: Square do
  def area(shape) do
  end
end


# /sf sdakfh sdalhjdskl


# This improves the solution a bit by allowing multiple args for the shape protocol.
defmodule Square do
  defstruct [:side]
end

# we have to defstruct still because protocols...
defmodule Area do
  defstruct []
end

defprotocol Shape do
  def calculate(shape, calculation)
end

# defprotocol AreaProtocol do
#   def calculate(shape)
# end

defimpl Shape, for: Square do
  def calculate(%Square{side: side}, calculation) do
    side * side
  end
end

# defimpl Shape, for: Area do
#   def calculate(%Area{}, shape) do
#     AreaProtocol.calculate(shape)
#   end
# end


# Make some shapes
defmodule Square do
  defstruct [:side]
end

defmodule Circle do
  defstruct [:radius]
end

# define the protocol
defprotocol Shape do
  def area(shape)
end

# implement it for the Shape type
defimpl Shape, for: Area do
  def area(shape) do
    shape.side * shape.side
  end
end

# implement it for the Circle type
defimpl Shape, for: Circle do
  def area(shape) do
    shape.radius * shape.radius * 3.14
  end
end

defprotocol Shape do
  def perimeter(shape)
end

defprotocol ShapeExtended do
  def perimeter(shape)
end

defprotocol Perimeter do
  def calculate(shape)
end

ShapeExtended.perimeter(shape)



defmodule Square do
  defstruct [:side]
end

defmodule Circle do
  defstruct [:radius]
end

defprotocol Area do
  def calculate_for(shape)
end

defprotocol Perimeter do
  def calculate_for(shape)
end


Area.calculate_for(%Square{side: 10})
Perimeter.calculate_for(%Circle{radius: 10})










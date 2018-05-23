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









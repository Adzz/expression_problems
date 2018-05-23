defmodule Square do
  defstruct [:side]
end

defprotocol AreaProtocol do
  def calculate(shape)
end

defimpl AreaProtocol, for: Square do
  def calculate(%Square{side: side}) do
    side * side
  end
end

defprotocol Shape do
  def apply(calculation)
end

defmodule Area do
  defstruct [:calculation]

  def calculation() do
    %Area{calculation: fn shape -> AreaProtocol.calculate(shape) end}
  end
end

defimpl Shape, for: Area do
  def apply(%Area{calculation: calculation}) do
    calculation
  end
end

%Square{side: 2}
|> Shape.apply(Area.calculation).()

# Okay, the way we call the function is a bit weird but now lets add a new shape

defmodule Circle do
  defstruct [:radius]
end

defimpl AreaProtocol, for: Circle do
  def calculate(%Circle{radius: radius}) do
    3.14 * radius * radius
  end
end

c = %Circle{radius: 2}
Shape.apply(Area.calculation).(c)

# Easy enough. But what about a perimeter?

defmodule Perimeter do
  defstruct [:calculation]

  def calculation() do
    %Perimeter{calculation: fn shape -> PerimeterProtocol.calculate(shape) end}
  end
end

defimpl Shape, for: Perimeter do
  def apply(calculation) do
    calculation.calculation
  end
end

defprotocol PerimeterProtocol do
  def calculate(shape)
end

# Now we can implement the PerimeterProtocol for all shapes:

defimpl PerimeterProtocol, for: Square do
  def calculate(square) do
    square.side * 4
  end
end

%Square{side: 2} |> Shape.apply(Perimeter.calculation).()

# Boom!

# The other solutions allow double dispatch.
# Can we make the triple?
# What about an arbritrary amount of dispatch?

# First of all we need three things to switch on.

# Shape, Calculation, Unit? cost? colour?
# needs to be something which will add some sort of calculation to the proceedings
# Time?

# Need a combination of three things to create something. Age, place of birth, name - auth?
# A function of those three things provides the result
# What's an example of triple dispatch

defmodule AmazeOn do
  defstruct [price: 10]
end

defmodule Area do
  defstruct []
end

defmodule Square do
  defstruct [:side]
end

defprotocol ShapePricePerShop do
  def calculate(calculation, shape, shop)
end

defprotocol AreaProtocol do
  def calculate(shape, shop)
end

defprotocol SquareProtocol do
  def calculate(shape, shop)
end

defimpl SquareProtocol, for: AmazeOn do
  def calculate(%AmazeOn{price: price}, %Square{side: side}) do
    side * side * price
  end
end

defimpl AreaProtocol, for: Square do
  def calculate(shape = %Square{}, shop) do
    SquareProtocol.calculate(shop, shape)
  end
end

defimpl ShapePricePerShop, for: Area do
  def calculate(%Area{}, shape, shop) do
    AreaProtocol.calculate(shape, shop)
  end
end

ShapePricePerShop.calculate(%Area{}, %Square{side: 10}, %AmazeOn{})


# Phew. Okay so what if we now try and add perimeter to this unholy mess...

defmodule Perimeter do
  defstruct []
end

defimpl ShapePricePerShop, for: Perimeter do
  def calculate(%Perimeter{}, shape, shop) do
    PerimeterProtocol.calculate(shape, shop)
  end
end

defprotocol PerimeterProtocol do
  def calculate(shape, shop)
end

defimpl PerimeterProtocol, for: Square do
  def calculate(shape = %Square{}, shop) do
    SquareProtocol.calculate(shop, shape)
  end
end

ShapePricePerShop.calculate(%Perimeter{}, %Square{side: 10}, %AmazeOn{})





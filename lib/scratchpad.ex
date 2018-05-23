# defprotocol Shape do
#   def functions(test)
# end

# defimpl Shape, for: Any do
#   def functions(thing) do

#   end
# end

defmodule Shape do
  # defmacro define_interface(funs) do
  #   quote do
  #     for fun <- unquote(funs) do
  #       def unquote(:"#{fun}")() do
  #         10
  #       end
  #     end
  #   end
  # end

  defmacro generate_dynamic(name) do
    quote do
      defprotocol Thing do
        def unquote(:"add_#{name}")(shape)
      end
    end
  end
end

# defprotocol Perimeter do
#   def calculate(shape)
# end


defmodule Square do
  defstruct [:side]

  defimpl Thing do
    def add_test(%Square{side: side}) do
      side + 10
    end
  end

  # defimpl Perimeter do
  #   def calculate(s) do
  #     s.side * 4
  #   end
  # end
end


# defmodule Shape do
#   def calculate(fun, shape) do
#     case fun do
#       :area -> shape.__struct__.area(shape)
#       :perimeter -> shape.__struct__.perimeter(shape)
#     end
#   end
# end

defmodule Square do
  defstruct :side
end

defmodule Circle do
  defstruct :diameter
end

defmodule Shape do
  def calculate(fun, shape) do
    apply(shape.__struct__, fun, shape)
  end
end

# The function that eventually gets called is a function of the first TWO args
# Can we make it a function of the combination of all arguments?
# We need a protocol first for the first argument then another one for the next one
# And so on? Does currying help at all? one arg at a time, pass to the next protocol

Shape.calculate(:area, %Square{side: 10})
Shape.calculate(:area, %Circle{diameter: 10})
Shape.calculate(:perimeter, %Circle{diameter: 10})

%Square{side: 10}
|> Shape.calculate(:area)

# how do I add a shape.

defmodule Triangle do
  defstruct :side
end

# How do I add perimeter? I need to go to every shape and add an implementation.
# But what if I can't access that module. Then I need to make sure the function is
# defined in a protocol. so I can defimpl for any shape then

defprotocol Shape do
  def calculate(fun_module, shape)
end

defimpl Shape, for: Area do
  def calculate(fun_module, shape) do
    apply(fun_module, :calculate, shape)
  end
end


#  WE OUT HERE CURRYING PROTOCOLS

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

square = %Square{side: 2}
Shape.apply(Area.calculation).(square)

# Okay, calling function is a bit weird but now lets add a new shape

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

# if that worked we can do:

%Square{side: 2} |> Shape.apply(Perimeter.calculation).()



# Okay so that works, but there is a lot to not like about it
# Like a lot.
# dont like that the Area modules have to be structs. I dont like that you can't enforce
# the default to be a function you define.
# I dont like how we have to return a function that we invoke later. Doesnt feel very elixir-y
# How do we make this idea general
# Can the shape protocol be implemented for Any ?

# Can macros save us?




















defmodule Area do
  def calculate(shape) do
    AreaProtocol.calculate(shape)
  end
end

sq = %Square{side: 2}
Shape.calculate(&Area.calculate/1).(sq)

# Now lets add a shape

defmodule Circle do
  defstruct [:radius]
end

defimpl AreaProtocol, for: Circle do
  def calculate(%Circle{radius: radius}) do
    3.14 * radius * radius
  end
end
c = %Circle{radius: 2}
Shape.calculate(&Area.calculate/1).(c)

# Okay now how about perimeter?

defmodule Perimeter do
  def calculate(shape) do
    PerimeterProtocol.calculate(shape)
  end
end


# calculation_struct is now a functor, and we are lifting values into it. I think.
# defmodule Area do
#   defstruct [:calculate]

#   def new(), do: %Area{calculate: fn (shape) -> AreaProtocol.calculate(shape) end}

#   defimpl Shape do
#     def calculate(%Area{calculate: calculation}) do
#       calculation
#     end
#   end
# end

defmodule Area do
  defstruct [:ignore]

  def new(), do: %Area{}

  defimpl Shape do
    def calculate(%Area{}) do
      fn (shape) -> AreaProtocol.calculate(shape) end
    end
  end
end


# RETURNS YOU A FUNCTION THAT IS EXPECTING A SHAPE,
# AND WILL CALL THE AREA PROTOCOL AND PASS THE SHAPE IN TO IT.
Shape.calculate(Area.new).(%Square{side: 10})
Shape.calculate(&Area.calculate/1).(%Square{side: 10})


defprotocol PerimeterProtocol do
  def calculate(shape)
end

defmodule Perimeter do
  defimpl Shape do
    def calculate(shape) do
      PerimeterProtocol.calculate(shape)
    end
  end
end


defimpl Shape, for: Area do
  def calculate(fun_module) do
    fun_module.calculate # if this returns a function that expects a shape, we might be real good?
  end
end



# Shape.calculate(Area, %Square{side: 10})

# be able to add a function. Have a protocol define functions
# does the protocol






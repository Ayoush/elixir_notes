a = fn a, b -> %{String.to_atom("#{a}") => b} end
IO.inspect(a.(1,2))

func = fn
    {:ok, file} ->
      a = IO.read(file, :all)
      IO.puts(a)
    {_, reason} ->
      IO.puts(reason)
end

func.(File.open("sample.json"))
func.(File.open("sample1.json"))



#Function closure

greet = fn name -> fn -> IO.puts("Hello #{name}") end end

dave = greet.("dave")
dave.()


add_n = fn n -> fn other -> n + other end end
add_2 = add_n.(2)
add_5 = add_n.(5)
IO.puts(add_2.(3))
IO.puts(add_5.(3))


a = fn name ->
      fn
        (^name) -> IO.puts("Hello #{name}")
        _       -> IO.puts("I don't know you")
      end
    end

b = a.("dave")
b.("dave")
b.("ayoush")
# b.()

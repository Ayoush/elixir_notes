# Elixir Fundamentals

## Pattern Matching

```bash
iex> a = 1 1
iex> a + 3 4
```

In Elixir, the equals sign is not an assignment. Instead it’s like an assertion. It succeeds if Elixir can find a way of making the left-hand side equal the right-hand side.

```bash
iex> a = 1 1
iex> 1 = a 1
iex> 2 = a
```
Elixir looks for a way to make the value of the left side the same as the value of the right side. 
Elixir calls this process pattern matching. A pattern (the left side) is matched if the values (the right side) have the same structure and if each term in the pattern can be matched to the corresponding term in the values. A literal value in the pattern matches that exact value, and a variable in the pattern matches by taking on the corresponding value.

```bash
iex> [1, _, _] = [1, 2, 3]
[1, 2, 3]
iex> [1, _, _] = [1, "cat", "dog"] [1, "cat", "dog"]
```
If we didn’t need to capture a value during the match, we could use the special variable _ (an underscore). This acts like a variable but immediately discards any value given to it—in a pattern match,

## Once a variable has been bound to a value in the matching process, it keeps that value for the remainder of the match.
```bash
iex> [a, a] = [1, 1] [1, 1]
iex> a
1
iex> [b, b] = [1, 2]
** (MatchError) no match of right hand side value: [1, 2]
```

if you instead want to force Elixir to use the existing value of the variable in the pattern? Prefix it with ^ (a caret).

```bash
iex> a = 1 1
iex> a = 2 2
iex> ^a = 1
```

Tuples, A tuple is an ordered collection of values. 

```bash
iex> {status, count, action} = {:ok, 42, "next"} {:ok, 42, "next"}
iex> status
:ok
iex> count 42
iex> action "next"
```

Keyword Lists Because we often need simple lists of key/value pairs, Elixir gives us a shortcut. If we write
```bash
[ name: "Dave", city: "Dallas", likes: "Programming" ]
```

Elixir converts it into a list of two-value tuples:

```bash
[ {:name, "Dave"}, {:city, "Dallas"}, {:likes, "Programming"} ]
```

A map is a collection of key/value pairs. A map literal looks like this:
```bash
%{ key => value, key => value }
states = %{ "AL" => "Alabama", "WI" => "Wisconsin" }
%{"AL" => "Alabama", "WI" => "Wisconsin"}
iex> states = %{ "AL" => "Alabama", "WI" => "Wisconsin" } %{"AL" => "Alabama", "WI" => "Wisconsin"}
iex> states["AL"]
"Alabama"
iex> states["TX"] 
nil
```

If the keys are atoms, you can also use a dot notation:
```bash
iex> colors = %{ red: 0xff0000, green: 0x00ff00, blue: 0x0000ff } %{blue: 255, green: 65280, red: 16711680}
iex> colors[:red]
16711680
iex> colors.green 65280
```

The with expression serves double duty. First, it allows you to define a local scope for variables. 
```bash
content = "Now is the time"
lp = with {:ok, file} = File.open("/etc/passwd"),
content = IO.read(file, :all), # note: same name as above :ok = File.close(file),
[_, uid, gid] = Regex.run(~r/^lp:.*?:(\d+):(\d+)/m, content)
do
"Group: #{gid}, User: #{uid}" end
IO.puts lp #=> Group: 26, User: 26 IO.puts content #=> Now is the time
```

# With Statment '=' and '<-' operator
```bash
defmodule WithStatement do
  def general_statement do
    with {:ok, file} = File.open("sample.json"),
          content = IO.read(file, :all) do
      IO.puts(content)
    end
  end
end
```

There is a very big difference in above code if the file is not present the our code will throw error but if we use '<-' operator then we will get a error message and code will not fail

```bash
defmodule WithStatement do
  def general_statement do
    result = with {:ok, file} <- File.open("sample1.json"),
                content <- IO.read(file, :all) do
                  content
              end
  end
end
```

# Anonymous Functions

```bash
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
```

Elixir automatically carry with them the bindings of variables in the scope in which they are defined. In our example, the variable name is bound in the scope of the outer function. When the inner function is defined, it inherits this scope and carries the binding of name around with it. This is a closure—the scope encloses the bindings of its vari- ables, packaging them into something that can be saved and used later.

```bash
greet = fn name -> fn -> IO.puts("Hello #{name}") end end

dave = greet.("dave")
dave.()

add_n = fn n -> fn other -> n + other end end
add_2 = add_n.(2)
add_5 = add_n.(5)
IO.puts(add_2.(3))
IO.puts(add_5.(3))
```

```bash
a = fn name ->
      fn
        (^name) -> IO.puts("Hello #{name}")
        _       -> IO.puts("I don't know you")
      end
    end

b = a.("dave")
b.("dave")
b.("ayoush")
```

More ways to write function 

```bash
def func(0), do: 1
def func(n), do: n * func(n-1)
```

the order of these clauses can make a difference when you translate them into code. Elixir tries functions from the top down, executing the first match. 

Default argument interesting case. 
```bash
def func(p1, p2 \\ 2, p3 \\ 3, p4) do
    IO.inspect [p1, p2, p3, p4]
end

Example.func("a", "b")
Example.func("a", "b", "c") 
Example.func("a", "b", "c", "d")
# => ["a",2,3,"b"]
# => ["a","b",3,"c"]
# => ["a","b","c","d"]
```

So you can see in this example p4 is being assigned everytime and this elixir does automatically based on the number of parameters it will adjust.



The & Notation
There is one optimisation that i need to talk about and that is direct referencing if the order is correct for example :-
```bash
iex> add_one = &(&1 + 1) # same as add_one = fn (n) -> n + 1 end
#Function<6.17052888 in :erl_eval.expr/5>
```
converted to anonymous function

but if we write like this :-
```bash
iex> speak = &(IO.puts(&1))
&IO.puts/1
```
So here you can see the direct reference to IO.puts has been assigned 

### The import Directive
The import directive brings a module’s functions and/or macros into the current scope. If you use a particular module a lot in your code, import can cut down the clutter in your source files by eliminating the need to repeat the module name time and again.
For example, if you import the flatten function from the List module, you’d be able to call it in your code without having to specify the module name.
```bash
defmodule Example do def func1 do
     List.flatten [1,[2,3],4]
end
def func2 do
import List, only: [flatten: 1]
    flatten [5,[6,7],8]
end end
```

Pattern Matching Can’t Bind Keys. You can’t bind a value to a key during pattern matching. You can write this:

```bash
iex> %{ 2 => state } = %{ 1 => :ok, 2 => :error } %{1 => :ok, 2 => :error}
iex> state
:error
but not this:
iex> %{ item => :ok } = %{ 1 => :ok, 2 => :error }
** (CompileError) iex:5: illegal use of variable item in map key...
```


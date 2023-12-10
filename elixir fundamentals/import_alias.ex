defmodule ImportAlias do
  def testing_import() do
    IO.puts("Hello from imports")
  end
  def testing_alias() do
    IO.puts("Hello from alias")
  end
end


defmodule ImportingAliasing do
  import ImportAlias
  alias ImportAlias, as: MyAlias
  alias ImportAlias

  def testing() do
    testing_import()
    nil
  end

  def testing_alias() do
    MyAlias.testing_alias()
    ImportAlias.testing_alias()
  end
end

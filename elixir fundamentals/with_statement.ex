defmodule WithStatement do
  def general_statement do
    result = with {:ok, file} <- File.open("sample1.json"),
                content <- IO.read(file, :all) do
                  content
              end
  end
end

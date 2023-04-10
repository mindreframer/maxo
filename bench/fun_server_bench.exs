{:ok, genserver} = Maxo.Files.FileWriter.start_link()
{:ok, funserver} = Maxo.Files.FileWriterFun.start_link()

Benchee.run(
  %{
    "genserver" => fn ->
      Maxo.Files.FileWriter.put(genserver, "hello")
     end,
    "funserver" => fn ->
      Maxo.Files.FileWriterFun.put(funserver, "hello")
    end
  },
  time: 10,
  memory_time: 2
)

defmodule Animal do
  def start_link(name, module) do
    spawn_link(fn -> loop(name, module) end)
  end

  defp loop(name, module) do
    receive do
      {:get_name, sender} ->
        send(sender, {:name, name})
        loop(name, module)

      {:speak, sender} ->
        module.speak(name, sender)
        loop(name, module)
    end
  end
end

defmodule Dog do
  def speak(name, sender) do
    IO.puts("#{name} says: Woof!")
    send(sender, :ok)
  end
end

defmodule Cat do
  def speak(name, sender) do
    IO.puts("#{name} says: Meow!")
    send(sender, :ok)
  end
end

defmodule Main do
  def run do
    dog = Animal.start_link("Wally", Dog)
    cat = Animal.start_link("Pierre", Cat)

    send(dog, {:speak, self()})
    send(cat, {:speak, self()})

    receive do :ok -> :ok end
    receive do :ok -> :ok end
  end
end

Main.run()

defmodule Animal do
  def start_link(animal_name, module) do
    spawn_link(fn -> loop(animal_name, module) end)
  end

  defp loop(animal_name, module) do
    receive do
      {:get_name, sender} ->
        send(sender, {:animal_name, animal_name})
        loop(animal_name, module)

      {:speak, sender} ->
        module.speak(animal_name, sender)
        loop(animal_name, module)
    end
  end
end

defmodule Dog do
  def speak(animal_name, sender) do
    IO.puts("#{animal_name} says: Woof!")
    send(sender, :ok)
  end
end

defmodule Cat do
  def speak(animal_name, sender) do
    IO.puts("#{animal_name} says: Meow!")
    send(sender, :ok)
  end
end

defmodule Main do
  def run do
    dog = Animal.start_link("Rex", Dog)
    cat = Animal.start_link("Whiskers", Cat)

    send(dog, {:speak, self()})
    send(cat, {:speak, self()})

    receive do :ok -> :ok end
    receive do :ok -> :ok end
  end
end

Main.run()

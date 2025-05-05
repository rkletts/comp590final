# Elixir Animal OOP Simulation

### What features in Elixir are used to implement objects and OO pillars?

In this Elixir version, I used processes to act like objects. Each animal runs in its own process, and the state (like the animal’s name) stays hidden inside. It can’t be accessed directly, only by sending a message like {:get_name, sender}. That’s kind of like encapsulation.

Abstraction
The Animal module takes care of the lower level process and messaging stuff, so the rest of the program doesn’t have to worry about it. You just tell it to :speak or get its name, without knowing how it's actually doing it.

Inheritance
Since Elixir doesn’t use classes or traditional inheritance, I got around that by passing in a module (like Dog or Cat) to handle specific behavior. It’s like customizing the base Animal process with different personalities.

Polymorphism
Each behavior module has its own version of speak/2, so when the animal process gets a :speak message, it uses the version from whatever module it was given. That lets us reuse the same Animal code but have different animals behave differently.

### What parts of your Elixir code map to the Java example?

The Animal module in Elixir works like the abstract Animal class in Java. It holds the common logic that all animals use (like how to receive messages and store the name). Since Elixir doesn’t have classes, I made Animal a process that loops and listens for messages,like how each object in Java has its own state and behavior.

In Java, Dog and Cat extend Animal. In Elixir, Dog and Cat are separate modules that get passed into Animal.start_link. That lets us reuse the same Animal loop, but change how each animal responds when it gets the :speak message. This is my way of using inheritance, by using module delegation instead of class inheritance.

The speak functions in Dog and Cat act like method overrides in Java. When the Animal process receives a :speak message, it calls the correct speak/2 function based on the module it was given. That’s how I implemented polymorphism, because different modules respond differently at runtime.

## How to Run
elixir animal.exs

In Java, getName() is a method to access a private field. In Elixir, the name is also private. It’s stored in the loop and can only be retrieved with a {:get_name, sender} message. This is how I simulated encapsulation, by keeping state inside the process and only exposing access through message passing.

The Main module in Elixir is like the main method in the Java class. It creates the animal “objects” (which are really processes), sends them :speak messages, and waits to get a response back.

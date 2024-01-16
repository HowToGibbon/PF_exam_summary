#let is_cheat_sheet = true;
#set page(columns: 5, flipped: true, margin: 10pt) if is_cheat_sheet
#set columns(2, gutter: 2pt)

#set text(size: 12pt, font: "Arial")
#set text(size: 5pt, font: "Arial") if is_cheat_sheet

#set quote(block: true)

#show heading: it => {
  if (it.level == 1 and is_cheat_sheet) {
    block(
      fill: navy, 
      above: 2pt,
      below: 2pt,
      width: 100%,
      height: 7pt, 
      inset: 1pt)[
      #text(fill: white, size: 6pt)[#it]
    ]
  }
  else if (it.level == 2) {
     block(
      fill: color.rgb("#c6edf6"), 
      above: 2pt,
      below: 2pt,
      width: 100%,
      height: 7pt, 
      inset: 1pt)[
      #text(fill: navy, size: 6pt)[#it]
    ]
  }
  else if (it.level == 3) {
      block(
      above: 2pt,
      below: 2pt,
      width: 100%,
      height: 6pt, 
      inset: 1pt, 
      stroke: (bottom: 0.5pt + blue))[
      #text(fill: blue, size: 6pt)[#it]
    ]
  }
  else {
    it
  }
}

#show raw: it => {
  let backgroundColor = luma(0xF0)
  if (it.block) {
    block(
      fill: backgroundColor,
      inset: 5pt,
      radius: 3pt,
      it,
    )
  } else {
    box(
      fill: backgroundColor,
      outset: 2pt,
      radius: 2pt, 
      it,
    )
  }
}

#let pattern(intent, problem, solution, implementation: [], relations: [], example: []) = [
  #if intent != [] {
    [*Intent:* #intent]
  }
  #if problem != [] {
    [\ *Problem:* #problem ]
  }
  #if solution != []{
    [\ *Solution:* #solution]
  }
  #if implementation != [] {
    [\ *Implementation:* #implementation]
  }
  #if example != [] {
    [\ *Example:* #example]
  }
  #if relations != [] {
    [\ *Relations:* #relations]
  }
]

#let benefit(term, color: color.rgb("#0da53a")) = {
  text(color, box[👍 #term])
}

#let liability(term, color: color.rgb("#be0f12")) = {
  text(color, box[👎 #term])
}

#let combine_with(term, color: orange) = {
   box(
      fill: color,
      inset: 1pt,
      baseline: 1.2pt,
      radius: 1pt,
      [🔗 #term]
    )
}

#let colorbox(title: "title", color: none, radius: 2pt, width: auto, body) = {

  let strokeColor = luma(70)
  let backgroundColor = white

  if color == "red" {
    strokeColor = rgb(237, 32, 84)
    backgroundColor = rgb(253, 228, 224)
  } else if color == "green" {
    strokeColor = rgb(102, 174, 62)
    backgroundColor = rgb(235, 244, 222)
  } else if color == "blue" {
    strokeColor = rgb(29, 144, 208)
    backgroundColor = rgb(232, 246, 253)
  } else if color == "yellow" {    
    strokeColor = rgb(255, 170, 29)
    backgroundColor = rgb(255, 255, 0)
  }

  return box(
    fill: backgroundColor,
    stroke: 1pt + strokeColor,
    radius: radius,
    width: width
  )[
    #block(
      fill: strokeColor, 
      inset: 4pt,
      radius: (top-left: radius, bottom-right: radius),
    )[
      #text(fill: white, weight: "bold")[#title]
    ]
    #block(
      width: 100%,
      inset: (x: 3pt, bottom: 3pt, top: -4pt)
    )[
      #body
    ]
  ]
}


#let togglebox(body) = {
  if is_cheat_sheet == false {
    colorbox(
      title: "Toggle",
      color: "yellow",
      body
    )
  }
}

#togglebox[
  = GoF (Gang of Four) Patterns

  Most commonly used GoF Patterns.
  #table(
    columns: (auto, auto, auto),
    inset: 5pt,
    [Creational],
    [Structural],
    [Behavioral],
    [
      - Abstract Factory
      - Prototype
      - Singleton
      - Factory Method
    ],
    [
      - Adapter
      - Composite
      - Decorator
      - Flyweight
      - Facade
      - Proxy
    ],
    [
      - Command
      - Iterator
      - Mediator
      - Memento
      - Observer
      - State
      - Strategy
      - Visitor
    ]
  )
]
= Pattern Overview

#togglebox[
  #image("images/themenübersicht.png")
]
#image("images/guru_patterns.png")

= Creational
== Abstract Factory
#image("images/solution_abstract_factory.jpg")
Provide an interface for creating families of related or dependent objects without specifying their concrete classes.

== Prototype
#image("images/solution_prototype.png")
Specify the kinds of objects to create using a prototypical instance, and reate new objects by copying this prototype.

#liability[Does not describe how the manager is implemented]

== Factory Method
#image("images/solution_factory_method.png")
#pattern(
  [Abstract creation, Improve Testability],
  [Creation interface on super, implementation in child],
  [Factory method to defer insanitation to subclass (allows superclass to alter type of objects that will be created)],
  implementation: [Testing: override with Mock creation],
  relations: [Setting Context by (Template Method), #combine_with[Abstract Factory ]]
)

#colbreak()

== Singleton
#pattern(
  [Guaranteeing that only one global object of class exists],
  [Some classes should have only one instance],
  [Private construction and static class factory method],
  implementation: [`static Instance()` can use Lazy initialization],
  relations: [Setting context by (Class Factory Method)]
)

#benefit[Sole instance, variable number of instances, flexibility]
#liability[Global variable, tight coupling, prevents polymorphism]

#togglebox[
  === Example
  ```java
  public class Singleton {
    private static class InstanceHolder {
      // Singleton will be instantiated as soon as the
      // ClassLoader instantiates the overlying class
      private static final Singleton INSTANCE = new Singleton();
    }

    public static Singleton getInstance() {
      return InstanceHolder.INSTANCE;
    }

    protected Singleton() { } // allow subclassing
  }
  ```
]

== Registry (Singleton Mitigation)
#pattern(
  [Guaranteeing that only one global object of class exists],
  [Some classes should have only one instance],
  [Classes register their "Singleton" in a well-known *registry*],
  implementation: [Interface for contained "Singletons" for testability]
)

#benefit[More flexible than Singleton, Benefits of Singleton]
#liability[No object creation responsibility, Liabilities of Singleton]

== Monostate (Singleton Mitigation)
#pattern(
  [Multiple instances in same state and behavior],
  [Multiple instances should have the same behavior],
  [Monostate object: all member variables as static members],
  implementation: [Create monostate object and implement all member variables static],
  relations: [Specialization of (Singleton)]
)

#benefit[Transparency, Drivability, Polymorphism, Testability]
#liability[Breaks inheritance hierarchy, no sharing,unexpected behavior]

== Service Locator (Singleton Mitigation)
#image("images/solution_service_locator.png")

#pattern(
  [Manage dependencies and maintain loose coupling],
  [Global service instance should be exchangeable],
  [Locator locates services via Service Finders],
  implementation: [],
  relations: [Setting context by (Singleton)]
)

#benefit[Only one Singleton, Abstract interface of ServiceLocator]
#liability[ServiceLocator still Singleton, cant replace ServiceLocator]

= Structural
== Adapter
#image("images/solution_adapter.png", width: 90%)
Convert the interface of a class into another interface expect.
Adapter lets classes work together that couldn't otherwise because of incompatible interfaces.

== Composite
#image("images/solution_composite.png")
Composes objects into tree structures and let you work with these structures as if they were individual objects.
#combine_with[Visitor]

#colbreak()
== Decorator
#image("images/solution_decorator.png", width: 70%)

Attach additional responsibilities to an object dynamically.
Decorators provide a flexible alternative subclassing for extending functionality.

== Flyweight
#image("images/solution_flyweight.png", width: 80%)

#pattern(
  [Avoid multiple copies of identical (constant/referenced) objects],
  [Storage costs are high because the sheer quantity of objects],
  [Use sharing to support large number of fine-grained objects],
  implementation: [Manager maintains Flyweight, Flyweights immutable],
  relations: [Setting Context by (Pooling), #combine_with[Composite]]
)

#benefit[Reduction of total Instances (Total number, state per object)]
#liability[Can’t rely on object identity,Finding Flyweight maybe costly]

== Facade
#image("images/solution_facade.jpg", width: 80%)

Provides a simplified interface to a library, a framework, or any other complex set of classes.

== Pooling (Boxing)
#pattern(
  [Fast, predictable access to resource with minimal complexity],
  [Slow and unpredictable access to resources],
  [Manage multiple instances of one type in a pool, allows reuse],
  implementation: [Define max number of resources, Use lazy or eager],
  relations: [Setting Context for (Flyweight), #combine_with[acts as Mediator]]
)

#benefit[Performance,Lookup predictable,Simple,Dynamic allocation]
#liability[Management overhead, Synchronization to avoid races]

== Proxy
#image("images/solution_proxy.png", width: 80%)

Provide a surrogate/placeholder for another object to control access to it.

#colbreak()

= Behavioral
== Mediator
#image("images/solution_mediator_static_structure2.png", width: 80%)

#pattern(
[Promotion of loose coupling, stops explicit referral],
[Strong coupling and complex communication],
[Introduce mediator to abstract interaction of objects],
implementation: [Mediator as Observer, Colleages as subject],
relations: [Refinement(#combine_with[Observer])]
)

#togglebox[
  #quote(attribution: [GoF])[Define an object that encapsulates how a set of objects interact. Mediator promotes loose coupling by keeping objects from referring to each other explicitly, and it lets you vary their interaction independently.]
]

#togglebox[
=== Problem
- Object structures may result in many connections between objects
- Worst case, every object ends up knowing about every other

=== Participants
- *Mediator* (Observable) Encapsulates how a set of objects interact
- *Collegue(s)* (Observers) Refer to Mediator; this promotes loose coupling

=== Solution

Static Structure
#image("images/solution_mediator_static_structure.png", width: 70%)

#togglebox[
  Dynamics
  #image("images/solution_mediator_dynamics.png", width: 90%)
]

=== Summary
]

#benefit[Colleague classes may become more reusable, low coupling]
#benefit[Centralizes control of communication between objects]
#benefit[Encapsulates protocols]

#liability[Adds complexity]
#liability[Single point of failure]

== Memento (Vermittler)
#image("images/solution_memento_static_structure.png", width: 90%)

#togglebox[
  #quote(attribution: [GoF])[Without violating encapsulation, capture and externalize an object's internal state so that the object can be restored to this state later.]
]

#pattern(
  [It separates the serialization logic from the business logic.],
  [Objects encapsulate their state, making it inaccessible, record internal state],
  [Capture objects internal state in memento],
  implementation: [originator creates memento with internals]
)

=== Participants
*Memento* 
- Stores some or all internal state of the Originator
- Allows only the Originator to access its internal information
*Originator*
- Creates Memento objects to store its internal state at strategic points.
- Restores its own state to what the Memento object dictates
*Caretaker* (Filesystem, Database)
- Stores the Memento object of the Originator.
- Cannot explore the contents of or operate on the Memento object.

#togglebox[
  #image("images/solution_memento_static_structure.png", width: 90%)

  Dynamics
  #image("images/solution_memento_dynamics.png", width: 70%)
]

#togglebox[=== Summary]
#benefit[Internal state of an object can be saved and restored at any time]
#benefit[Encapsulation of attributes is not harmed]
#benefit[State of objects can be restored later]

#liability[Creates a complete copy of the object every time, no diffs]
#liability[No direct access to saved state, it must be restored first]

#togglebox[
  #colorbox(title: "Discussion")[
    _How would it look without Memento?_
    ```java
    class Originator { 
      private String name; 
      private String address; 
      private int age; 
      // ...
    }
    ```

    *Answer:*
    Fields would be public so the `Caretaker` can directly access them.
    ```java
    class Originator { 
      public String name; 
      public String address; 
      public int age; 
      // ...
    }
    ```

    _What more modern alternatives do you know?_Define

    *Answer:* 
    - Serialization (Java / C\#)
    - Similar to Future Pattern

    _Usages of Memento?_

    *Answer:*
    - Save Files
  ]
]

== Command
#image("images/solution_command_static_structure.png", width: 80%)

*Encapsulates commands*, so that they can be parameterized *scheduled*, *logged* and/or *undone*.
=> pattern does not describe history/undo management

#togglebox[
  #quote(attribution: [GoF])[
  Encapsulate a request as an object, thereby letting you parameterize clients with different requests, queue or log requests, and support undoable operations.]
]

#pattern(
  [Encapsulation of commands so they can be scheduled/logged],
  [Executed Methods not identifiable in most languages],
  [Encapsulate request as object, used for parameterization],
  relations: [Setting Context for (Command Processor, Internal Iterator), Setting Context by (Strategy)]
)

#togglebox[
=== Problem
- Decouple the decision of what to execute from the decision of when to execute
- The execution needs an additional parameterization context

=== Solution
Static Structure
#image("images/solution_command_static_structure.png", width: 90%)

Dynamics
#image("images/solution_command_dynamics.png", width: 70%)
]

#togglebox[=== Summary]
#benefit[The same command can be activated from different objects]
#benefit[New commands can be introduced quickly and easily]
#benefit[Command objects can be saved in a command history]
#benefit[Provides inversion of control, encourages decoupling in both time and space]

#liability[Large designs with many commands can introduce many small command classes mauling the design]

== Command Processor
#pattern(
  [Manage command objects so execution can be undone],
  [History and undoing of method execution impossible],
  [Command Processor manages requests as objects],
  implementation: [Command Processor contains Command History],
  relations: [Setting Context by (Command, Memento)]
)

#image("images/solution_command_processor_static_structure.png", width: 90%)
#image("images/solution_command_processor_dynamics.png", width: 70%)

#togglebox[
*Manage command objects*, so the execution is separated from the request and the execution can be undone later.

  #quote(attribution: [POSA1])[
  Separate the request for a service from its execution. A command processor component manages requests as separate objects, schedules their execution, and provides additional services such as the storing of request objects for later undo.
  ]

=== Problem
- Common UI applications support do and undo multiple undo steps
- Steps forward and backward are accessible in a history

=== Participants
- *Command Processor* a separate processor object can handle the responsibility for multiple command objects (should not clutter command hierarchy nor client code)
- *Command* uniform interface to execute functions
- *Controller* translates requests into commands and transfers commands to Command Processor

=== Solution
Static Structure
#image("images/solution_command_processor_static_structure.png", width: 90%)

Dynamics
#image("images/solution_command_processor_dynamics.png", width: 70%)

=== Implementation
- Command Processor contains a `Stack<Command>` which holds the Command history
- Controller creates the Commands and passes them to Command Processor

=== Summary
]

#benefit[Flexibility, Command Processor and Controller are implemented independently of Commands]
#benefit[Central Command Processor allows addition of services related to Command execution]
#benefit[Enhances testability, Command Processor can be used to execute regression tests]

#liability[Efficiency loss due additional indirection]

#togglebox[
  #colorbox(title: "Discussion")[
    _Represents the Command Processor an own Pattern? (or just an implementation detail?)_

    *Answer:*
    Is not only a simple variation of the Command pattern and is therefore its own pattern.
  ]
]

== Observer
#image("images/solution_observer.png")
Lets you define a subscription mechanism to notify multiple objects about any events that happen to the object they're observing. 

== Visitor
#image("images/solution_visitor_static_structure.jpg", width: 80%)

#pattern(
  [Separate algorithms from the objects on which they operate],
  [Different algorithms needed to process composite tree],
  [New behavior in separate class instead integrating in original],
  implementation: [Visitor interface with “visiting” methods e.g. accept()],
  relations: [#combine_with[Composite, (Iterator), Chain of Responsibility, Interpreter]]
)

=== Criticism
Visitor can be overused
- Put important stuff into node classes, see Interpreter
Visitor bad when visited class hierarchy changes
- Hard to change or adapt existing visitors
Keeping state during visitation
- State is shared within the visitor object
- But hard when different visitors need to collaborate

#togglebox[
Changing/replacing the behavior on individual elements of a data structure *without changing the elements*.

  #quote(attribution: [GoF])[
    Represent an operation to be performed on the elements of an object structure. Visitor lets you define a new operation without changing the classes of the elements on which it operates.
  ]


=== Problem
- Operations on specific classes needs to be changed/added without needing to modify these classes
- Different algorithms needed to process an object tree

=== Solution
Static Structure
#image("images/solution_visitor_static_structure.jpg", width: 80%)
]

#togglebox[=== Summary]
#benefit[Visitor makes adding new operations easy]
#benefit[Separates related operations from unrelated ones]

#liability[Adding new node classes is hard]
#liability[Visiting sequence fix defined within nodes]
#liability[Visitor breaks logic apart]

#togglebox[
  #colorbox(title: "Discussion")[
  _What other patterns combine naturally with Visitor?_

  *Answer:*

  - Composite
  - Interpreter
  - Chain of Responsibility
  ]
]

#colbreak()

== Iterator Patterns
#pattern(
  [Avoid strong coupling between collection and iteration],
  [Iteration of collection depends on target implementation],
  []
)

=== External Iterator
#pattern(
  [],
  [Knowledge for iteration is separate object from target],
  [Four operations: create, hasNext, (access, next)],
  relations: [Setting Context by (Plain Method Factory)]
)
#image("images/solution_external_iterator_static_structure.png", width: 90%)

#togglebox[
Avoid strong coupling between iteration and collection, generalized and provided in a collection-optimized manner.

  #quote(attribution: [GoF])[
    Provide a way to access the elements of an aggregate object sequentially without exposing its underlying representation.
  ]


==== Problem
- Iteration through a collection dependents on the target implementation
- Separate logic of iteration into an object to allow multiple iteration strategies

==== Solution 1
- The knowledge for iteration is encapsulated in separate object from the target
- Rendered idiomatically in different languages, e.g.
  - Java/C\# For-Each statement
  - EcmaScript For-In / For-Of Statements

==== Solution 2
Static Structure

```java
Iterator it = new ArrayList().iterator(); // Initializing iteration
while(it.hasNext()) { // Checking a completion condition
  // next() => move to next // Access a current target value
  // & return that element // Moving to the next target value
  String obj = (String)it.next();
}
```
]

#togglebox[==== Summary]
#benefit[Provides a single interface to loop through any kind of collection]

#liability[Multiple iterators may loop through a collection at the same time]
#liability[Life-cycle management of iterator objects]
#liability[Close coupling between Iterator and corresponding Collection class]
#liability[Indexing _might_ be more intuitive for programmers]

=== Internal Iterator
#pattern(
  [],
  [],
  [Responsibility for iteration on collection, uses Command],
  implementation: [Implemented by most Programming langs(`.forEach`)],
  relations: [Setting Context by (Command, Strategy)]
)

#image("images/solution_internal_iterator_static_structure.png")
#togglebox[
Iterate collection considering the collection state with reduced state management.

#quote(attribution: "Henney")[
  Support encapsulated iteration over a collection by placing responsibility for iteration in a method on the collection. The method takes a Command object that is applied to the elements of the collection.
]

==== Problem
- Iteration management is performed by the collection's user
- Avoid state management between collection and iteration

#togglebox[
==== Solution 1

Static Structure
]

==== Solution 2
- Programming languages already implement Enumeration Method as their loop construct
- Rendered idiomatically in different languages, e.g.
  - `Collection.forEach()` / Stream.forEach() method in Java
  - `List<T>.ForEach(Action<T>)` in C\#
  - `Array.prototype.forEach()` in JavaScript (ES5)
]

#togglebox[==== Summary]
#benefit[Client is not responsible for loop housekeeping details]
#benefit[Synchronization can be provided at the level of the whole traversal rather than for each element access]

#liability[Functional approach, more complex syntax needed]
#liability[Often considered too abstract for programmers]
#liability[Leverages Command objects]

#togglebox[
  #colorbox(title: "Discussion")[
    _Which kind of iterator has been applied?_
    ```java
    [ 1, 2, 3 ].forEach( 
      (n) => { console.log(`Item: ${n}\n`); }
    );
    ```
    *Answer:* Internal Iterator

    _Are internal and external iterators just variants of the Iterator pattern by GoF? Explain:_

    *Answer:* Separate Patterns
  ]
]

=== Batch Method
#pattern(
  [],
  [Collection and iterating client not on same machine],
  [Group multiple collection accesses together],
  implementation: [Data structure for calls, Access groups of elements],
  relations: [Variation of (Remote Proxy)],
  example: [String Builder, SQL Cursors]
)

#benefit[Less communication overhead]
#liability[Increased complexity]

#togglebox[
Iterate a collection over multiple tiers without spending more time in communication then in computation.

#quote(attribution: "Henney")[
  Group multiple collection accesses together to reduce the cost of multiple individual accesses in a distributed environment.
]

==== Problem
- Collection and client (iterator user) are not on the same machine
- Operation invocations are no longer trivial

==== Solution
- Define a data structure which groups interface calls on client side
  - More appropriate granularity that reduces communication and synchronization costs
- Provide an interface on servant to access groups of elements at once

  #colorbox(title: "Discussion")[
    _Where have you already encountered the Enumeration Method pattern?_
    *Answer:* 

    - `.forEach` Method
    - `for` loops

    _Where have you already encountered the Batch Method pattern?_

    *Answer:*

    - Simplest case: String(Builder), `.toString()` Method
    - SQL Cursors or result sets instead of many queries for individual objects
    - ADO.NET
  ]
]

== Strategy
#image("images/solution_strategy.jpg")

Define the skeleton of an algorithm in an operation, deferring some steps to subclasses. Template Method lets subclasses redefine certain steps of an algorithm without changing the algorithms.

== Template Method
#image("images/solution_template_method.png", width: 70%)

Define the skeleton of an algorithm in a operation, deferring some steps to subclasses. Template Method lets subclasses redefine certain steps of an algorithm without changing the algorithm structure.
e.g.: Document templates

#colbreak()

== State Patterns
*Intent:* Change Behavior based on state
*Problem:* An entity behaves differently depending on its state

=== State (Objects for State)
#image("images/solution_state_static_structure.png", width: 80%)
- Results in a lot of classes and structures

Object acts according to its state without multipart conditional statements.

#togglebox[
  #quote(attribution: [GoF])[
    Allow an object to alter its behavior when its internal state changes. The object will appear to change its class.
  ]
]

#pattern(
  [],
  [One class per state with behavior, switch state on context],
  [Helper function to change state on context]
)

#togglebox[
==== Problem
- Object's behavior depends on its state, and it must change its behavior at run-time
- Operations have large, multipart conditional statements (flags) that depend on the object's state

==== Solution
One class per state with behavior, switch state on context.

Static Structure
#image("images/solution_state_static_structure.png")
]

#togglebox[==== Summary]
#benefit[Avoid bulky conditional, Single Responsibility, Open/Closed]
#liability[Overkill if only few states, Behavior not in one place]

=== Methods for State
- Propagates a single class with a lot of methods

#togglebox[
==== Solution
- Each state represents a table or record of method references
- The methods referenced lie on the State Machine (context) object
]

#togglebox[==== Summary]
#benefit[Allows a class to express all of its different behaviors in ordinary methods on itself]
#benefit[Behavior is coupled to the state machine, rather than fragmented across multiple small classes]
#benefit[Each distinct behavior is assigned its own method]
#benefit[No object context needs to be passed around, methods can already access the internal state of the state machine]

#liability[Requires an additional two levels of indirection to resolve a method call]
#liability[The state machine may end up far longer than was intended or is manageable]

=== Collections for State
- Allows to manage multiple state machines with the same logic
- Splits logic and transaction management into two classes
#combine_with[Objects for State, Methods for State]

#togglebox[
==== Solution
Separate objects into collections according the object state

Dynamics
#image("images/solution_collection_of_state_dynamics.png")
]

#togglebox[==== Summary]
#benefit[No need to create a class per state]
#benefit[Optimized for multiple objects (state machines) in a particular state]
#benefit[Object's collection implicitly determines its state (No need to represent the state internally)]

#liability[Can lead to a more complex state manager]

= Value Patterns
== System Analysis (OOA = Object Oriented Analysis)
An individual is something that can be named and reliably distinguished from other individuals.


#image("images/individuals.png")

Kind of individuals:
- *Event* an individual happening, taking place at some particular point in time.
- *Entity* an individual that persists over time and can change its properties and states from one point in time to another. Some entities may initiate events; some may cause spontaneous changes to their own states; some may be passive
- *Value* an intangible individual that exists outside time and space, and is not subject to change.

#togglebox[
  #colorbox(title: [Discussion])[
    _Give examples for the following (Event, Entity, Value) categories of things:_

    *Answer:*
    - *Event:* e.g. User Action
    - *Entity:* e.g. Person
    - *Value:* e.g. Body Height
  ]
]

== Domain Driven Design
#image("images/ddd.png")

#colbreak()

== Software Design (OOD)
- *Identity:* significant, or transparent (=transient identity)
- *State:* object stateful or stateless
- *Behavior:* object has significant behavior independent of its state

#image("images/object_aspects.png")

Categories of objects:
- *Entity:* Express system information (persistent). Distinguished by identity. 
- *Service:* Represents system activities. Distinguished by behavior.
- *Value:* Content dominant characteristic. No significant enduring identity (transparent).
- *Task:* Represent system activities. Distinguished by identity and state (e.g. command objects, threads)

#togglebox[
  #colorbox(title: [Discussion])[
    _Give examples for the following (Entity, Service, Value) categories of things:_

    *Answer:*
    - *Entity:* Classes e.g. `User.cs`
    - *Service:* e.g. `UserService` (stateless, no identity)
    - *Value:* Fields e.g. `int age;` 
  ]
]

== Patterns of Value
Patterns of Value addressing value objects in “pure” OO languages.
#image("images/patternsOfValue.png")

== Whole Value
#pattern(
  [Express the type of the quantity as a Value Class],
  [Primitive quantities have no domain meaning],
  [Recover meaning loss by providing dimension and range],
  implementation: [Disallow inheritance to avoid slicingValue Object],
  example: [`public final class Value{public Value(v){check range}}`]
)

#togglebox[
Represent primitive quantities from the problem domain without loss of meaning.

#quote(attribution: [Henney])[
  Express the type of the quantity as a Value Class.
]

=== Problem
- Plain integers and floating-point numbers are not very useful as domain values
- Errors in dimension and intent communication should be addressed at compile time

=== Solution
- Recover loss of meaning and checking by providing a *dimension* and *range*
- Wraps simple types or attribute sets
- Disallows inheritance to avoid _slicing_
]

== Value Object (Value Class)
#pattern(
  [Make Comparison based on the value],
  [Values by default get compared by the “identity”],
  [Override methods in object that should rely on content],
  implementation: [Override equality methods e.g. `equals`, `hashCode`, implement Serializable]
)

#togglebox[
Define class to represent values in the system.

#quote(attribution: [Henney])[
  Override the methods in Object whose action should be related to content and not identity and implement serializable.
]

=== Problem
- Comparison, indexing and ordering should not rely on objects identity but its content

=== Solution
- Override Object's methods who define equality (e.g. `equals`, `hasCode`)
- Override `toString()` can help using Value Object
]

== Conversion Method
#pattern(
  [Convert from one (ctr:more generic) Value Object to another],
  [Related value objects should be converted to each other],
  [Constructor for Conversion, Conversion instance method (`toOtherType()`) or Class Factory Method (`fromOtherType()`)]
)

#togglebox[
Use different, related Value Objects together without depending on underlying primitive type.

  #quote()[
    Provide type conversion methods responsible for converting Value Objects into related formats.
  ]

=== Problem
- Values are strongly informational objects without a role for separate identity
- Often Value Objects are somehow related but cannot be used directly without conversion

=== Solution
- Provide a *constructor* which converts between types (e.g. `Year(int value)`, `String(char[] value)`)
  - No additional method call needed
  - Most intuitive when applied to convert from more generic to current type
- A *conversion instance method* converts from a user-defined type to another type (e.g. `Date.toInstant()`)
- Create a Class Factory Method with conversion characteristics (e.g. `Date.from(Instant instant`)
]

== Immutable Value
#pattern(
  [No side-effects when sharing or aliasing Value Objects],
  [Sharing of instances not corresponding to value definition],
  [Set internals at construction and allow for no modification],
  implementation: [declare all field private final, Mark class as final],
  example: [`final class D{ private final Y y; }`]
)

#togglebox[
Share Value Objects and guarantee no side effect problems.

#quote(attribution: [Henney])[Set the internal state of the Value Class object at construction and allow no modifications]

=== Problem
- A value exists outside time and space, and is not subject to change
  - Avoid side effect problems when sharing (or aliasing) Value Objects
  - Sharing values across Threads requires thread safety
  - Values are often threaded as key for associative tables

=== Solution
  - Set internal state at construction and declare all fields `private final`
  - Mark class as `final`
  - no synchronization needed, since no race conditions on the object can occur

```java
public final class Date{
  private final Year year;
  private final Month month;
  private final Day day;

  public Date(Year year, Month month, Day day){
    // range chekcs...
    this.year = Year;
    this.month = Month;
    this.Day = day;
  }

  // ...
}
```
]

== Enumeration Values
#pattern(
  [Represent a fixed set of constant values and preserve type safety.],
  [Fixed range of values should be typed (e.g. months)],
  [Whole Value and declare *enum* values as public read only]
)

#togglebox[
Represent a fixed set of constant values and preserve type safety.

#quote()[
  Treat each constant as a Whole Value instance declaring it public.
]

=== Problem
A fixed range of values should be typed (e.g. months)
- Using just int constants doesn't help
- Whole Value only half of the solution; range should be constant

=== Solution
- Implement a Whole Value and declare the Enumeration Values as public read-only fields
- Prevent inadvertently changing the constants

```java
public enum Month {
  JANUARY(1), 
  // … 
  DECEMBER(12); 
  private final int value; 
  private Month(int value) { 
    if (value < 1 || value > 12) { 
      // avoid careless mistakes, check value range throw new IllegalArgumentException(); 
    } 

    this.value = value;
  } 
  
  public int getValue() { 
    return value;
  }
}
```
]

== Copied Value and Cloning
#pattern(
  [Values should be modifiable without changing origins state],
  [Values by Reference modify internal state],
  [Create Copy when sharing so that internal state stays intact],
  implementation: [For deep cloning: non-final fields, reassigned clone. `implements Cloneable`, override `clone()` ],
  relations: [Setting context for (Prototype)]
)

#togglebox[
Pass a modifiable Value Object into and out of methods without permitting callers or called methods to affect the original object.

#quote()[
  Implement Cloneable interface to be used whenever a value object needs to be returned or passed as a parameter.
]

=== Problem
Values should be modifiable without changing the origins internal state.

=== Solution
Create Copy when sharing so that internal state says intact

```java
public final class Date implements Cloneable {
  private Year year;
  // …
  public void nextYear() {
    year = new Year(year.getValue() + 1);
  } 
  
  @Override
  public Date clone() { /* … */ }
}
```
]

== Copy Constructor
#pattern(
  [Copying without a clone method],
  [Within Value Objects what to copy is clear→need no `clone()`],
  [Copy constructor consuming instance of same type],
  implementation: [final class, no inheritance, create copy constructor]
)

#togglebox[
Copy Objects without the need of implementing `clone` method.

#quote()[
  Provide a way to construct an object based on another instance with exactly the same type.
]

=== Problem
Within Value Objects we often know exactly what to copy

=== Solution
- Declare the `class` as final and derive from Object only
- Create a copy constructor, which consumes an instance with same type

```java
public final class Date {
  // …
  public void nextYear() {
    year = new Year(year.getValue() + 1);
  }

  public Date(Date other) {
    // … this.year = new Year(other.year); 
  }
}
```
]

== Class Factory Method
#pattern(
  [Simplification and optimization of construction of Value Objects],
  [Construction of Value object sometimes expensive],
  [Use static methods instead of ordinary constructor],
  example: [`public final class Value {public static Value of (int v)}`],
  relations: [Variation for (Flyweight)],
)

#togglebox[
Simplify and potentially optimize construction of Value Objects in expression without introducing new intrusive expressions.

#quote()[
  Provide static methods to be used instead of ordinary constructors. The methods return either newly created Value Objects or cached Objects.
]

=== Problem
- Construction of Value Objects objects may be expensive
  - But those objects often accommodate the same state
- Different construction logic is required which may result in huge amount of constructors

=== Solution
- Declare static one or more creation method on the `class`
- The static methods could also contain caching mechanisms

```java
Order firstOrder;
// ...
Date date = new Date(Year.of(2020));
firstOrder.setDeliveryDate(date);

public final class Year {
  // …
  public static Year of(int value) {
    // … query cache for given year, otherwise: return new Year(value);
  }

  private Year(int value) {
    // … this.value = value;
  }
}
```
]

== Mutable Companion
#pattern(
  [Simplify complex construction of an immutable Value],
  [Mutation of immutable object costly or impossible],
  [Implement Companion class that supports modifier methods],
  implementation: [Factory method on companion for modifications],
  relations: [Setting Context for(Builder), Variation(Plain Factory Method)]
)

== Relative Values
#pattern(
  [Comparison of value object based on their *state* instead of *identity*],
  [Comparison of value objects per default by identity],
  [Override/Implement Comparison and equality methods],
  implementation: [Provide Bridge method (see value object example)]
)

= CHECKS Patterns
Separate good input from bad, (validation)

== Meaningful quantities
=== Exceptional Behavior
#pattern(
  [Handle exceptional circumstances (missing/incorrect)],
  [Missing or incorrect values impossible to avoid],
  [Distinguished values for exceptional circumstances]
)

=== Meaningless Behavior
#pattern(
  [Handle (missing/incorrect) data without overhead],
  [How Exceptional behavior handled without throwing errors?],
  [Write methods with minimalistic concern for possible failure]
)

= Meta Patterns (Reflection)

#benefit[Adapting software system is easy, Support many changes]
#liability[Non-transparent "black magic" APIs, typesafety, Efficiency]
*Dangers:* Overengineering, "Security" undermined, obscure API, config

== Type Object
#pattern(
  [Keep common behavior and data in only one place],
  [Need to identify instances, behavior depends on their Type],
  [Categorize objects by another object instead of a class],
  implementation: [Delegate calls to type object, change type -> keep id],
  relations: [Setting context by(Strategy), Variation of (State)]
)

#benefit[Extensable categories, avoids explosion, multiple meta levels]
#liability[Mess of classes, lower efficiency, database schema change]

#togglebox[
  *Example (Java):* \
  Base Level
  ```java
  public class Copy {
    protected MediaType type; // typeof this
    protected int copyid; // e.g. inventory no
    // current identity of this copy
    public int getId() {
      return copyid;
    }
    // example of delegation
    public String getTypeId() {
      return type.getId();
    }
    public String getTitle() {
      return type.getTitle();
    }
    //…
  }
  ```

  Metal Level
  ```java
  public class MediaType {
    protected String title;
    protected String typeid;
    public String getId() {
      return typeid;
    }
    public String getTitle() {
      return title;
    }
    //…
  }
  ```
]

== Property List
#pattern(
  [Make Attributes attachable / detachable after compilation],
  [(At/De)tachable attributes shared across the class hierarchy],
  [Provide objects with a property list that contains attributes]
)
#benefit[Extensibility, attribute iteration, attributes across hierarchies]
#liability[Typesafety, unchecked nameing, runtime overhead, access]

#togglebox[
  *Example (Java):* \
  ```java
  public class Graphics {
    private Properties pl;

    // generic access to properties
    public String get(String prop) {
      return pl.getProperty(prop, "");
    }

    public void set(String prop, Object value) {
      pl.setProperty(prop, value);
    }
  }
  ```

  Metal Level
  ```java
  package java.util;
  public class Properties {
    // …
    // Meta Level
      public Set<String> stringPropertyNames() {
    // …
    }

    public String getProperty(
    String prop, String defaultValue) {
      // …
    }

    public Object setProperty(
    String prop, Object value) {
      // …
    }
  }
  ```
]

== Bridge Method
=> Mitigates liabilities of Property List
#pattern(
  [Provide consistent naming and type safety to property list],
  [Inconsistent naming and no type safety on property list],
  [Bridge Methods with fixed name and return type]
)

#togglebox[
  ```java
  public class Graphics {
    private HashMap<String, Object> pl;
    private static final NAME_PROP = "name";

    // optional: Bridge Method for property name
    public String getName() {
      return (String)getProp(NAME_PROP, "name");
    }

    public void setName(String name) {
      return setProp(NAME_PROP, name);
    }

    // protected access to properties
    protected Object get(String prop, String def) {
      return pl.getOrDefault(prop, def);
    }
    
    protected void set(String prop, Object value) {
      pl.put(prop, value);
    }
  }
  ```

  ```java
  package java.util;
  public class HashMap<Key, Value> {
    // …
    // Meta Level
    public Set<Key> keySet() {
      // …
    }

    public Object get(Key key) {
      // …
    }

    public Value put(Key key, Value value) {
      // …
    }
  }
  ```
]

== Anything
#pattern(
  [Data should be structured recursively],
  [(At/De)tachable attributes with structure and recursion],
  [Implement representation for simple/complex values],
  relations: [Specialization of (Composite),Setting Context by (Property List), Setting Context by (Null Object)]
)
#benefit[Streamable format,flexible interchange across boundaries]
#liability[Typesafety, unapparent intent, lookup overhead]

=== When to usee what?
Reflection
- Deep introspection and modification capabilities are needed
- Building frameworks or libraries that require dynamic behavior based on user-defined classes.
- The drawbacks are acceptable.	•	Large number of similar obj. that differ in characteristics, not their behaviors.
Type Object	
- When avoid extensive inheritance hierarchy for different types.
- Types are known at compile time, and properties don't change dynamically so new class is required.
Property List
- Flexibility in object's attributes needed, with ability CRUD properties at runtime.
- Type safety is not a primary concern or mechanisms to handle it effectively exists.
- Dealing with scenarios where objects can be very diverse and unpredictable, and you want to avoid rigid class structures.

= Frameworks
#image("images/app_framework.png", width: 100%)
Object-oriented classes that work together, privides hooks for extension, keeps control flow.
*e.g.* Hibernate, Velocity, .NET Core & EF, React.js, Vue.js, MFC 

== Application Framework
Object-oriented class library, `Main()` lives in the Application Framework, provide hooks to extend and callbacks, provides ready-made classes for use.
*e.g.* Spring, J2EE, ASP.NET, Angular, Office, Apache, httpd, quote

== Micro Frameworks
Represented by many Design Patterns *e.g.* Template Method, Strategy, Command Processor

== Meta Framework
*Framework adaption concerns:* Acquisition cost, Long-term effect, Training and support, future technology plans, Competitor responsible
*Key Ideas:* Difference to other technologies, different usage contexts.

= Frameworkers Dilemma
*Usage:* Framework users implement application code by
*Portability:* Code strongly coupled to overlying Framework
*Testability:* Hard to take single piece/package and write automated unit tests for application classes using Framework
*Evolution:* Framework users implementation might break in next version 
=> Check out *functional* and *non-functional* requirements and *evaluate* Framework with care, *before* get locked-in.

*Ways out of dilemma:* 1. Think very hard up-front, 2. Don't care too much bout framework users, 3. Let framework users participate, 4. Use helping technology

= POSA 1 & 3

#image("images\ResourceManager.png")


#image("images\Coordinator.png")
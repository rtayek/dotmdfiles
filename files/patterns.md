> Purpose: Reference catalog of software design patterns.
> Scope: GoF, architectural, enterprise integration, resilience, xUnit test patterns, code smells, and refactoring techniques.

# Patterns

A reference catalog of software design patterns.

## Object-oriented design patterns

Reference: *Design Patterns* (Gang of Four).

### Creational
| Pattern | When to use |
|---------|-------------|
| Factory Method | decouple creation from use; let subclasses decide the concrete type |
| Abstract Factory | create families of related objects without specifying concrete classes |
| Builder | construct complex objects step-by-step; avoid telescoping constructors |
| Singleton | one instance needed globally: prefer dependency injection instead where possible |
| Prototype | clone existing objects when construction is expensive |

### Structural
| Pattern | When to use |
|---------|-------------|
| Adapter | bridge an incompatible interface to an expected one |
| Bridge | separate abstraction from implementation so both can vary |
| Composite | treat individual objects and compositions uniformly (tree structures) |
| Decorator | add behavior to an object without subclassing |
| Facade | provide a simplified interface to a complex subsystem |
| Flyweight | share fine-grained objects to reduce memory when many instances are identical |
| Proxy | control access to an object (lazy init, security, caching, remote) |

### Behavioral
| Pattern | When to use |
|---------|-------------|
| Chain of Responsibility | pass a request along a chain until something handles it |
| Command | encapsulate a request as an object; supports undo, queuing, logging |
| Interpreter | define a grammar and interpret sentences in a language |
| Iterator | sequential access to elements without exposing the underlying structure |
| Mediator | centralize communication between objects to reduce coupling |
| Memento | capture and restore object state without violating encapsulation |
| Observer | notify dependents when an object changes state |
| State | change object behavior when its internal state changes |
| Strategy | define a family of algorithms; make them interchangeable |
| Template Method | define the skeleton of an algorithm; let subclasses fill in steps |
| Visitor | add operations to an object structure without modifying it |

## Architectural patterns

| Pattern | Summary |
|---------|---------|
| **MVC** (Model-View-Controller) | separate data (model), presentation (view), and input handling (controller) |
| **MVP** (Model-View-Presenter) | view is passive; presenter mediates between view and model |
| **MVVM** (Model-View-ViewModel) | viewmodel exposes observable state; view binds to it |
| **Layered / N-tier** | strict layers (presentation â†’ service â†’ domain â†’ persistence); dependencies flow inward only |
| **Hexagonal / Ports & Adapters** | core domain has no external dependencies; adapters implement ports for I/O |
| **Clean Architecture** | concentric rings: domain â†’ use cases â†’ interface adapters â†’ frameworks; the Dependency Rule: source code dependencies point inward only |
| **Pipeline** | data flows through a sequence of independent processing stages |
| **Event-Driven** | components communicate via events; decouples producers from consumers |
| **Event Sourcing** | store state as an immutable sequence of events; current state derived by replaying them |
| **Repository** | abstract data access behind a collection-like interface |
| **CQRS** | separate read (query) and write (command) models |
| **Saga** | manage distributed transactions as a sequence of local transactions with compensating actions on failure |
| **Outbox** | write events to a local outbox table in the same transaction as domain changes; relay them to the message broker asynchronously |
| **Strangler Fig** | incrementally replace a legacy system by routing traffic to new components until the old system can be removed |

## Enterprise application patterns

Reference: *Patterns of Enterprise Application Architecture* (Fowler).

| Pattern | Summary |
|---------|---------|
| **Domain Model** | object model of the domain with both data and behavior |
| **Transaction Script** | organizes business logic as a single procedure per use case; simple but does not scale to complex domains |
| **Service Layer** | defines the application's boundary; coordinates domain objects and infrastructure |
| **Data Mapper** | transfers data between objects and the database while keeping them independent |
| **Active Record** | object wraps a row in a table; combines data access and domain logic |
| **Unit of Work** | tracks objects changed during a transaction and coordinates writing them out |
| **Identity Map** | ensures each object is loaded only once per request; acts as a cache by identity |
| **Lazy Load** | defer loading related data until it is actually needed |
| **Gateway** | wraps access to an external system or resource behind an object |
| **Registry** | a well-known object that other objects use to find common objects or services |
| **Null Object** | provide a default object with do-nothing behavior to avoid null checks |
| **Special Case** | a subclass that provides special behavior for particular cases (e.g. `MissingCustomer`) |
| **Money** | represent a monetary value as an amount + currency together to avoid precision bugs |
| **Plugin** | link classes at runtime based on configuration rather than compile-time coupling |
| **Separated Interface** | define an interface in a different package from its implementation to break dependencies |
| **Layer Supertype** | a type that acts as the supertype for all types in its layer |

## Enterprise integration patterns

Reference: *Enterprise Integration Patterns* (Hohpe & Woolf).

| Pattern | Summary |
|---------|---------|
| **Message Channel** | connects sender and receiver; sender writes to channel, receiver reads from it |
| **Message** | atomic unit of data passed between components via a channel |
| **Pipes and Filters** | chain processing steps (filters) connected by channels (pipes) |
| **Message Router** | routes a message to a channel based on its content or metadata |
| **Message Translator** | converts a message from one format to another between systems |
| **Publish-Subscribe Channel** | broadcast a message to all interested receivers |
| **Dead Letter Channel** | route messages that cannot be delivered or processed to a holding area |
| **Request-Reply** | send a request and wait for a correlated reply on a separate reply channel |
| **Correlation Identifier** | attach an ID to a request so the reply can be matched back to it |
| **Scatter-Gather** | broadcast a request to multiple recipients and aggregate their replies |
| **Aggregator** | collect and combine related messages into a single message |
| **Splitter** | break a single message containing multiple items into individual messages |

## Stability and resilience patterns

Reference: *Release It!* (Nygard).

| Pattern | Summary |
|---------|---------|
| **Circuit Breaker** | detect repeated failures and stop calling a failing service until it recovers |
| **Bulkhead** | isolate failures by partitioning resources; prevent one slow consumer from exhausting all threads |
| **Timeout** | never wait forever; set a deadline on every external call |
| **Retry** | retry transient failures with back-off; distinguish transient from permanent errors |
| **Steady State** | keep the system in balance; purge log files, rotate data, prevent accumulation of junk |
| **Let It Crash** | allow a failed component to die cleanly and restart from a known good state |
| **Handshaking** | let a server signal readiness to accept work; do not push more than it can handle |

## Test patterns (xUnit)

Reference: *xUnit Test Patterns* (Meszaros).

| Pattern | Summary |
|---------|---------|
| **Four-Phase Test** | Arrange â†’ Act â†’ Assert â†’ Teardown |
| **Test Double** | stand-in for a real dependency; includes stubs, mocks, fakes, spies, dummies |
| **Stub** | returns canned responses; used to control indirect inputs |
| **Mock** | verifies interactions (method calls, arguments, counts) |
| **Fake** | working implementation not suitable for production (e.g. in-memory DB) |
| **Fixture Setup** | shared setup extracted to `@BeforeEach`; keep it minimal |
| **Object Mother** | factory that creates fully-formed test objects with sensible defaults |
| **Test Data Builder** | fluent builder for test objects; set only the fields relevant to the test |
| **Parameterized Test** | run the same test logic over multiple input/output pairs |
| **Expected Exception** | assert that a specific exception is thrown under specific conditions |
| **Behavior Verification** | assert on interactions with collaborators, not just return values |
| **State Verification** | assert on the state of the system after the action |

## Code smells

Reference: *Refactoring* (Fowler).

When you encounter a smell, treat it as a signal that the code wants to be refactored. Smells are not bugs, but they make bugs easier to hide. Eliminate them when you touch the code.

| Smell | Description |
|-------|-------------|
| **Long Method** | method does too much; break it up |
| **Large Class** | class knows or does too much; split it |
| **Feature Envy** | method uses another class's data more than its own; move it |
| **Data Clumps** | groups of data that always appear together should become their own object |
| **Primitive Obsession** | using primitives where a small value object would be clearer |
| **Switch Statements** | repeated conditionals on type; replace with polymorphism |
| **Parallel Inheritance Hierarchies** | adding a subclass in one hierarchy forces one in another; merge them |
| **Lazy Class** | a class that doesn't do enough to justify its existence |
| **Temporary Field** | field only set in some circumstances; clarify or extract |
| **Middle Man** | a class that only delegates; remove or inline it |
| **Shotgun Surgery** | one change requires edits in many classes; consolidate |
| **Divergent Change** | one class changes for many different reasons; split it |
| **Data Class** | class with only fields and getters/setters; give it behavior |
| **Refused Bequest** | subclass ignores inherited methods; reconsider the hierarchy |
| **Comments** | a comment that explains confusing code; refactor the code instead |

## Refactoring techniques

Reference: *Refactoring* (Fowler, 2nd ed.).

### Basic refactoring

| Technique | Summary |
|-----------|---------|
| **Extract Function** | turn a code fragment into a function with a name that explains its purpose |
| **Inline Function** | replace a call to a trivially simple function with the function body |
| **Extract Variable** | introduce a named variable to explain a complex expression |
| **Inline Variable** | replace a variable that is assigned once with the expression it holds |
| **Change Function Declaration** | rename a function, add or remove parameters, change signature |
| **Encapsulate Variable** | wrap a public variable in getter/setter functions to control access |
| **Rename Variable** | give a variable a name that better communicates its purpose |
| **Introduce Parameter Object** | group parameters that always travel together into a single object |
| **Combine Functions into Class** | bundle a cluster of functions that operate on shared data into a class |
| **Combine Functions into Transform** | feed input data into a transform function that returns it with derived fields |
| **Split Phase** | separate code that processes data in two distinct phases into two functions |

### Encapsulation

| Technique | Summary |
|-----------|---------|
| **Encapsulate Record** | wrap a plain data record in a class to control access and add behavior |
| **Encapsulate Collection** | return a read-only view of a collection; provide add/remove methods |
| **Replace Primitive with Object** | replace a primitive value with a small class when it acquires behavior |
| **Replace Temp with Query** | replace a temp variable with a method call so the logic is shareable |
| **Extract Class** | move related fields and methods into a new class |
| **Inline Class** | fold a class that is no longer pulling its weight into another |
| **Hide Delegate** | add methods to a server class so clients don't need to know about a delegate |
| **Remove Middle Man** | make clients call the delegate directly when delegation is the only job |
| **Substitute Algorithm** | replace the body of a function with a cleaner algorithm |

### Moving features

| Technique | Summary |
|-----------|---------|
| **Move Function** | move a function to the class or module that uses it most |
| **Move Field** | move a field to the class that uses it most |
| **Move Statements into Function** | move repeated statements next to the function they always accompany |
| **Move Statements to Callers** | move statements out of a function when behavior needs to vary at call sites |
| **Replace Inline Code with Function Call** | replace inline code with a call to an existing function that does the same thing |
| **Slide Statements** | move related statements together to make the code easier to extract |
| **Split Loop** | split a loop that does two things into two loops, each doing one thing |
| **Replace Loop with Pipeline** | replace a loop with a pipeline operation such as filter or map |

### Organizing data

| Technique | Summary |
|-----------|---------|
| **Split Variable** | give a variable a separate name each time it holds a different value |
| **Rename Field** | rename a field when its name does not communicate its purpose |
| **Replace Derived Variable with Query** | remove a variable that can be computed from other data and compute it on demand |
| **Change Reference to Value** | treat an object as a value (immutable) rather than a shared reference |
| **Change Value to Reference** | use a single shared object instead of multiple copies of the same data |

### Simplifying conditionals

| Technique | Summary |
|-----------|---------|
| **Decompose Conditional** | extract the condition and each branch into well-named functions |
| **Consolidate Conditional Expression** | combine a sequence of checks with the same result into a single check |
| **Replace Nested Conditional with Guard Clauses** | use early returns to handle special cases and flatten nesting |
| **Replace Conditional with Polymorphism** | replace a switch or if/else on type with polymorphic dispatch |
| **Introduce Special Case** | add a special-case object to handle a common degenerate case (e.g. null) |
| **Introduce Assertion** | add an assertion to make an assumption explicit and verifiable |

### Refactoring APIs

| Technique | Summary |
|-----------|---------|
| **Parameterize Function** | replace multiple similar functions with one function and a parameter |
| **Remove Flag Argument** | replace a boolean parameter that selects behavior with two explicit functions |
| **Preserve Whole Object** | pass the object rather than pulling out individual values to pass separately |
| **Replace Parameter with Query** | remove a parameter when the function can derive the value itself |
| **Replace Query with Parameter** | add a parameter when a function should not access a value directly |
| **Remove Setting Method** | delete a setter when a field should only be set at construction time |
| **Return Modified Value** | return the modified value instead of mutating a parameter in place |
| **Replace Error Code with Exception** | throw an exception instead of returning a special error code |
| **Replace Exception with Precheck** | check a precondition before calling a function instead of catching its exception |

### Dealing with inheritance

| Technique | Summary |
|-----------|---------|
| **Pull Up Method** | move a method that is identical in subclasses up to the superclass |
| **Pull Up Field** | move a field used by multiple subclasses up to the superclass |
| **Pull Up Constructor Body** | move common constructor logic up to the superclass constructor |
| **Push Down Method** | move a method used by only one subclass down into that subclass |
| **Push Down Field** | move a field used by only one subclass down into that subclass |
| **Replace Type Code with Subclasses** | create subclasses for each variant instead of using a type code field |
| **Remove Subclass** | replace a subclass that does too little with a field on the superclass |
| **Extract Superclass** | pull shared behavior from two similar classes into a new superclass |
| **Collapse Hierarchy** | merge a superclass and subclass when they are no longer different enough |
| **Replace Subclass with Delegate** | replace inheritance with a delegate object to avoid coupling to a hierarchy |
| **Replace Superclass with Delegate** | replace inheritance with composition when the superclass is not a true generalization |

## Pattern literature

| Book | Authors | Focus |
|------|---------|-------|
| *Design Patterns* | Gang of Four | OO patterns (creational, structural, behavioral) |
| *Patterns of Enterprise Application Architecture* | Fowler | Data access, domain logic, web presentation |
| *Enterprise Integration Patterns* | Hohpe & Woolf | Messaging and integration |
| *Domain-Driven Design* | Evans | Modeling complex domains |
| *Release It!* | Nygard | Stability and resilience in production |
| *xUnit Test Patterns* | Meszaros | Test design and structure |
| *Refactoring* | Fowler | Code smells and refactoring techniques |
| *Pattern-Oriented Software Architecture* (POSA) | Buschmann et al. | Architectural and concurrency patterns |
| *Pattern Languages of Program Design* (PLoPD) | various | Community-contributed pattern languages across domains |
| *Clean Architecture* | Martin | Dependency management and architecture boundaries |

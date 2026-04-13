<a href="https://rubygems.org/gems/raindeer" title="Install gem"><img src="https://badge.fury.io/rb/raindeer.svg" alt="Gem version" height="18"></a> <a href="https://github.com/raindeer-rb/raindeer" title="GitHub"><img src="https://img.shields.io/badge/github-%23121011.svg?style=for-the-badge&logo=github&logoColor=white" alt="GitHub repo" height="18"></a> <a href="https://codeberg.org/raindeer/raindeer" title="Codeberg"><img src="https://img.shields.io/badge/Codeberg-2185D0?style=for-the-badge&logo=Codeberg&logoColor=white" alt="Codeberg repo" height="18"></a>

# Raindeer

Raindeer is a new web framework using the dynamic features and latest async improvements in Ruby + some weird ideas, to build a new breed of web application. Each Raindeer component can be used individually in your exisiting application, or all together as a cohesive framework. **Deer to be different.**

## Components

### LowType

[LowType](https://github.com/low-rb/low_type) introduces the concept of "type expressions", allowing you to add inline types in your code, only when you need them. LowType is an elegant type checking system with the most minimal DSL possible. It looks like if Ruby had native types; `def method(var: String)`.

### LowLoop

[LowLoop](https://github.com/low-rb/low_loop) is an asynchronous event-driven server that ties into `LowEvent` to create and send events from the request layer right through to the application and data layers. Finally you can see and track events through every step of your application.

### LowEvent

[LowEvent](https://github.com/low-rb/low_event) represents events of all kinds; Raindeer uses `RequestEvent`, `RouteEvent`, `RenderEvent` and `ResponseEvent`. Plus you can extend with your own event types. Events can be observed with [Observers](https://github.com/raindeer-rb/observers).

### RainRouter

The RainRouter accepts `RequestEvent`s and directs the request to the appropriate observers. Simply add `observe 'path/:id'` to a `LowNode` and now it will be called every time a request is made to this route.

### LowNode

[LowNodes](https://github.com/low-rb/low_node) are the flexible building blocks of your application. They can respond to a route request, or they can be called by another node. They can render a return value, or they can create an event. They are designed to be specific enough to observe events and return values, but generic enough to be split up to represent a complex application with its own patterns and structure. Nodes can render HTML/JSON directly from the Ruby class (via RBX, similar to JSX) and render other nodes into the output using Raindeer's special Antlers syntax; `<html><{ ChildNode }></html>`.

### LowData

Instead of the model defining relationships and associated queries to the database, LowData follows the repository pattern with a twist; [Expressions](https://github.com/raindeer-rb/expressions). An expression like `data(Table[:username] > Table[:title | :body)]` builds a SQL query to RIGHT JOIN the user table into the articles table and results in a list of articles with the user's username in each row.

## Raindeer

Raindeer pulls it all together with a router, pipelines and JS integrations. It's decoupled and event-driven via observers in a way that's deceptively simple whilst catering to the needs of complex applications with scalable architectures.

## Architecture

<p align="center">
  <img src="assets/Architecture.svg" alt="Raindeer architecture diagram" style="max-width: 800px;">
</p>

## Philosophy

### It can be made simpler

Anything that just "is how it is" can be made simpler. It may take lots of time to find a way how, but it's worth it. We should really care about the little guy. People new to a framework shouldn't have to learn much. One way to do this is by removing things, things you held dear and thought you needed are the best things to remove. Incredible complexity can be hidden in a way where the surface still looks simple.

**Some of the things we removed:**
- *Namespaces* - Namespace are confusing to new and old developers, and the `::` syntax just doesn't look right. You can add them in later once you understand the basics
- *Heredoc* - If you want to write multi-line HTML then you just write it via RBX and Raindeer handles the technical hurdles
- *MVC* - You don't need to know what is called when or where to put it. Just `observe` an event in a node and render results, or call more code

### No build steps

It should just work out of the box. If that creates a "less clean" isolation between concerns then so be it. You can still isolate concerns within mixed concerns, it just takes extra thinking. Frameworks are here to make application developers lives easier, not our own.

### It's okay to be dynamic

An application is a living organism and so is the framework below it. Raindeer does a lot of dynamic processing of previously static elements; from type checking and expressions to automatic parallelisation of LowNode variables into immutable `Data` classes via Antlers syntax. This is okay, the framework should do more and feel alive. That being said, dynamic doesn't mean "magic". Methods and classes should be *compositional*, so that you can understand their hidden complexity by drilling down into them, rather than calling one magic method that goes off and adds a bunch of things but you don't know what it's done.

## Installation

Install instructions coming soon...

## Development

1. Clone the repo
2. In your terminal run:
```
bin/server
```

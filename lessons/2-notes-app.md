# Beginning the Notes App

In the last exercise, we went over the minimum surface area required to make a
user interface with React. Now we'll dig deeper, by making an app to keep track
of notes.

We'll work with the same HTML structure as last time:

```html
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <title>Learning React</title>
  </head>
  <body>
    <div id="entry-point"></div>

    <script src="lib/react.js"></script>
    <script src="lib/react-dom.js"></script>

    <script>
      console.log('Hello world!')
    </script>
  </body>
</html>
```

Open this file in a browser and open the console tab of the browser inspector.
On Chrome for Mac, you can do this with `alt + cmd + j`.

## React and React DOM

Like last time, we're pulling in two JavaScript files: React and ReactDOM. To
recap, React is separated into two components:

* The standard library
* A rendering engine

In the last lesson we talked about `createElement`, React's way to produce
atomic pieces of user interface. The neat thing about this approach is that it
is isolated from the implementation details of how to actually render a screen.

Renderers exist for a number of platforms, with first-party support for the
browser, NodeJS, and iOS and Android. However the community supports numerous
other environments such as the
[command line](https://github.com/Yomguithereal/react-blessed), and
[desktop](https://github.com/gabrielbull/react-desktop).

Since we are React loading in the browser, we're really only concerned with
rendering DOM elements (and thus we loaded ReactDOM). However the techniques we
will learn are applicable to all rendering environments.

So let's get started...

## Getting something to look at

At the bottom of the page, replace `console.log("Hello world")` with the
following:

```javascript
let notesList = React.createElement(
  "section",
  {},
  React.createElement("h1", {}, "You have 3 notes"),
  React.createElement(
    "ul",
    {},
    React.createElement("li", {}, "Learn React"),
    React.createElement("li", {}, "Get Lunch"),
    React.createElement("li", {}, "Learn React Native")
  )
)

ReactDOM.render(notesList, document.getElementById("entry-point"))
```

It's okay to feel like this is gross. It *is* gross. In the future we'll explore
ways to make everything look cleaner. But for now, it's important to expose the
underlying mechanics.

Refresh your page. You should see your brand new React application introducing
itself to the world for the first time! How exciting!

Let's recap from the introduction. `React.createElement` is React's way of
creating instructions for how to build user interfaces. If you can think of HTML
as a tree, where each element contains children inside, it's exact the same
thing. The difference is that React is capturing the _idea_ of that tree,
instead of making it right away.

This is the fundamental building block of any React app. `createElement`
provides a way to a describe user interfaces as tree of elements.

## It's all JavaScript

`React.createElement` is just a function invocation, and we have a list of
items - so why not keep track of the notes as a list, and enumerate over them?

```javascript
let notes = [
  { id: 1, content: "Learn React" },
  { id: 2, content: "Get Lunch" },
  { id: 3, content: "Learn React Native" }
]

let notesListItems = notes.map(function(message) {
  return React.createElement("li", { key: message.id }, message.content)
})

let notesList = React.createElement(
  "section",
  {},
  React.createElement("h1", {}, "You have ", notes.length, " reminders"),
  React.createElement("ul", {}, notesListItems)
)

ReactDOM.render(notesList, document.getElementById("entry-point"))
```

There are two new concepts here.

1.  **Child elements can be expressed as an array.** This allows you to easily
    enumerate over a list of data to build lists in your UI.

2.  **The `key` property (provided in the second argument) tells React how to
    keep track of list items between renders**. This also helps React to recycle
    DOM nodes when resorting a list.

React elements aren't the only building block we have to work with. We can also
create chunks of React elements that represent a common behavior: React
components.

## Creating Components

Extending the a React `Component` class allows you to make custom
React components. When you create a component, The only requirement is
that you tell it how to render:

```javascript
// For illustrative purposes only, don't replace existing code
class Workshop extends React.Component {
  render() {
    return React.createElement(
      "<section>",
      {},
      React.createElement("h1", {}, "React Native Workshop"),
      React.createElement("p", {}, "Learning the fundamentals first.")
    )
  }
})

ReactDOM.render(
  React.createElement(Workshop, {}),
  document.getElementById("entry-point")
)
```

This isn't too far off from what we've done before, however the `Workshop`
component acts as a cohesive chunk. React components must implement a `render`
method, which returns instructions for how to build the `Workshop` component.

In later sessions we'll explore adding behaviors such as button clicks and other
DOM interactions. React Components provide a framework for encapsulating that
behavior.

## Putting components to work

Looking at the code we have written for our notes app, it is easy to see at
least more two discrete components. Let's take a stab at creating those now:

```javascript
// Step 3
let notes = [
  { id: 1, content: "Learn React" },
  { id: 2, content: "Get Lunch" },
  { id: 3, content: "Learn React Native" }
]

class Note extends React.Component {
  render() {
    return React.createElement("li", {}, this.props.content)
  }
}

class NotesList extends React.Component {
  renderNote(note) {
    return React.createElement(Note, { key: note.id, content: note.content })
  }
  render() {
    let { notes } = this.props

    return React.createElement("ul", {}, notes.map(this.renderNote, this))
  }
}

class App extends React.Component {
  render() {
    let { notes } = notes

    return React.createElement(
      "section",
      {},
      React.createElement("h1", {}, "You have ", notes.length, " notes"),
      React.createElement(NotesList, { notes: notes })
    )
  }
}

ReactDOM.render(
  React.createElement(App, { notes: notes }),
  document.getElementById("entry-point")
)
```

Here we've created `App`, `NotesList` and `Note` components. Instead of
referencing `notes` globally, we pass them in as a property to the `App`, which
then distributes that data to the `NoteList`. Then the `NoteList` uses that
knowledge to build its list UI.

## React components have properties

By sending `notes` data into the `App` component, we've touched briefly on the
concept of `props`. Props provide a way to send instructions to a component for
how it should operate.

There is a direct parallel here with HTML. When you set the `disabled` property
of a button, you command it to stop receiving user interaction. Similarly, in
our example, we tell the `NotesList` the items it should render.

The strength of this approach is that it grants React components clear inputs
and outputs. Information flows in one direction, downward. When a React
component receives props, it knows to re-render.

One-way flow of data is at the heart of React. When you hear community members
speak about it, this is what they mean. It eliminates the need to monitor data
changes at a minute level. Performance optimizations can happen in isolation,
and it is easier to verify their effectiveness. Testing also becomes much
easier.

We won't dig too much deeper, however it's something to keep in mind moving
forward.

## Wrapping Up

In this lesson we converted our direct calls to `React.createElement` into
chunks of user interface concerned with displaying a particular type of
information. By this point, typing `React.createElement` _should_ feel tedious.

In the next lesson we'll explore ways to improve this. We'll explore new ways to
make working with React elements much more ergonomic.

---

[Lesson 3](../3-jsx.html)

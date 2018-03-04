# Events and State

Applications are interactive. In this lesson we'll learn how to listen to user
feedback. We'll also learn about a new way for components to keep track of
things: internal state.

Right now our application looks something like:

```html
<!DOCTYPE html>
<html>
  <head>
    <meta charset="UTF-8" />
    <title>Learning React</title>
    <link rel="stylesheet" href="lib/style.css" />
  </head>
  <body>
    <div id="entry-point"></div>

    <script src="lib/react.js"></script>
    <script src="lib/react-dom.js"></script>
    <script src="lib/babel.js"></script>

    <script type="text/babel">
      var notes = [
        { id: 1, content: 'Learn React' },
        { id: 2, content: 'Get Lunch' },
        { id: 3, content: 'Learn React Native' }
      ]

      var Note = React.createClass({
        render() {
          return <li>{ this.props.content }</li>
        }
      })

      var NotesList = React.createClass({
        renderNote(note) {
          return <Note key={ note.id } content={ note.content } />
        },
        render() {
          return <ul>{ this.props.notes.map(this.renderNote) }</ul>
        }
      })

      var App = React.createClass({
        render() {
          var notes = this.props.notes

          return (
            <section>
              <h1>You have { notes.length }</h1>
              <NotesList notes={ notes } />
            </section>
          )
        }
      })

      ReactDOM.render(<App notes={ notes } />, document.getElementById('entry-point'))
    </script>
  </body>
</html>
```

This code helped us to learn about React elements, components, and the JSX
syntax for quickly writing React code. However it isn't interactive.

## Building a form for notes

Event handlers are configured as props, just like anything else. Let's make a
new component to handle creating new notes

```javascript
var NotesForm = React.createClass({
  render: function() {
    return (
      <form ref="form" onSubmit={this.handleSubmission}>
        <input type="text" ref="content" />
        <input type="submit" value="Add Note" />
      </form>
    )
  },

  handleSubmission: function(event) {
    event.preventDefault()
    this.props.onSubmit(this.refs.content)
    this.refs.form.reset()
  }
})
```

There are a couple of new things here. First, sending the `onSubmit` prop to the
`<form>` element in the `render` function creates an event listener for that
element.

This approach works, in practice, exactly like if you were to set
`form.onsubmit` with a callback. In actuality, React sets up a delegated event
handler on the `window`. When the form submits, the event will bubble up to the
window, where React will intercept it and communicate the event to its elements.

React calls this the
[_Synthetic Event System_](https://facebook.github.io/react/docs/events.html).
We won't dig too much deeper into this, but it is an interesting area of study
for those curious.

## What is a ref?

There's another new concept: the `ref` prop. The `ref` prop acts as a pointer to
a place in the component tree:

```javascript
handleSubmission: function (event) {
  //...
  this.refs.form.reset()
  //...
}
```

In our render method, we assigned a ref of `"form"` to the form element. This
lets us access it directly in other places. Refs are a great way to quickly
retrieve information about a component.

## Hooking up the notes form

Now that we have our form, let's add it to the `App` component:

```javascript
var App = React.createClass({
  render: function() {
    return (
      <section>
        <h1>You have {this.props.notes.length} notes</h1>
        <NotesList notes={this.props.notes} />
        <NotesForm onSubmit={this.formWasSubmitted} />
      </section>
    )
  },
  formWasSubmitted: function(content) {
    alert("New note: " + content)
  }
})
```

When the form is submitted, we've told it to execute the `formWasSubmitted`
callback inside of `App`. Go ahead and give this a try.

Of course, simply alerting that the note should be created doesn't get us very
far. In order to continue, we need to talk about a new form of component data:
_state_`.

## Props and State

React components have two types of properties: props and state.

**Props are given to a component.** The only control a component has over their
props is how to inform its children about them.

**State is internal to a component.** This is useful for keeping track of
component local data. For example, drop-downs must be able to keep track of if
they are open our not.

Our application needs to keep track of notes. Let's configure the `App`
component with some internal state:

```javascript
var App = React.createClass({
  // Move notes from the top of the script into here
  getInitialState: function() {
    notes: [
      { id: 1, content: "Learn React" },
      { id: 2, content: "Get Lunch" },
      { id: 3, content: "Learn React Native" }
    ]
  },
  render: function() {
    return (
      <section>
        <h1>You have {this.state.notes.length} notes</h1>
        <NotesList notes={this.state.notes} />
        <NotesForm onSubmit={this.formWasSubmitted} />
      </section>
    )
  },
  formWasSubmitted: function(content) {
    var note = {
      id: Date.now().toString(), // cheap trick for unique ids, don't do this in production!
      content: content
    }

    this.setState({
      notes: this.state.notes.concat(note)
    })
  }
})
```

First, we add `getInitialState`, a function that runs whenever a component is
first created with `React.createElement`. It determines the initial value of the
component's internal state object.

Second, we replace all instances of `this.props.notes` with `this.state.notes`.
Notes will be managed internally to the `App`.

Third, we use a method we haven't covered yet: `setState`. `setState` queues up
a request to merge a provided object into the component's internal state. This
is _additive_, meaning that any other keys in the state object won't be blown
away.

As a final step, we no longer need to send notes in as a prop to `App`, so let's
update our render method:

```javascript
ReactDOM.render(<App notes={notes} />, document.getElementById("entry-point"))
```

## Removing notes

Adding all the notes we want is useful, but removing notes is an important
feature of any full-featured note application. We've learned everything about
React that we need to get there.

Let's work our way down from the `App` component, adding this functionality the
associated children. First, pass an `onDelete` prop into the `NotesList`:

```javascript
var App = React.createClass({
  //...
  render: function() {
    return (
      <section>
        <h1>You have {this.props.notes.length} notes</h1>
        <NotesList notes={this.props.notes} onDelete={this.noteWasDestroyed} />
        <NotesForm onSubmit={this.formWasSubmitted} />
      </section>
    )
  },
  // ...
  noteWasDestroyed: function(id) {
    this.setState({
      notes: this.state.notes.filter(function(note) {
        return note.id !== id
      })
    })
  }
})
```

Easy enough, whenever the `NotesList` invokes the callback we provide to it as
an `onDelete` prop, we will filter out all notes that match the id it provides.

Speaking of the `NotesList`, we need to teach it about the `onDelete` prop:

```javascript
var NotesList = React.createClass({
  renderNote: function(note) {
    return (
      <Note
        key={note.id}
        id={note.id}
        content={note.content}
        onDelete={this.props.onDelete}
      />
    )
  }
  //...
})
```

Easy enough, we add an `id` prop to the `<Note />`, and also send to it the
`onDelete` callback from the parent.

However the `Note` itself isn't deletable. As a final step, let's add a button
to the `Note` component that allows the user to trigger this interaction:

```javascript
var Note = React.createClass({
  render: function() {
    return (
      <li>
        {this.props.content}
        <button type="button" ref="button" onClick={this.onDeleteClick}>
          Remove
        </button>
      </li>
    )
  },
  onDeleteClick(event) {
    event.preventDefault()
    this.props.onDelete(this.props.id)
  }
})
```

That's it! Whenever the button is clicked, the `Note` component will handle the
specific implementation details of responding to the user's interaction, then
communicate the important information via the `onDelete` callback function.

## One way data flow

In order to add the delete functionality, we had to touch 3 components. Even if
this felt a little cumbersome, the flow of properties is extremely clear. As we
walked deeper into the component tree, information about the application quickly
faded away. Components such as `Note` don't even care about a `note` record at
all, simply the idea of a chunk of information with an `id` and `content.

## Props are easy to test

As an aside, the benefit to this approach is that testing these callbacks is
quite straightforward:

```javascript
function canNotifyUserDeleteIntent(id) {
  console.assert(id, "2")
}

var note = ReactDOM.render(
  <Note id="2" onDelete={canNotifyUserDeleteIntent} />,
  document.getElementById("entry-point")
)

note.refs.button.click()
```

**Clear inputs and outputs** make React components both easy to reason about and
easy to test.

## Wrapping up

In this lesson, we learned about props and state, the React synthetic event
system, and fleshed out more of our application. We touched briefly on
`getInitialState`, which is a function that runs whenever a component is first
created.

That's it! If we have extra time, or you have additionally curiosity, checkout
lesson 4, where we explore some new language features in JavaScript and
alternative patterns for writing React components.

---

[Lesson 5](../4-pascal-bonus/index.html)

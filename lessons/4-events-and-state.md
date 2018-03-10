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
      let notes = [
        { id: 1, content: 'Learn React' },
        { id: 2, content: 'Get Lunch' },
        { id: 3, content: 'Learn React Native' }
      ]

      class Note extends React.Component {
        render() {
          return <li>{this.props.content}</li>
        }
      }

      class NotesList extends React.Component {
        renderNote(note) {
          return <Note key={note.id} content={note.content} />
        }
        render() {
          let { notes } = this.props

          return <ul>{notes.map(this.renderNote, this)}</ul>
        }
      }

      class App extends React.Component {
        render() {
          let { notes } = this.props

          return (
            <section>
              <h1>You have {notes.length}</h1>
              <NotesList notes={notes} />
            </section>
          )
        }
      }

      ReactDOM.render(
        <App notes={ notes } />,
        document.getElementById('entry-point')
      )
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
class NotesForm extends React.Component {
  render() {
    return (
      <form
        ref={el => (this.form = el)}
        onSubmit={this.handleSubmission.bind(this)}
      >
        <input name="content" />
        <button>Add Note</button>
      </form>
    )
  }

  handleSubmission(event) {
    event.preventDefault()
    this.props.onSubmit(this.form.elements.content.value)
    this.form.reset()
  }
}
```

There are a couple of new things here. First, sending the `onSubmit` prop to the
`<form>` element in the `render` function creates an event listener for that
element.

This approach works, in practice, exactly like if you were to set
`form.onsubmit` with a callback. In actuality, React sets up a delegated event
handler on the `document`. When the form submits, the event will bubble up to the
document, where React will intercept it and communicate the event to its elements.

React calls this the
[_Synthetic Event System_](https://facebook.github.io/react/docs/events.html).
We won't dig too much deeper into this, but it is an interesting area of study
for those curious.

## What is a ref?

There's another new concept: the `ref` prop. The `ref` callback is called when a component mounts. It receives the form element itself, allowing us to assign it as a member of the NotesForm class for reference later.

```javascript
handleSubmission(event) {
  //...
  this.form.reset()
  //...
}
```

In our render method, we assigned a ref of `"form"` to the form element. This
lets us access it directly in other places. Refs are a great way to quickly
retrieve information about a component.

## Hooking up the notes form

Now that we have our form, let's add it to the `App` component:

```javascript
class App extends React.Component {
  render() {
    let { notes } = this.props

    return (
      <section>
        <h1>You have {notes.length} notes</h1>
        <NotesList notes={notes} />
        <NotesForm onSubmit={this.formWasSubmitted.bind(this)} />
      </section>
    )
  }

  formWasSubmitted(content) {
    alert("New note: " + content)
  }
}
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
class App extends React.Component {
  constructor(props, context) {
    super(props, context)

    this.state = {
      notes: [
        { id: 1, content: "Learn React" },
        { id: 2, content: "Get Lunch" },
        { id: 3, content: "Learn React Native" }
      ]
    }
  }

  render() {
    let { notes } = this.state

    return (
      <section>
        <h1>You have {notes.length} notes</h1>
        <NotesList notes={notes} />
        <NotesForm onSubmit={this.formWasSubmitted.bind(this)} />
      </section>
    )
  }

  formWasSubmitted(content) {
    let note = {
      id: Date.now().toString(), // cheap trick for unique ids, don't do this in production!
      content: content
    }

    this.setState({
      notes: this.state.notes.concat(note)
    })
  }
}
```

First, we've added a constructor function to setup the initial state
of the component. After calling `super(props, context)` to execute the
constructor function of the React component, we assign a state object
to the component. This initiates the value of the component's internal
state object.

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
class App extends React.Component {
  //...
  render() {
    return (
      <section>
        <h1>You have {this.props.notes.length} notes</h1>
        <NotesList notes={this.props.notes} onDelete={this.noteWasDestroyed.bind(this)} />
        <NotesForm onSubmit={this.formWasSubmitted} />
      </section>
    )
  }
  // ...
  noteWasDestroyed(id) {
    this.setState({
      notes: this.state.notes.filter(note => note.id !== id)
    })
  }
})
```

Easy enough, whenever the `NotesList` invokes the callback we provide to it as
an `onDelete` prop, we will filter out all notes that match the id it provides.

Speaking of the `NotesList`, we need to teach it about the `onDelete` prop:

```javascript
class NotesList extends React.Component {
  // ...
  renderNote(note) {
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
}
```

Easy enough, we add an `id` prop to the `<Note />`, and also send to it the
`onDelete` callback from the parent.

However the `Note` itself isn't deletable. As a final step, let's add a button
to the `Note` component that allows the user to trigger this interaction:

```javascript
class Note extends React.Component {
  render() {
    let { content, id, onDelete } = this.props

    return (
      <li>
        {this.props.content}
        <button type="button" ref="button" onClick={onDelete.bind(null, id)}>
          Remove
        </button>
      </li>
    )
  }
}
```

Whenever the button is clicked, the `Note` component will handle the
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

let entry = document.getElementById("entry-point")

let note = ReactDOM.render(
  <Note id="2" onDelete={canNotifyUserDeleteIntent} />,
  entry
)

entry.querySelector("button").click()
```

**Clear inputs and outputs** make React components both easy to reason about and
easy to test.

## An alternative way to manage form state

In this lesson, our form component, `NotesForm` manages an _uncontrolled input_. All of the state of the form input lived within the DOM. To extract that state, we have to pull information out of the DOM.

Although it has less moving parts, this keeps state out of React. Alternatively, we could create a _controlled input_. Let's go back to `NotesForm` and make some changes:

```javascript
class NotesForm extends React.Component {
  constructor(props, context) {
    super(props, context)

    this.state = {
      content: ""
    }
  }

  render() {
    let { content } = this.state

    return (
      <form onSubmit={this.handleSubmission.bind(this)}>
        <input
          name="content"
          value={content}
          onChange={this.setContent.bind(this)}
        />
        <button>Add Note</button>
      </form>
    )
  }

  setContent(event) {
    this.setState({ content: event.target.value })
  }

  handleSubmission(event) {
    event.preventDefault()
    this.props.onSubmit(this.state.content)
    this.setState({ content: "" })
  }
}
```

Now, when a user types input, the following sequence of events will occur:

1.  The `setContent` change event fires, assigning a `content` state
2.  This alerts the `NoteForm` to render again, passing in the new state
3.  React updates the input with the new value. In most cases, it sees that the value hasn't changed from what the user typed and does nothing.

Then, when the form submits, all we have to do is pass along `content` and reset the value using `setState`. No need to store truth in the DOM at all!

## Wrapping up

In this lesson, we learned about props and state, the React synthetic event
system, and fleshed out more of our application.

That's it! If we have extra time, or you have additionally curiosity, checkout
lesson 4, where we explore some new language features in JavaScript and
alternative patterns for writing React components.

---

[Lesson 5](../5-pascale-bonus.html)

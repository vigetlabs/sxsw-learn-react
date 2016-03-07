# Cleaning things up

This lesson is an intermediary step between the first and last
portions of the notes app.

In the last lesson, we made a simple React Component tree that
rendered a list of information:

```javascript
var notes = [
  { id: 1, content: 'Learn React' },
  { id: 2, content: 'Get Lunch' },
  { id: 3, content: 'Learn React Native' }
]

var Note = React.createClass({
  render() {
    return React.createElement('li', {}, this.props.content)
  }
})

var NotesList = React.createClass({
  renderNote(note) {
    return React.createElement(Note, { key: note.id, content: note.content })
  },
  render() {
    return React.createElement('ul', {}, this.props.notes.map(this.renderNote))
  }
})

var App = React.createClass({
  render() {
    var notes = this.props.notes

    return React.createElement('section', {},
      React.createElement('h1', {}, 'You have ', notes.length, ' notes'),
      React.createElement(NotesList, { notes: notes })
    )
  }
})

ReactDOM.render(React.createElement(App, { notes: notes }), document.getElementById('entry-point'))
```

By this point, calling `React.createElement` should feel
tedious. Fortunately React provides a way to make writing this code
much more enjoyable.

## JSX

[JSX](https://facebook.github.io/react/docs/jsx-in-depth.html) is an
extension to JavaScript that adds a simple HTML like syntax to the
language. It provides an abstraction for describing user interface
elements in JavaScript:

```javascript
// Before
React.createElement('p', {}, 'Hello, world!')

// After
<p>Hello, world</p>
```

Performing this transformation is done by a JavaScript compiler. The
one we will use is called [Babel](https://babeljs.io)

## Setting up Babel

Babel originated as a way to compile new JavaScript language features
down into older forms of code that every browser can. It also includes
a JSX processor.

Normally Babel requires some command line usage or integration with a
build tool such as Make, Gulp, or Grunt. Fortunately, the project also
maintains a version that can perform code transformation in the
browser; perfect for our use case.

Returning to the HTML document created in the last example, let's the
browser version of Babel to our page:

```html
...
<script src="lib/react.js"></script>
<script src="lib/react-dom.js"></script>
<script src="lib/babel.js"></script>
...
```

Finally, change the `type` of your script tag to `"text/babel"`. This is
an important step, otherwise Babel won't touch the code.

```html
...
<script src="lib/babel.js"></script>

<script type="text/javascript">
...
```

Okay! Now let's put it to use, replacing all calls to
`React.createElement` with their JSX counterparts:

```javascript
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
```

Much cleaner! By using JSX, the mental translation between what is
written and what will be rendered is much less expensive. It's also
quite a bit easier to write.

## HTML in JavaScript

JSX is one of sticking points beginners often struggle with when
picking up React. By describing HTML within JavaScript, some feel it
is a violation of the separation of concerns between markup, style,
and control logic (HTML, CSS, and JavaScript).

However _it's all the presentation layer_. Specifically, when writing
client-side applications, view templates are highly coupled to
their associated views. There is often an implicit contract created by
the data they represent. Changing one almost always leads to a change
in the other.

To that end, the React community considers the separation of a view
component into a JavaScript and HTML file to be a _separation of
technology_. By keeping them together, it makes it easier to reason
about the ramifications of a change. The relationship is explicit.

## Wrapping up

This lesson was short. We focused specifically on the conversion of
vanilla React code into the JSX format. However our application is not
interactive. In the next lesson we'll explore the React event system
and dig more into component state management.

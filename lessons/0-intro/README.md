# Introducing React

Before we dive into React Native, we need to lay down a foundation
with React itself. Over the course of the next few lessons, we'll
walk through the following:

1. React Elements and Components
2. Props and State
3. JSX (JavaScript XML Syntax)
4. Component Lifecycle Methods
5. Events

## Heads up

We'll assume as little prior knowledge with React as possible. However
we expect a working knowledge of HTML and JavaScript. If this isn't
your case, we recommend grabbing a partner. Also feel free to ping us
during the working sessions.

If you have never worked with web technologies before. the
[Mozilla Developer Network](https://developer.mozilla.org) is a
wonderful place to start.

Additionally, there are some fantastic resources on JavaScript:

- [Eloquent Javascript](http://eloquentjavascript.net/)
- [Speaking Javascript](http://speakingjs.com/es5/)

## A Brief Tour

Create an HTML document. It can be called whatever you would
like. Fill it with the following code:

```html
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <title>Introduction | Learning React</title>
    <link rel="stylesheet" href="lib/style.css" />
  </head>
  <body>
    <section id="entry-point"></section>

    <!-- Wifi might be spotty, so we've downloaded these to `./lib` -->
    <script src="lib/react.js"></script>
    <script src="lib/react-dom.js"></script>

    <!-- Alternatively: -->
    <!--<script src="https://fb.me/react-0.14.7.min.js"
                integrity="sha384-zTm/dblzLXQNp3CgY+hfaC/WJ6h4XtNrePh2CW2+rO9GPuNiPb9jmthvAL+oI/dQ"
                crossorigin="anonymous"></script> -->
    <!--<script src="https://fb.me/react-dom-0.14.7.min.js"
                integrity="sha384-ntqCsHbLdMxT352UbhPbT7fqjE8xi4jLmQYQa8mYR+ylAapbXRfdsDweueDObf7m"
                crossorigin="anonymous"></script> -->

    <script type="text/javascript">
      // Intentionally blank. Your walk-through code will go here
    </script>
  </body>
</html>
```

There isn't too much going on here. The important part is that we
include `React` and `ReactDOM` right before our empty script block.

The React library contains the standard API for React, including the
ability to create React elements and components (we'll cover this
distinction later). ReactDOM is a _rendering engine_ for React. It
basically tells React how to build a web page using the DOM.

The DOM stands for [Document Object Model](https://developer.mozilla.org/en-US/docs/Web/API/Document_Object_Model),
and it is how JavaScript interacts with a web page. You won't have to
interact much (if at all) with the DOM using React.

## React Elements

The most primitive data type in React is the _element_. They are
analogous to DOM elements, even created similarly:

```javascript
var hello = React.createElement('p', null, "Hello, World!");
```

React elements are chunks of data that describe how to build a user
interface. Think of them as low level instructions; the assembly of
React.

Providing `"p"` as the first argument tells React to build
a paragraph tag. We've skipped over the second argument, but it allows
you to set information like `className` and `tabIndex`. Just like
`document.createElement("p")`. The third argument, `"Hello, World!"`,
is a child element. Since `"Hello, World!"` is a string, React will
automatically build a text node to represent it.

## Rendering an element

In order to actually view this element, we need to _render_
it. `ReactDOM.render` is the function responsible for turning the
React elements into actual HTML:

```javascript
var hello = React.createElement('p', null, 'Hello, World!');

// Checkout what this does by opening your HTML file in the browser
ReactDOM.render(hello, document.getElementById('entry-point'));
```

## What's happening?

Let's look at the signature of `React.createElement` from the [React docs](https://facebook.github.io/react/docs/glossary.html#react-elements):

```html
ReactElement createElement(string/ReactClass type, [object props], [children ...])
```

1. **string/ReactClass**: `createElement` will accept either the
string name of an HTML element, or a React component class. We'll get
into React components later.

2. **[object props]**: An object of properties. For HTML elements,
this could be something like `disabled`, `className` or `tabIndex`.

3. **[children]**: Regular HTML elements can have children, and React
elements are no exception. This can be any number of additional
parameters passed to `createElement`, so `React.createElement('p',
null, 'Hello, ', 'World')` is also totally valid.

In using `React.createElement`, we can provide low level instructions
to whatever rendering engine we chose for how to build user
interfaces. We simply model our UI in the ideal state. React decides
the most efficient way to build and update the page for us.

## Wrapping up

This concludes the first lesson. You created your first React element
and rendered into web page. We also briefly touched on React
Components, props, and some other important concepts in the React
library.

In the next lesson, we'll dig deeper by building something more substantive.

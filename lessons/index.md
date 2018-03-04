# Learning React

This series lays the groundwork for using React to build React Native
mobile applications. For simplicity, we'll use the web version of
React, that way you can easily follow along with minimum friction.

## What we'll learn

1.  [Intro](1-intro.html)
2.  [Notes App](2-notes-app.html)
3.  [JSX](3-jsx.html)
4.  [Events and State](4-events-and-state.html)
5.  [Pascal Triangle (Bonus)](5-pascal-bonus.html)

Each lesson starts from the same basic project template, [downloadable here [⇲]](./starter-kit.zip).

If that isn't your thing, or you just want to know what it looks like:

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
      // Intentionally blank. Your walk-through code will go here
    </script>
  </body>
</html>
```

With the following required dependencies:

1.  [**React**](https://unpkg.com/react@16.2.0/umd/react.production.min.js): The cross-platform API for authoring React apps.
2.  [**ReactDOM**](https://unpkg.com/react-dom@16.2.0/umd/react-dom.production.min.js): The browser rendering engine for React.
3.  [**Babel Standalone**](https://unpkg.com/babel-standalone@6.26.0/babel.min.js): An in-browser code compiler (we'll need this in later lessons).
4.  [**Project**](./lib/starter-kit/styles.css): Our project styles, so you can focus on React.

Just be sure to link them up correctly in your local workspace!

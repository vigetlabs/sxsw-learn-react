# Pascal's Triangle

Time to have some fun. In this lesson we'll dig deeper into React Components.

[Pascal's triangle](https://en.wikipedia.org/wiki/Pascal%27s_triangle) is a
triangular array where the result of each element is the sum of the two elements
above it:

```html
          1
        1   1
      1   2   1
    1   3   3   1
  1   4   6   4   1
1   5  10   10  5   1
```

We can also visualize it graphically. Let's give it a shot:

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
      function Triangle () {
        return <path fill="currentColor" d="M0 0,2 0,1 1.732 z" />
      }

      function Cluster ({ depth, transform }) {
        if (depth <= 0) {
          return <Triangle />
        }

        return (
          <g transform={ transform }>
            <Cluster depth={ depth - 1 } transform="matrix(0.5 0 0 0.5  0  0)" />
            <Cluster depth={ depth - 1 } transform="matrix(0.5 0 0 0.5  1  0)" />
            <Cluster depth={ depth - 1 } transform="matrix(0.5 0 0 0.5 0.5 0.866)" />
          </g>
        )
      }

      function Pascal ({ depth=0, fill="#039", width=window.innerWidth, height=window.innerHeight }) {
        let x = width / 2
        let y = height / 1.732
        let scale = Math.min(x, y)

        return (
          <svg width={ width } height={ height } style={{ color: "red" }}>
            <Cluster transform={ `scale(${ scale })` } depth={ depth } fill={ fill } />
          </svg>
        )
      }

      ReactDOM.render(<Pascal depth={ 9 } />, document.getElementById('entry-point'))
    </script>
  </body>
</html>
```

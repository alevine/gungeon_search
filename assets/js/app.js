// We need to import the CSS so that webpack will load it.
// The MiniCssExtractPlugin is used to separate it out into
// its own CSS file.
import css from '../css/app.css'

// webpack automatically bundles all modules in your
// entry points. Those entry points can be configured
// in "webpack.config.js".
//
// Import dependencies
//
import 'phoenix_html'
import React from 'react'
import { render } from 'react-dom'

// Import local files
//
// Local files can be imported directly using relative paths, for example:
// import socket from "./socket"

class HelloReact extends React.Component {
  constructor(props) {
    super(props);

    this.state = { query: '' };

    this.handleSubmit = this.handleSubmit.bind(this);
    this.handleChange = this.handleChange.bind(this);
  }

  handleChange(event) {
    this.setState({ query: event.target.value });
  }

  handleSubmit(event) {
    const myInit = { method: 'GET', cache: 'default' };
    const queryParam = encodeURI(this.state.query);

    const myRequest = new Request(`/api/search/${queryParam}`, myInit);

    fetch(myRequest)
      .then((resp) => {
        console.log(resp.json());
      })
      .then((myJson) => {
        console.log(JSON.stringify(myJson));
      });
  }

  render() {
    return (
      <form onSubmit={this.handleSubmit}>
        <label>Search:
          <input type="text" value={this.state.value} onChange={this.handleChange} />
        </label>

      </form>
    );
  }
}

render(
  <HelloReact />,
  document.getElementById("app")
)

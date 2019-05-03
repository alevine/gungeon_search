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
import axios from 'axios'
import Search from './components/search'

class GungeonSearch extends React.Component {
  constructor(props) {
    super(props);
  }

  render() {
    return (
      <Search />
    );
  }
}

render(
  <GungeonSearch />,
  document.getElementById("app")
)

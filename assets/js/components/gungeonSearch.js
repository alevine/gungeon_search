import Search from './search'
import React from 'react'
import { render } from 'react-dom'

class GungeonSearch extends React.Component {
  constructor(props) {
    super(props);
  }

  render() {
    return (
      <div className="container">
        <div className="title">
          <label className="label">Search the Gungeon</label>
          <Search />
        </div>
        <footer>
          Aaron Levine
        </footer>
      </div>
    );
  }
}

export default GungeonSearch;

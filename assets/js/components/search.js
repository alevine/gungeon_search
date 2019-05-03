import React, { Component } from 'react';
import axios from 'axios';
import { debounce } from '../utils';
import Suggestions from './suggestions';

class Search extends Component {
  constructor(props) {
    super(props);
    this.state = {
      query: '',
      results: []
    };
  }

  // handles change for the search bar
  // debounced to 500ms so as to not query the database on every keystroke
  // sets state for query and resets results if query is cleared
  handleInputChange = debounce((e) => {
    this.setState({
      query: this.search.value
    }, () => {
      if (this.state.query && this.state.query.length > 1) {
        this.getResults();
      } else {
        this.setState({ results: [] });
      }
    })}, 500)

  // uses axios to fetch results from the server
  // sets state of results to the obtained items for displaying
  getResults = () => {
    const queryParam = encodeURI(this.state.query);

    axios.get(`/api/search/${queryParam}`)
      .then((resp) => {
        this.setState({
          results: resp.data.map(item => JSON.parse(item))
        });
      })
      .catch((error) => {
        console.log(error);
      });
  }

  render() {
    return (
      <form>
        <input
          placeholder="Search for an item or gun ..."
          ref={input => this.search = input}
          onChange={this.handleInputChange}
          type="search"
        />
        <Suggestions results={this.state.results} />
      </form>
    );
  }
}

export default Search;

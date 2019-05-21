import React from 'react'

const Suggestions = (props) => {

  const options = props.results.map(res => (
    <li key={`${res.name}_${res.id}`}>
      <a className="button button-outline content-button" href="#">
        {res.name}
        <img className="content-preview" src={res.image} />
      </a>
    </li>
  ))

  if (options.length > 0) {
    return(
      <div className="results">
        <ul>{options}</ul>
      </div>
    )
  } else {
    return(
      <div className="hidden" />
    )
  }
}

export default Suggestions;

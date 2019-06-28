import React from 'react'

const Suggestions = (props) => {

  const options = props.results.map(res => {
    // guns have a damage property, use this to determine where to link
    const is_gun = !!res.damage;
    const link = is_gun ? `gun/${res.id}` : `item/${res.id}`;

    return(
      <li key={`${res.name}_${res.id}`}>
        <a className="button button-outline content-button" href={link}>
          {res.name}
          <img className="content-preview" src={res.image} />
        </a>
      </li>
    );
  })

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

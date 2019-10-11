import React, { Component } from 'react';
import { SYNERGY_LINK } from '../utils';

class Synergies extends Component {
	constructor(props) {
		super(props);
		this.synergies = this.props.synergies;
	}

	render() {
    console.log(this.synergies);

    // If there are synergies, render a list, otherwise just text.
    if (this.synergies) {
      return (
		    <ul>
          {this.synergies.map((synergy) => {
            console.log(`synergy ${synergy.name}`);
            <li key={`${synergy.name}`}>
              {synergy.name}
              <a href={`${synergy.link}`}>
                <img src={`${SYNERGY_LINK}`} />
              </a>
              {synergy.effect}
            </li>
		    		})
		    	}
		    </ul>
      );
    } else {
      return (
        <p>No synergies.</p>
      );
    }
	}
}

export default Synergies;

// <li key={`${synergy.name}`}>{synergy.name}</li>

import React, { Component } from 'react';
import { getQualityImage } from '../utils';
import Synergies from './synergies';

class Gun extends Component {
  constructor(props) {
    super(props);
    this.gun = JSON.parse(this.props.gun);
  }

  render() {
    return (
      <div className="container">
        <a href="/">←</a> <label className="label">{this.gun.name}</label>
        <img className="detail-image" src={this.gun.image} />
        <p><i>{this.gun.quote}</i></p>
        <ul>
          <li key="damage">Damage: {this.gun.damage}</li>
          <li key="ammo">Ammo Capacity: {this.gun.ammo_capacity}</li>
          <li key="fire-rate">Fire Rate: {this.gun.fire_rate}</li>
          <li key="type">Type: {this.gun.type}</li>
        </ul>
        <Synergies synergies={this.gun.synergies} />
      </div>
    );
  }
}

export default Gun;

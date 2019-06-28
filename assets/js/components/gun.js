import React, { Component } from 'react';
import { getQualityImage } from '../utils';

class Gun extends Component {
  constructor(props) {
    super(props);
    this.gun = JSON.parse(this.props.gun);
  }

  render() {
    return (
      <div className="container">
        <label className="label">{this.gun.name}</label>
        <a href="/">←</a>
        <img className="detail-image" src={this.gun.image} />
        <ul>
          <li key="damage">Damage: {this.gun.damage}</li>
          <li key="ammo">Ammo Capacity: {this.gun.ammo_capacity}</li>
          <li key="fire-rate">Fire Rate: {this.gun.fire_rate}</li>
          <li key="quote">Quote: {this.gun.quote}</li>
          <li key="type">Type: {this.gun.type}</li>
        </ul>
        <ul>
          {this.gun.synergies.map((synergy) => <li key={`${synergy.name}`}>{synergy.name}</li>)}
        </ul>
      </div>
    );
  }
}

export default Gun;

/*
  schema "guns" do
    field :ammo_capacity, :string
    field :damage, :string
    field :fire_rate, :string
    field :image, :string
    field :link, :string
    field :magazine_size, :string
    field :name, :string
    field :notes, :string
    field :quality, :string
    field :quote, :string
    field :reload_time, :string
    field :shot_speed, :string
    field :spread, :string
    field :type, :string
    field :synergies, {:array, {:map, :string}}

    timestamps()
  end
 */

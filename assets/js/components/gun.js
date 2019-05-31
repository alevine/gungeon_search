import React, { Component } from 'react';

class Gun extends Component {
  constructor(props) {
    super(props);
    this.gun = JSON.parse(this.props.gun);
  }

  render() {
    return (
      <div className="container">
        <img src={this.gun.image} className="content-preview" />
        <p>
          {JSON.stringify(this.gun)}
        </p>
      </div>
    );
  }
}

export default Gun;

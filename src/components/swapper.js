import React, { Component } from 'react'
import { MDBContainer, Animation } from 'mdbreact'

class Swapper extends Component {
    state = {}

    render() {
        return (
            <Animation type="fadeIn">

                <MDBContainer className="text-center">
                    <h1>  HERE WE SWAP </h1>
                </MDBContainer>
            </Animation>
        );
    }
}

export default Swapper
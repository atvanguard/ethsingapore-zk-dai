import React, { Component } from 'react'
import { MDBContainer, Animation, MDBBtn } from 'mdbreact'
import { swap } from '../production/kyber/swapTokenToToken'

class Swapper extends Component {
    state = {}

    swapTokenToDAI = async () => {
        const KNCAddress = '0x8c13AFB7815f10A8333955854E6ec7503eD841B7'
        await swap({
            tokenAddress: KNCAddress,
        });
        console.log('Swapped')
    }

    render() {
        return (
            <Animation type="fadeIn">

                <MDBContainer className="text-center">
                    <h1>  HERE WE SWAP </h1>
                    <MDBBtn color="primary" onClick={this.swapTokenToDAI}>Swap It BRO!</MDBBtn>
                </MDBContainer>
            </Animation>
        );
    }
}

export default Swapper
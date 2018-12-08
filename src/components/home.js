import React, { Component } from 'react';
import Swapper from './swapper'
import ZeroCash from './zeroCash'
import { MDBContainer, Animation } from 'mdbreact'


class Home extends Component {
    render() {
        return (
            <Animation type="fadeIn">
                <MDBContainer>
                    <Swapper></Swapper>
                    <ZeroCash></ZeroCash>
                </MDBContainer>
            </Animation>
        )
    }
}

export default Home;
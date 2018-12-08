import React, { Component } from 'react';
import { Button, Animation } from 'mdbreact';
import web3 from '../production/web3';
const ethUtil = require('ethereumjs-util');

class Landing extends Component {
    state = {
        metaMaskLoginError: false
    };

    login = async () => {
        const address = await web3.eth.getCoinbase();
        const netId = await web3.eth.net.getId();
        if (ethUtil.isValidAddress(address) && netId == 42) {
            this.setState({ metaMaskLoginError: false });
            this.props.history.push('/swap');
        } else {
            this.setState({ metaMaskLoginError: true });
        }
    };

    render() {
        let metaMaskErrorAlert = null;

        if (this.state.metaMaskLoginError) {
            metaMaskErrorAlert = (
                <div
                    className="alert alert-danger mt-4 z-depth-2 text-center animated fadeIn"
                    role="alert"
                >
                    <strong>Error: </strong>
                    Metamask (n/w: Kovan) is required to use ZEtH!
          <br /> Please sign into Metamask or switch the network to Kovan in
                                                                                                                                                                                                                                                                              order to proceed.
        </div>
            );
        }

        return (
            <div className="container-fluid text-center">
                <Animation type="zoomIn">
                    <h1 className="display-1" style={{ marginTop: '220px' }}>
                        ZEtH
          </h1>
                </Animation>

                <Button
                    size="lg"
                    color="primary"
                    style={{ marginTop: '30px' }}
                    onClick={this.login}
                >
                    Login with MetaMask
        </Button>
                {metaMaskErrorAlert}
            </div>
        );
    }
}

export default Landing;
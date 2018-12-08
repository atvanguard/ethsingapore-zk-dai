import React, { Component } from 'react'
import { MDBContainer, Animation } from 'mdbreact'

class Swapper extends Component {
    render() {

        const kyberWidget = (<a href='https://widget.kyber.network/v0.3/?type=pay&mode=popup&theme=light&receiveAddr=0x1913b321054a50de2c726b5860be84257c915b36&receiveToken=DAI&callback=https%3A%2F%2Fkyberpay-sample.knstats.com%2Fcallback&paramForwarding=true&network=ropsten'
        class='kyber-widget-button' name='KyberWidget - Powered by KyberNetwork' title='Pay with tokens'
        target='_blank'>Pay with tokens</a>);

        return (
            <Animation type="fadeIn">

                <MDBContainer className="text-center">
                    {kyberWidget}
                </MDBContainer>
            </Animation>
        );
    }
}

export default Swapper
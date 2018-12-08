import React, { Component } from 'react'
import { MDBContainer, Animation } from 'mdbreact'

class Swapper extends Component {
    render() {

        const kyberWidget = (<a href='https://widget.kyber.network/v0.3/?type=pay&mode=popup&theme=light&receiveAddr=0x63B42a7662538A1dA732488c252433313396eade&receiveToken=ETH&callback=https%3A%2F%2F93cf11e2.ngrok.io%2Fcallback&paramForwarding=true&network=ropsten&enc=mynote'
            className='kyber-widget-button mt-3' name='KyberWidget - Powered by KyberNetwork' title='Pay with tokens'
        >Swap Tokens </a>);

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
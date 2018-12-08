import React, { Component } from 'react'
import { MDBContainer, MDBRow } from 'mdbreact'
import CashTable from './stateless/cashTable'
import OwnerCashTable from './stateless/ownerCashTable'

class ZeroCash extends Component {
    state = {

    }

    render() {

        const generalCash = [
            {
                hash: '91fa4532fb77df0790f236013511e61f62320a51a3868dabf4a13fe5f53e3263',
            },
            {
                hash: '3fe5f53e3263df0790f2360162320a51a3868dabf4a13511e91fa4532fb7761',
            },
            {
                hash: '1e91fa4532790fb7761f62320adf0601351f2351a3868dabf4a13fe5f53e3263',
            },
        ]

        const userCash = [
            {
                hash: 'df0790f236013511e91fa4532fb7761f62320a51a3868dabf4a13fe5f53e3263',
                status: 'Hodling'
            },
            {
                hash: 'f62320a51a3868dabf4a13fe5f53e3263df0790f236013511e91fa4532fb7761',
                status: 'Spent'
            },
            {
                hash: '6013511e91fa4532fb7761f62320adf0790f2351a3868dabf4a13fe5f53e3263',
                status: 'Recieved'
            },
        ]

        return (
            <MDBContainer>
                <h1 className="display-4 text-center mt-4 mb-5">Zero Cash</h1>
                <h3 className="text-center text-muted">Cash Pool</h3>
                <CashTable content={generalCash} />
                <hr className="mt-5 mb-5"></hr>
                <h3 className="text-center text-muted">Your Cash (0xb47ceB411290F0Ed4746f212658f653A7055CF33)</h3>
                <OwnerCashTable content={userCash} />
            </MDBContainer >
        );
    }
}

export default ZeroCash
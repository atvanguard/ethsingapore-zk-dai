import React, { Component } from 'react'
import CashTable from './stateless/cashTable'
import OwnerCashTable from './stateless/ownerCashTable'
import { getNotes, getCurrentAccount, getAllNotes } from '../production/secretNote'

class ZeroCash extends Component {
    state = {
        notes: [],
        allNotes: [],
    }

    getNotes = async () => {
        const notes = await getNotes();
        this.setState({ notes })
    }

    getAllNotes = async () => {
        const allNotes = await getAllNotes();
        this.setState({ allNotes })
    }

    getAccount = async () => {
        const account = await getCurrentAccount();
        this.setState({ account })
    }

    componentDidMount() {
        this.getNotes();
        this.getAccount();
        this.getAllNotes();
    }

    render() {
        return (
            <div>
                <h1 className="display-4 text-center mt-4 mb-5">Zero Cash</h1>
                <h3 className="text-center text-muted">Cash Pool</h3>
                <CashTable content={this.state.allNotes} />
                <hr className="mt-5 mb-5"></hr>
                <h3 className="text-center text-muted">Your Cash ({this.state.account})</h3>
                {/* <OwnerCashTable content={userCash} /> */}
                <OwnerCashTable content={this.state.notes} />
            </div>
        );
    }
}

export default ZeroCash
import React, { Component } from 'react';
import { Table, TableBody, TableHead } from 'mdbreact';

class OwnerCashTable extends Component {

    state = { loading: false }

    claim = async () => {
        console.log('Claiming')
    }

    getTableRows = () => {
        const tableRows = this.props.content.map((data, index) => {
            let claimer;
            if (data.status == 'Created') {
                claimer = <button
                    type="submit"
                    className="btn btn-lg btn-primary mt-4 animated fadeIn"
                    onClick={this.claim(data.amount)}
                >
                    Claim >
                    </button>
            } else {
                claimer = <button
                    type="submit"
                    className="btn btn-lg btn-primary mt-4 animated fadeIn" disabled
                >
                    Claim >
                    </button>
            }
            return (<tr key={index} className="animated fadeIn">
                <td>{index}</td>
                <td>{data.hash}</td>
                <td>{data.status}</td>
                <td>{data.amount}</td>
                <td>{claimer}</td>
            </tr>);
        })

    }

    render() {
        return (
            <Table hover>
                <TableHead>
                    <tr>
                        <th>#</th>
                        <th>Cash Hash</th>
                        <th>Status</th>
                        <th>Amount</th>
                        <th>Liquidate</th>
                    </tr>
                </TableHead>

                <TableBody>
                    {this.getTableRows()}
                </TableBody>
            </Table >
        );
    }
}

export default OwnerCashTable;
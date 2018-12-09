import React, { Component } from 'react';
import { Table, TableBody, TableHead } from 'mdbreact';
import { claimDAI } from '../../production/secretNote';

const OwnerCashTable  = (props) => {


    const claim = async (amount) => {
        console.log('Claiming', amount)
        claimDAI(parseInt(amount));
    }

    const getTableRows = () => {
        const tableRows = props.content.map((data, index) => {
            let claimer;
            if (data.status == 'Created') {
                claimer = <button
                    type="submit"
                    className="btn btn-sm btn-primary mt-4 animated fadeIn"
                    onClick={()=>{claim(data.amount)}}
                >
                    Claim
                    </button>
            } else {
                claimer = <button
                    type="submit"
                    className="btn btn-sm btn-blue-grey mt-4 animated fadeIn" disabled
                >
                    Claim
                    </button>
            }
            return (<tr key={index} className="animated fadeIn">
                <td>{index}</td>
                <td>{data.hash}</td>
                <td>{data.status}</td>
                <td>{data.amount}</td>
                <td>{claimer}</td>
            </tr>);
        });
        return tableRows;

    }
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
                    {getTableRows()}
                </TableBody>
            </Table >
        );
    
}

export default OwnerCashTable;
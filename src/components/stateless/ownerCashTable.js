import React from 'react';
import { Table, TableBody, TableHead } from 'mdbreact';

const OwnerCashTable = (props) => {
    const tableRows = props.content.map((data, index) => {
        console.log(data)
        return (<tr key={index} className="animated fadeIn">
            <td>{index}</td>
            <td>{data.hash}</td>
            <td>{data.status}</td>
            <td>{data.amount}</td>
        </tr>);
    });
    return (
        <Table hover>
            <TableHead>
                <tr>
                    <th>#</th>
                    <th>Cash Hash</th>
                    <th>Status</th>
                    <th>Amount</th>
                </tr>
            </TableHead>

            <TableBody>
                {tableRows}
            </TableBody>
        </Table>
    );
}

 

export default OwnerCashTable;
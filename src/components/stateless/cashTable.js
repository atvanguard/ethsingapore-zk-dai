import React from 'react';
import { Table, TableBody, TableHead } from 'mdbreact';

const CashTable = (props) => {
    const tableRows = props.content.map((data, index) => {
        return (<tr key={index} className="animated fadeIn">
            <td>{index}</td>
            <td>{data.hash}</td>
        </tr>);
    });
    return (
        <Table hover>
            <TableHead>
                <tr>
                    <th>#</th>
                    <th>Cash Hash</th>
                </tr>
            </TableHead>

            <TableBody>
                {tableRows}
            </TableBody>
        </Table>
    );
}

export default CashTable;
import React, { Component } from 'react';
import { MDBContainer, MDBRow, MDBCol } from 'mdbreact'
import './App.css';
import 'font-awesome/css/font-awesome.min.css';
import 'bootstrap-css-only/css/bootstrap.min.css';
import 'mdbreact/dist/css/mdb.css';
import { BrowserRouter, Route, Switch } from 'react-router-dom';

import Landing from './components/landing'
import Swapper from './components/swapper'
import ZeroCash from './components/zeroCash'


class App extends Component {
  render() {
    return (
      <BrowserRouter>
        <Switch>
          <Route path="/swapper" component={Swapper} />
          <Route path="/zeroCash" component={ZeroCash} />
          <Route component={Landing} />
        </Switch>
      </BrowserRouter>
    );
  }
}

export default App;

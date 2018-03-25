import React, { Component } from 'react'
import { Select } from 'antd';
const Option = Select.Option;
import PayRollContract from '../build/contracts/PayRoll.json'
import getWeb3 from './utils/getWeb3'

import './css/oswald.css'
import './css/open-sans.css'
import './css/pure-min.css'
import './App.css'

class App extends Component {
  constructor(props) {
    super(props)

    this.state = {
      storageValue: 0,
      web3: null,
      accounts: [],
      selectAccount: null
    }
  }

  componentWillMount() {
    // Get network provider and web3 instance.
    // See utils/getWeb3 for more info.

    getWeb3
    .then(results => {
      this.setState({
        web3: results.web3
      })

      // Instantiate contract once web3 provided.
      this.instantiateContract()
    })
    .catch(() => {
      console.log('Error finding web3.')
    })
  }

  instantiateContract() {
    const contract = require('truffle-contract')
    const PayRoll = contract(PayRollContract)
    PayRoll.setProvider(this.state.web3.currentProvider)

    // Declaring this for later so we can chain functions on PayRoll.
    var PayRollInstance

    // Get accounts.
    this.state.web3.eth.getAccounts((error, accounts) => {
      if (error) return console.error('can\'t get counts', error)
      this.setState({accounts});

      PayRoll.deployaccountsed().then((instance) => {
        PayRollInstance = instance
        return PayRollInstance.set(1, {from: accounts[0]})
      }).then((result) => {
        // Get the value from the contract to prove it worked.
        return PayRollInstance.get.call(accounts[0])
      }).then((result) => {
        // Update state with the result.
        return this.setState({ storageValue: result.c[0] })
      })
    })
  }

  onAccountChange = v => {

  }

  render() {
    return (
      <div className="App">
        <nav className="navbar pure-menu pure-menu-horizontal">
            <a href="#" className="pure-menu-heading pure-menu-link">PayRoll</a>
        </nav>

        <main className="container">
          <div>
            <Select value={this.state.selectAccount} onChange={this.onAccountChange}>
              {
                  this.state
              }
            </Select>
          </div>
        </main>
      </div>
    );
  }
}

export default App

const fs = require('fs')
const Web3 = require('web3')
const path = require('path')
const solc = require('solc')
const { sleep } = require('./util')

const LOCAL_URL = 'http://localhost:8545'

const web3 = new Web3(new Web3.providers.HttpProvider(LOCAL_URL))

const { accounts } = web3.eth

const code = fs.readFileSync(path.resolve(__dirname, '../yours.sol')).toString()

const compiledCode = solc.compile(code)

console.count(compiledCode);

// deploy
// abi 文件 -> 调用接口
const abiDefinition = JSON.parse(compiledCode.contracts[':Payroll'].interface)
const PayrollContract = web3.eth.contract(abiDefinition)

// 要部署的code
const byteCode = compiledCode.contracts[':Payroll'].bytecode

// 新建部署
const employer = accounts[0]
const employee = accounts[1]

const deployedContract = PayrollContract.new({
    data: byteCode, // code
    from: employer, // 指定发布账户
    gas: 470000
}) // call construct

const waitBlock = async () => {
    while(true) {
        const receipt = web3.eth.getTransactionReceipt(deployedContract.transactionHash)
        if (receipt && receipt.contractAddress) {
            console.log('contract has been deployed at')
            const address = receipt.contractAddress
            console.log('address', address)
            const contractInstance = PayrollContract.at(address)
            contractInstance.addFund({from: employer});
            contractInstance.updateEmployee.call(employee, {from: employer})
            contractInstance.updateSalary.call(1, {from: employer})
            contractInstance.getPaid.call({from: employee})
            break
        } else {
            console.log('wait for mine')
            await sleep(4000)
        }
    }
}

waitBlock()


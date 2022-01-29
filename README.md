# Voting Manager

## Structure:

* **/contracts**: store original codes of the smart contract.
* **/migrations**: deploy the smart contract in the “contracts” folder.
* **/test**: test codes for your smart contract, support both JavaScript and Solidity.
* **truffle.js**: configuration document.
* **truffle-config.js**: configuration document for Windows user. We can just leave it alone. (However, if your Ubuntu 16.04 is running on a virtual machine under Windows, then your configuration should also go here.)

## Truffle

`truffle create contract <NAME CONTRACT>`

`truffle compile`

`truffle migrate`
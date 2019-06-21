Tested with Node 10.15.3 LTS and Truffle v5.0.19

To run on localhost and check contracts:

Install Ganache. Change Port to 7545 if necessary.
Make sure you are using Node version 10.15.3 and Truffle v5.0.19
truffle migrate
Use Metamask to check contracts with My Ethereum Wallet online


**Three Changes have been made directly in the openzeppelin-solidity files**

**function withdrawEscrowGoalReached**

**function _advanceTime**

**function _extendTime**

**This is a TODO item to move these changes into main crowdsale contract so openzeppelin-solidity node modules can be reinstalled with 'npm install' without copying these two files again**

*TimedCrowdsale.sol is changed and if 'npm install' is run afresh, this should be copied to node_modules/openzeppelin-solidity/contracts/crowdsale/validation/TimedCrowdsale.sol from main folder.

*RefundableCrowdsale.sol is changed and if 'npm install' is run afresh, this should be copied to node_modules/openzeppelin-solidity/contracts/crowdsale/distribution/RefundableCrowdsale.sol from main folder.

FOR EASE OF UNDERSTANDING THE FOLLOWING FILES ARE ADDED DIRECTLY INTO THE MAIN FOLDER.

*RefundableCrowdsale.sol *TimedCrowdsale.sol *TokenTimeLock.sol *TokenVesting.sol


const WantMarketplacesCrowdsale = artifacts.require('./Crowdsale/WantMarketplacesCrowdsale.sol');
const WantMarketplacesToken = artifacts.require('./SecurityToken/WantMarketplacesToken.sol');
const CompanyTokenTimelock = artifacts.require('./TimeLock/CompanyTokenTimelock.sol');
const FounderTokenTimelock = artifacts.require('./TimeLock/FounderTokenTimelock.sol');
const web3 = require("web3-utils");
const ether = (n) => new web3.BigNumber(web3.toWei(n, 'ether'));

module.exports = function(deployer, network, accounts) {

    //Token Details
    const name = "WANT Marketplaces Security Token";
    const symbol = "WNT";
    const decimals = 18;
    const totalSupply = web3.toWei("1000000000", "ether");

    //Crowdsale Details
    const openingTime = Math.round((new Date()).getTime() / 1000);
    const closingTime = openingTime + 30000; // Adjust Closing Time to Unix time closing on October 31, 2019
    const rate = 1250;
    const initialRate = 1250; // Adjust Rate if Private Sale oversubscribed
    const finalRate = 835; //Adjust Final Rate in Ratio of +50% of Initial Rate if Private Sale oversubscribed
    const cap = web3.toWei("80000", "ether"); // Adjust Cap if Private Sale oversubscribed
    const goal = web3.toWei("8000", "ether"); // Adjust Goal to 1 if Soft Cap already met in Private Sale

    //Deploying Wallet
    const wallet = accounts[0];

    //Token Time Lock Details for Company Authorized Capital
    const company = accounts[0];
    const companyTokens = web3.toWei("725000000", "ether");
    const companyReleaseTime = closingTime + 300; //This time should be set in Unix as fixed date to accomodate if crowdsale closing time is extended or advanced.

    //Token Time Lock Details for Founder
    const founder = accounts[1];
    const founderTokens = web3.toWei("125000000", "ether");
    const founderReleaseTime = closingTime + 60; //This time should be set in Unix as fixed date to accomodate if crowdsale closing time is extended or advanced.

    //Tokens Available for Team Vesting / Direct to Wallet
    const team = accounts[2];
    const teamTokens = web3.toWei("47500000", "ether");
    const teamReleaseTime = closingTime + 1; //This time should be set in Unix as fixed date to accomodate if crowdsale closing time is extended or advanced.

    //Airdrop
    const airdrop = accounts[3];
    const airdropTokens = web3.toWei("2500000", "ether");

return deployer
        //Deploy Token
        .then(() => {
            return deployer.deploy(WantMarketplacesToken, name, symbol, decimals, totalSupply);
        })
        //Deploy Crowdsale
        .then(() => {           
            return deployer.deploy(WantMarketplacesCrowdsale, openingTime, closingTime, initialRate,finalRate, cap, goal, wallet, WantMarketplacesToken.address,);
        })
        //Add Crowdsale Address as Token Minter
        .then(() => {
            return WantMarketplacesToken.deployed().then(token => token.addMinter(WantMarketplacesCrowdsale.address))
     })
        //Deploy Company TokenTimelock
        .then(() => {
            const token = WantMarketplacesToken.address;
            return deployer.deploy(CompanyTokenTimelock, token, company, companyReleaseTime);
        })
        //Deploy Founder TokenTimelock
        .then(() => {
            const token = WantMarketplacesToken.address;
            return deployer.deploy(FounderTokenTimelock, token, founder, founderReleaseTime);
        })
        //Mint Company Authorized Capital Tokens and send to Company TokenTimelock
        .then(() => {
            return WantMarketplacesToken.deployed()
	.then(token => token.mint(CompanyTokenTimelock.address, companyTokens))
     })
        //Mint Founder Tokens and send to Founder TokenTimelock
	.then(() => {
            return WantMarketplacesToken.deployed()
	.then(token => token.mint(FounderTokenTimelock.address, founderTokens))
     })
        //Mint Team Tokens and send to Team Vesting Contract / Wallet
	.then(() => {
            return WantMarketplacesToken.deployed()
	.then(token => token.mint(team, teamTokens))
     })
        //Mint Airdrop Tokens and send to Airdrop Wallet
	.then(() => {
            return WantMarketplacesToken.deployed()
	.then(token => token.mint(airdrop, airdropTokens))
     })
};

//TODO
//*Add Team Token Vesting Contract after Testing OR retain functionaity As Is. Set Token Vesting later when distributed to Senior Team individually.
//*Move function withdrawEscrowGoalReached from openzeppelin-solidity/contracts/crowdsale/distribution/RefundableCrowdsale.sol to WantMarketplacesCrowdsale.sol
//*Move function _advanceTime from openzeppelin-solidity/contracts/crowdsale/validation/TimedCrowdsale.sol to WantMarketplacesCrowdsale.sol
//*Move function _extendTime from openzeppelin-solidity/contracts/crowdsale/validation/TimedCrowdsale.sol to WantMarketplacesCrowdsale.sol


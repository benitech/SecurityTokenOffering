pragma solidity 0.5.8;

import '../SecurityToken/WantMarketplacesToken.sol';
import "openzeppelin-solidity/contracts/crowdsale/Crowdsale.sol";
import "openzeppelin-solidity/contracts/crowdsale/validation/CappedCrowdsale.sol";
import 'openzeppelin-solidity/contracts/crowdsale/validation/PausableCrowdsale.sol';
import 'openzeppelin-solidity/contracts/crowdsale/validation/TimedCrowdsale.sol';
import "openzeppelin-solidity/contracts/crowdsale/distribution/PostDeliveryCrowdsale.sol";
import "openzeppelin-solidity/contracts/crowdsale/distribution/RefundableCrowdsale.sol";
import 'openzeppelin-solidity/contracts/crowdsale/emission/MintedCrowdsale.sol';
import "openzeppelin-solidity/contracts/crowdsale/price/IncreasingPriceCrowdsale.sol";

contract WantMarketplacesCrowdsale is Crowdsale, CappedCrowdsale, PausableCrowdsale, TimedCrowdsale, PostDeliveryCrowdsale, RefundableCrowdsale, MintedCrowdsale, IncreasingPriceCrowdsale {

    constructor
        (
            uint256 _openingTime,
            uint256 _closingTime,
            uint256 _initialRate,
            uint256 _finalRate,
            uint256 _cap,
            uint256 _goal,
            address payable _wallet,
            ERC20Mintable _token
        )
        public
        Crowdsale(_initialRate, _wallet, _token)
        PostDeliveryCrowdsale()
        RefundableCrowdsale(_goal)
        IncreasingPriceCrowdsale(_initialRate, _finalRate) 
        CappedCrowdsale(_cap)
        TimedCrowdsale(_openingTime, _closingTime)
        {
        require(_goal <= _cap);
        }
}

pragma solidity ^0.5.8;

import "openzeppelin-solidity/contracts/token/ERC20/SafeERC20.sol";

/**
 * @title TokenTimelock
 * @dev TokenTimelock is a token holder contract that will allow a
 * founder to extract the tokens after a given release time.
 */
contract FounderTokenTimelock {
    using SafeERC20 for IERC20;

    // ERC20 basic token contract being held
    IERC20 private _token;

    // founder of tokens after they are released
    address private _founder;

    // timestamp when token release is enabled
    uint256 private _founderReleaseTime;

    constructor (IERC20 token, address founder, uint256 founderReleaseTime) public {
        // solhint-disable-next-line not-rely-on-time
        require(founderReleaseTime > block.timestamp, "TokenTimelock: release time is before current time");
        _token = token;
        _founder = founder;
        _founderReleaseTime = founderReleaseTime;
    }

    /**
     * @return the token being held.
     */
    function token() public view returns (IERC20) {
        return _token;
    }

    /**
     * @return the founder of the tokens.
     */
    function founder() public view returns (address) {
        return _founder;
    }

    /**
     * @return the time when the tokens are released.
     */
    function founderReleaseTime() public view returns (uint256) {
        return _founderReleaseTime;
    }

    /**
     * @return the balance of total tokens held.
     */
    function amountHeld() public view returns (uint256) {
        uint256 amount = _token.balanceOf(address(this));
        return amount;
    }

    /**
     * @notice Transfers tokens held by timelock to founder.
     */
    function release() public {
        // solhint-disable-next-line not-rely-on-time
        require(block.timestamp >= _founderReleaseTime, "TokenTimelock: current time is before release time");

        uint256 amount = _token.balanceOf(address(this));
        require(amount > 0, "TokenTimelock: no tokens to release");

        _token.safeTransfer(_founder, amount);
    }
}

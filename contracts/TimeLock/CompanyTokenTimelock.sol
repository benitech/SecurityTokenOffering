pragma solidity ^0.5.8;

import "openzeppelin-solidity/contracts/token/ERC20/SafeERC20.sol";

/**
 * @title TokenTimelock
 * @dev TokenTimelock is a token holder contract that will allow a
 * company to extract the tokens after a given release time.
 */
contract CompanyTokenTimelock {
    using SafeERC20 for IERC20;

    // ERC20 basic token contract being held
    IERC20 private _token;

    // company of tokens after they are released
    address private _company;

    // timestamp when token release is enabled
    uint256 private _companyReleaseTime;

    constructor (IERC20 token, address company, uint256 companyReleaseTime) public {
        // solhint-disable-next-line not-rely-on-time
        require(companyReleaseTime > block.timestamp, "TokenTimelock: release time is before current time");
        _token = token;
        _company = company;
        _companyReleaseTime = companyReleaseTime;
    }

    /**
     * @return the token being held.
     */
    function token() public view returns (IERC20) {
        return _token;
    }

    /**
     * @return the company of the tokens.
     */
    function company() public view returns (address) {
        return _company;
    }

    /**
     * @return the time when the tokens are released.
     */
    function companyReleaseTime() public view returns (uint256) {
        return _companyReleaseTime;
    }

    /**
     * @return the balance of total tokens held.
     */
    function amountHeld() public view returns (uint256) {
        uint256 amount = _token.balanceOf(address(this));
        return amount;
    }

    /**
     * @notice Transfers tokens held by timelock to company.
     */
    function release() public {
        // solhint-disable-next-line not-rely-on-time
        require(block.timestamp >= _companyReleaseTime, "TokenTimelock: current time is before release time");

        uint256 amount = _token.balanceOf(address(this));
        require(amount > 0, "TokenTimelock: no tokens to release");

        _token.safeTransfer(_company, amount);
    }
}

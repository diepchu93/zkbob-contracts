// SPDX-License-Identifier: CC0-1.0

pragma solidity 0.8.15;

import "../proxy/EIP1967Admin.sol";

/**
 * @title Blocklist
 */
contract Blocklist is EIP1967Admin {
    address public blocklister;
    mapping(address => bool) internal blocked;

    event Blocked(address indexed account);
    event Unblocked(address indexed account);
    event BlocklisterChanged(address indexed account);

    /**
     * @dev Throws if called by any account other than the blocklister.
     */
    modifier onlyBlocklister() {
        require(msg.sender == blocklister, "Blocklist: caller is not the blocklister");
        _;
    }

    /**
     * @dev Checks if account is blocked.
     * @param _account The address to check.
     */
    function isBlocked(address _account) external view returns (bool) {
        return blocked[_account];
    }

    /**
     * @dev Adds account to blocklist.
     * @param _account The address to blocklist.
     */
    function blockAccount(address _account) external onlyBlocklister {
        blocked[_account] = true;
        emit Blocked(_account);
    }

    /**
     * @dev Removes account from blocklist.
     * @param _account The address to remove from the blocklist.
     */
    function unblockAccount(address _account) external onlyBlocklister {
        blocked[_account] = false;
        emit Unblocked(_account);
    }

    /**
     * @dev Updates address of the blocklister account.
     * Callable only by the proxy admin.
     * @param _newBlocklister address of new blocklister account.
     */
    function updateBlocklister(address _newBlocklister) external onlyAdmin {
        blocklister = _newBlocklister;
        emit BlocklisterChanged(_newBlocklister);
    }
}
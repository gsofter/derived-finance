/*
This contract allows an inheriting contract to be marked as
paused. It also defines a modifier which can be used by the
inheriting contract to prevent actions while paused.
*/

//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;


import "./Owned.sol";


/**
 * @title A contract that can be paused by its owner
 */
abstract contract Pausable is Owned {
    
    uint public lastPauseTime;
    bool public paused;

    /**
     * @dev Constructor
     */
    constructor()
    {
        // This contract is abstract, and thus cannot be instantiated directly
        require(owner != address(0), "Owner must be set");
        // Paused will be false, and lastPauseTime will be 0 upon initialisation
    }

    /**
     * @notice Change the paused state of the contract
     * @dev Only the contract owner may call this.
     */
    function setPaused(bool _paused)
        external
        onlyOwner
    {
        // Ensure we're actually changing the state before we do anything
        if (_paused == paused) {
            return;
        }

        // Set our paused state.
        paused = _paused;
        
        // If applicable, set the last pause time.
        if (paused) {
            lastPauseTime = block.timestamp;
        }

        // Let everyone know that our pause state has changed.
        emit PauseChanged(paused);
    }

    event PauseChanged(bool isPaused);

    modifier notPaused {
        require(!paused, "This action cannot be performed while the contract is paused");
        _;
    }
}
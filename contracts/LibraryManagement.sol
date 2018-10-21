pragma solidity ^0.4.18;

import './common/Ownable.sol';
import './common/Destructible.sol';
import './libs/SafeMath.sol';

contract DDNSService is Destructible {
    /** USINGS */
    using SafeMath for uint256;

    /** STRUCTS */

    /** CONSTANTS */
    
    /** STATE VARIABLES */

    /** MODIFIERS */

    /** EVENTS */

    // @dev - Constructor
    constructor() public {
        owner = msg.sender;
    }
    
}
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "forge-std/Test.sol";
import "src/SecureToken.sol";

contract Attacker {
    function attackDirectTransfer(address token, address victim) external {
        // Attacker tries to transfer victim's tokens (should fail)
        bool success = IERC20(token).transferFrom(victim, address(this), 100 * 10**18);
        require(!success, "Attack should fail!");
    }
}

contract ReentrancyAttacker {
    address private token;
    address private victim;
    uint256 private attackAmount;

    function attack(address _token, address _victim) external {
        token = _token;
        victim = _victim;
        attackAmount = IERC20(_token).balanceOf(_victim);
        // Try to perform the attack
        IERC20(_token).transferFrom(victim, address(this), attackAmount);
    }

    // Attempting reentrancy through the receive function
    receive() external payable {
        if (address(token).balance > 0) {
            IERC20(token).transferFrom(victim, address(this), attackAmount);
        }
    }
}

contract SecureTransferTest is Test {
    SecureToken token;
    Attacker attacker;
    ReentrancyAttacker reentrancyAttacker;
    address Jalaj;
    address Professor;

    function setUp() public {
        token = new SecureToken();
        attacker = new Attacker();
                        Jalaj = address(0x1);
                        Professor = address(0x2);
         /**
     * @dev See {IERC20-transfer}.
     *
     * Requirements:
     *
     * - `to` cannot be the zero address.
     * - the caller must have a balance of at least `value`.
     *     function transfer(address to, uint256 value) public virtual returns (bool) {
        address owner = _msgSender();
        _transfer(owner, to, value);
        return true;
    }
     */
        token.transfer(Jalaj, 500 * 10**18); // Jalaj gets tokens
    }

    function testSecureTransfer() public {
        vm.startPrank(Jalaj);
        token.transfer(Professor, 100 * 10**18); // Secure transfer from Jalaj to Professor
        vm.stopPrank();
        assertEq(token.balanceOf(Professor), 100 * 10**18);
    }

    function testAttackerFailsDirect() public {
        vm.startPrank(address(attacker));
        vm.expectRevert();
        attacker.attackDirectTransfer(address(token), Jalaj); // Attacker fails
        vm.stopPrank();
    }

    function testAttackerTriesVmDeal() public {
        // Attempting to set Jalaj's token balance to zero (should not work for ERC20)
        vm.deal(Jalaj, 0);
        assertGt(token.balanceOf(Jalaj), 0, "Jalaj's balance should remain unchanged");
    }
}

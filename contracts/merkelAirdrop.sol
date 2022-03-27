// SPDX-License-Identifier: MIT
pragma solidity 0.8.1;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/utils/cryptography/MerkleProof.sol";

contract MerkleAirdrop {
    address swmAddress;
    bytes32 merkleRoot;
    mapping(address => bool) claimed;

    event TokenClaim(address, uint256 amount);

    IERC20 SuperWaleMustapha = IERC20(swmAddress);

    constructor(bytes32 _merkleRoot, address _swmAddress) {
        merkleRoot = _merkleRoot;
        swmAddress = _swmAddress;
    }

    modifier notClaimed() {
        require(claimed[msg.sender] == false, "Already Claimed");
        _;
    }

    function claimForAddress(
        bytes32[] calldata _merkleProof,
        uint256 _itemId,
        uint256 _amount
    ) external notClaimed {
        // Verify the merkle proof.
        bytes32 node = keccak256(abi.encodePacked(msg.sender, _itemId, _amount));
        // bytes32 mRoot = merkleRoot;
        // address token = swmAddress;
        require(MerkleProof.verify(_merkleProof, merkleRoot, node), "MerkleDistributor: Invalid proof.");

        // Mark it claimed and send the token.
        // setAddressClaimed(msg.sender);
        SuperWaleMustapha.transfer(msg.sender, _amount);
        // claim++;
        //only emit when successful
        emit TokenClaim(msg.sender, _amount);
    }
}

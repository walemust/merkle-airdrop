// SPDX-License-Identifier: MIT
pragma solidity 0.8.1;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/utils/cryptography/MerkleProof.sol";


contract MerkleAirdrop {

    IERC20 token;
    bytes32 merkleRoot;
    mapping(address => bool) claimed;
    
    event TokenClaim(uint256 airdropID, uint256 tokenID, uint256 itemId, uint256 amount);
    

    constructor(address _tokenAddress, bytes32 _merkleRoot){
        token = IERC20(_tokenAddress);
        merkleRoot = _merkleRoot;
    }

    modifier notClaimed(){
        require(claimed[msg.sender] == false, "Already Claimed");
        _;
    }

    


    function claimForAddress(
        uint256 _airdropId,
        uint256 _itemId,
        uint256 _amount,
        bytes32[] calldata _merkleProof,
        bytes calldata _data
    ) external notClaimed {
        AddressAirdrop storage drop = s.addressAirdrops[_airdropId];
        require(drop.maxUsers > 0, "Airdrop is not created yet");
        // Verify the merkle proof.
        bytes32 node = keccak256(abi.encodePacked(msg.sender, _itemId, _amount));
        bytes32 merkleRoot = drop.merkleRoot;
        address token = drop.tokenAddress;
        require(MerkleProof.verify(_merkleProof, merkleRoot, node), "MerkleDistributor: Invalid proof.");

        // Mark it claimed and send the token.
        setAddressClaimed(msg.sender, _airdropId);
        IERC1155(token).safeTransferFrom(address(this), msg.sender, _itemId, _amount, _data);
        drop.claims++;
        //only emit when successful
        emit AddressClaim(_airdropId, msg.sender, _itemId, _amount);
    }
}
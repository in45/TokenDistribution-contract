// SPDX-License-Identifier: MIT

pragma solidity 0.8.19;

import "@openzeppelin/contracts/utils/cryptography/MerkleProof.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";


contract TokenDistribution {
    address public admin;
    address public tokenAddress;
    bytes32 public merkleRoot;
    uint256 public month;
    mapping(address => uint256) public claimed;

    event TokensClaimed(address indexed account, uint256 claimed, uint256 amount);

    constructor(bytes32 _merkleRoot) {
        admin = msg.sender;
        merkleRoot = _merkleRoot;
    }

    function setMonth(uint256 _month) external onlyAdmin {
        month = _month;
    }

    function claimTokens(bytes32[] memory proof, uint256 amount) external {
        require(claimed[msg.sender] < month, "Maximum claim limit reached");
        require(verifyProof(proof, msg.sender, amount), "Invalid proof");
        require(amount > 0, "Invalid amount");

        IERC20 token = IERC20(tokenAddress);
        require(token.balanceOf(address(this)) >= amount, "Insufficient balance in contract");

        claimed[msg.sender]++;
        require(token.transfer(msg.sender, amount), "AWT claim failed");
        emit TokensClaimed(msg.sender, claimed[msg.sender] ,amount);
    }

    function verifyProof(bytes32[] memory proof, address addr, uint256 amount) internal view returns (bool) {
        bytes32 leaf = keccak256(bytes.concat(keccak256(abi.encode(addr, amount))));
        return MerkleProof.verify(proof, merkleRoot, leaf);
    }

    function setMerkleRoot(bytes32 _merkleRoot) external onlyAdmin {
        merkleRoot = _merkleRoot;
    }

    function setTokenAddress(address _tokenAddress) external onlyAdmin {
        require(_tokenAddress != address(0), "Address cannot be zero");
        tokenAddress = _tokenAddress;
    }

    function withdrawTokens(uint256 amount) external onlyAdmin {
        IERC20 token = IERC20(tokenAddress);
        require(token.balanceOf(address(this)) >= amount, "Insufficient balance in contract");
        require(token.transfer(admin, amount), "AWT withdraw failed");
    }

    function transferAdmin(address newAdmin) external onlyAdmin {
        admin = newAdmin;
    }

    modifier onlyAdmin() {
        require(msg.sender == admin, "Only admin can call this  function");
        _;
    }
}
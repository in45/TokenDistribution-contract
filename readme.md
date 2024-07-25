# Token Distribution Contract

This repository contains a smart contract for distributing ERC20 tokens based on Merkle Tree proofs. The contract allows an admin to set up token distribution criteria and manage claims by users who provide valid Merkle proofs.

## Features

- **Set Merkle Root**: Admin can set the Merkle root to manage token distribution.
- **Claim Tokens**: Users can claim tokens if they provide a valid Merkle proof.
- **Withdraw Tokens**: Admin can withdraw tokens from the contract.
- **Transfer Admin Rights**: Admin can transfer control to a new address.
- **Limit Claims**: Each address has a maximum number of claims per month.

## Contract Overview

### State Variables

- `admin`: Address of the admin who can manage the contract.
- `tokenAddress`: Address of the ERC20 token contract.
- `merkleRoot`: Merkle root used to verify claims.
- `month`: Maximum number of claims allowed per address per month.
- `claimed`: Mapping to track the number of claims per address.

### Events

- **TokensClaimed**: Emitted when tokens are claimed by a user.

### Functions

- **`constructor`**: Initializes the contract with the deployer as admin.
- **`setMonth(uint256 _month)`**: Sets the maximum number of claims allowed per address per month.
- **`claimTokens(bytes32[] memory proof, uint256 amount)`**: Allows users to claim tokens by providing a Merkle proof.
- **`verifyProof(bytes32[] memory proof, address addr, uint256 amount)`**: Verifies the Merkle proof.
- **`setMerkleRoot(bytes32 _merkleRoot)`**: Allows the admin to set the Merkle root for claims.
- **`setTokenAddress(address _tokenAddress)`**: Allows the admin to set the ERC20 token address.
- **`withdrawTokens(uint256 amount)`**: Allows the admin to withdraw tokens from the contract.
- **`transferAdmin(address newAdmin)`**: Allows the current admin to transfer control to a new address.

### Modifiers

- **`onlyAdmin`**: Restricts function access to the admin.

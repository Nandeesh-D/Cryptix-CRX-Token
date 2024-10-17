
# Cryptix Token (CRX)

Cryptix (CRX) is an ERC20 token with enhanced functionalities including minting, burning, transfer fees, token locking, and pausing. It is built using OpenZeppelin libraries and implements additional features to manage transfer fees and ownership control.

## Features

- **Minting & Burning**
  - Only the contract owner can mint and burn tokens.
  - Ensures controlled supply by restricting these actions.

- **Transfer Fee**
  - A **1% fee** is applied on each transfer.
  - Fee is sent to a designated `feeAddress`, which is set by the owner.

- **Token Locking**
  - Tokens can be locked for a specific duration to prevent transfers.
  - Only the owner can lock or unlock tokens.

- **Pausable Contract**
  - The contract owner can **pause** and **unpause** all token transfers.
  - Useful for emergencies or maintenance.

- **Withdrawal Function**
  - The owner can withdraw Ether from the contract balance.

## Contract Functions

### 1. Minting & Burning
- `mint(address account, uint256 amount)`: Allows the owner to mint new tokens.
- `burn(address account, uint256 amount)`: Enables the owner to burn existing tokens.

### 2. Transfer Fee
- `setFeeAddress(address _feeAddress)`: Sets the address to receive the transfer fee.
- `transfer(address from, address to, uint256 amount)`: Transfers tokens between accounts after deducting the 1% fee.

### 3. Token Locking
- `lockTokens(uint256 duration)`: Locks tokens for a specified duration.
- `unlockTokens()`: Unlocks tokens after the lock period ends.

### 4. Pausable Mechanism
- `pause()`: Pauses all token transfers.
- `unpause()`: Resumes all token transfers.

### 5. Ether Withdrawal
- `withdraw(uint256 amount)`: Allows the owner to withdraw Ether from the contract.

### 6. Getters
- `getFeeAddress()`: Returns the current fee address.
- `getTransferFee()`: Returns the current transfer fee percentage.
- `getOwner()`: Returns the address of the contract owner.

## Deployment

**Prerequisites**: Make sure you have [Foundry](https://book.getfoundry.sh/) installed and set up.

### Step 1: Configure Environment Variables

Create a `.env` file in the root directory of your project and add your private key and RPC URL:
```env
PRIVATE_KEY=<your_private_key>
RPC_URL=<your_rpc_url>
```

### Step 2: Deploy Using Foundry

To deploy the contract, run the following command:
```bash
forge script script/DeployCryptix.s.sol:DeployCryptix --rpc-url $RPC_URL --private-key $PRIVATE_KEY --broadcast
```

Parameters:
- `script/DeployCryptix.s.sol`: Script file for deploying the Cryptix contract.
- `--rpc-url`: URL of the network you are deploying to (e.g., Sepolia, Polygon, Mainnet).
- `--private-key`: Your wallet's private key for deployment.

## Testing the Contract

To run tests:
```bash
forge test
```

Make sure to write your unit tests in the `test/` directory. Foundry will automatically detect and run them.

## Forking the Project

To fork this project and test it locally:

1. Clone the repository:
   ```bash
   git clone https://github.com/Nandeesh-D/Cryptix-CRX-Token.git
   cd Cryptix-CRX-Token
   ```

2. Install dependencies:
   ```bash
   forge install
   ```

3. Run the project on a fork:
   ```bash
   forge test --fork-url $RPC_URL
   ```



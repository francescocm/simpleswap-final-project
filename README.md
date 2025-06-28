# SimpleSwap: Module 3 Final Project
**Author:** Francesco Centarti Maestu

## General Description

SimpleSwap is a smart contract that implements the core functionality of a Uniswap V2-style liquidity pair. It allows users to perform three fundamental operations: adding liquidity, removing liquidity, and swapping tokens. The design focuses on simplicity and compliance with the provided specifications.

The project consists of three deployed smart contracts:

-   `TokenA.sol`: An ERC-20 test token (TKA).
-   `TokenB.sol`: An ERC-20 test token (TKB).
-   `SimpleSwap.sol`: The main contract that manages the liquidity pool and all swap operations.

## Deployed Contracts on Sepolia

All contracts have been successfully deployed and verified on the Sepolia testnet.

-   **TokenA (TKA):** `0xf5AA0c09261b6d96c7C24d604E07C670837Cb8e2`
    -   [View on Etherscan](https://sepolia.etherscan.io/address/0xf5AA0c09261b6d96c7C24d604E07C670837Cb8e2#code)

-   **TokenB (TKB):** `0x311C04Ddc758D04a5981D86345Fa838C4237d8ce`
    -   [View on Etherscan](https://sepolia.etherscan.io/address/0x311C04Ddc758D04a5981D86345Fa838C4237d8ce#code)

-   **SimpleSwap:** `0xC301960101d93D7E4a41108d58c626dd27CbCB69`
    -   [View on Etherscan](https://sepolia.etherscan.io/address/0xC301960101d93D7E4a41108d58c626dd27CbCB69#code)

## Features & Functionality

The `SimpleSwap` contract implements the following public interface:

-   **`addLiquidity`**: Allows users to deposit a pair of tokens to provide liquidity to the pool.
-   **`removeLiquidity`**: Allows liquidity providers to withdraw their corresponding share of tokens from the pool.
-   **`swapExactTokensForTokens`**: Facilitates the swap of an exact amount of an input token for the maximum possible amount of an output token.
-   **`getPrice`**: Returns the instantaneous price of one token in terms of the other, scaled to 18 decimals.
-   **`getAmountOut`**: A pure function that calculates the output amount for a given input amount, ideal for previewing swaps on a user interface.

##  Design Decisions & Best Practices

To ensure the quality and security of the contract, the following key design decisions were made:

-   **Security (Checks-Effects-Interactions Pattern):** All functions that modify state and interact with other contracts (`addLiquidity`, `removeLiquidity`, `swapExactTokensForTokens`) rigorously follow this security pattern. Validations (`require`) are performed first (Checks), followed by internal state updates (Effects), and finally, external contract calls (`transfer`, `transferFrom`) are made (Interactions). This is a critical measure to prevent re-entrancy vulnerabilities.

-   **Liquidity Management:** A simple yet effective liquidity tracking system was implemented. A mapping is used to record the liquidity provided by each user, and another mapping tracks the total liquidity of the pool. This allows for correct, proportional withdrawal calculations, which was a key point debugged to pass the verifier's tests.

-   **Adherence to Assignment Requirements:** The contract strictly adheres to the requested functions and logic, without adding extra features like fees, in order to maintain simplicity and efficiency as recommended.

## Successful Verification

The contract has been successfully tested and has passed all assertions of the official verifier on the Sepolia network.

-   **Verifier Contract Address:** `0x9f8f02dab384dddf1591c3366069da3fb0018220`
-   **Proof of Execution (Successful Transaction):** `0x65e041f4d0cfa318b2b0bc3504670e61880cbc027bf794a603e2ac80eb5aaf03`
    -   [View Transaction on Etherscan](https://sepolia.etherscan.io/tx/0x65e041f4d0cfa318b2b0bc3504670e61880cbc027bf794a603e2ac80eb5aaf03)

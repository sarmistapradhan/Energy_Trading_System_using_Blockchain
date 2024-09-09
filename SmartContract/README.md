# Energy Trading System Using Blockchain

This repository contains the Solidity implementation of the `Energy Trading System using Blockchain`, a peer-to-peer blockchain-based energy trading system. The system facilitates energy trading through a periodic double auction mechanism, enabling participants to buy and sell energy directly without intermediaries.

## Table of Contents

- [Project Overview](#project-overview)
- [Features](#features)
- [Contract Functions](#contract-functions)
- [Events](#events)
- [Deployment](#deployment)
- [Getting Started](#getting-started)
- [License](#license)

## Project Overview

The `Energy Trading System using Blockchain` is designed to allow participants to trade energy in a decentralized and transparent manner using blockchain technology. The system operates through a periodic double auction mechanism, where buyers and sellers submit bids for energy. The system then determines the clearing price and quantity where the demand meets supply and executes the transactions between matched participants.

This approach promotes a more efficient and equitable energy market by enabling direct peer-to-peer transactions, reducing the need for centralized energy providers.

## Features

- **Peer-to-Peer Trading**: Facilitates direct energy trading between participants without the need for intermediaries.
- **Periodic Double Auction**: Implements a market-clearing mechanism based on periodic double auctions.
- **Decentralized Control**: Operates on a blockchain, ensuring transparency, security, and immutability of transactions.
- **Automated Transactions**: Automatically matches and executes transactions between buyers and sellers based on their submitted bids.
- **Bid Sorting**: Efficiently sorts demand and supply bids to determine the market clearing price and quantity.
- **Market Ownership**: The contract owner has control over initiating the market-clearing process.

## Contract Functions

### Public Functions

- `demandBid(uint256 _amount, uint256 _price)`: Allows buyers to submit a bid specifying the amount of energy they wish to purchase and the price they are willing to pay.
- `supplyBid(uint256 _amount, uint256 _price)`: Allows sellers to submit a bid specifying the amount of energy they wish to sell and the price they are willing to accept.
- `computeClearing()`: Determines the market clearing price and quantity by matching the highest demand bids with the lowest supply bids. This function can only be called by the market owner.
- `getBids()`: Returns the current list of demand and supply bids.

### Internal Functions

- `quickSortDescending(Bid[] storage bids, int left, int right)`: Sorts demand bids in descending order based on price.
- `quickSortAscending(Bid[] storage bids, int left, int right)`: Sorts supply bids in ascending order based on price.
- `performTransactions()`: Executes the transactions between matched buyers and sellers based on the clearing price and quantity.
- `min(uint256 a, uint256 b)`: Helper function to return the minimum of two numbers.

## Events

- `DemandBidSubmitted(address bidder, uint256 amount, uint256 price)`: Triggered when a buyer submits a demand bid.
- `SupplyBidSubmitted(address bidder, uint256 amount, uint256 price)`: Triggered when a seller submits a supply bid.
- `MarketCleared(uint256 clearingPrice, uint256 clearingQuantity)`: Triggered when the market is cleared, indicating the clearing price and total traded quantity.
- `TransactionPerformed(address buyer, address seller, uint256 amount, uint256 price)`: Triggered when a transaction is successfully executed between a buyer and a seller.

## Deployment

The smart contract has been deployed on the Ethereum Sepolia chain. You can view the verified contract code and address at the following link:

- **Contract Address**: [0x54e0986bf4c9a3ae4061825c42734d6eccfe3f8b](https://sepolia.etherscan.io/address/0x54e0986bf4c9a3ae4061825c42734d6eccfe3f8b#code)

## Getting Started

1. **Deployment**: Deploy the contract on an Ethereum-compatible blockchain using tools like Remix, Hardhat, or Truffle.
2. **Submit Bids**: Participants can submit their bids by calling `demandBid` (for buyers) or `supplyBid` (for sellers).
3. **Clear the Market**: The market owner initiates the market-clearing process by calling `computeClearing`, which matches bids and executes transactions.
4. **View Bids**: Current bids can be viewed at any time using the `getBids` function.

## License

This project is licensed under the MIT License - see the [LICENSE](../LICENSE) file for details.
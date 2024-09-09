// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract PeriodicDoubleAuction {
    // Global Variables
    address public marketOwner;
    struct Bid {
        address bidder;
        uint256 amount;  // Energy amount
        uint256 price;   // Price per unit of energy
    }
    Bid[] public demandBids;
    Bid[] public supplyBids;
    uint256 public clearingPrice;
    uint256 public clearingQuantity;

    // Events
    event DemandBidSubmitted(address bidder, uint256 amount, uint256 price);
    event SupplyBidSubmitted(address bidder, uint256 amount, uint256 price);
    event MarketCleared(uint256 clearingPrice, uint256 clearingQuantity);
    event TransactionPerformed(address buyer, address seller, uint256 amount, uint256 price);

    // Modifiers
    modifier onlyMarketOwner() {
        require(msg.sender == marketOwner, "Only market owner can perform this action");
        _;
    }

    constructor() {
        marketOwner = msg.sender;
    }

    // Function to submit demand bid (by buyers)
    function demandBid(uint256 _amount, uint256 _price) public {
        demandBids.push(Bid(msg.sender, _amount, _price));
        emit DemandBidSubmitted(msg.sender, _amount, _price);
    }

    // Function to submit supply bid (by sellers)
    function supplyBid(uint256 _amount, uint256 _price) public {
        supplyBids.push(Bid(msg.sender, _amount, _price));
        emit SupplyBidSubmitted(msg.sender, _amount, _price);
    }

    // Function to sort demand bids in descending order of price
   function quickSortDescending(Bid[] storage bids, int left, int right) internal {
    int i = left;
    int j = right;
    if (i == j) return;
    uint pivot = bids[uint(left + (right - left) / 2)].price;
    while (i <= j) {
        while (bids[uint(i)].price > pivot) i++;
        while (pivot > bids[uint(j)].price) j--;
        if (i <= j) {
            // Perform the swap with a temporary variable to avoid the storage issue
            Bid memory temp = bids[uint(i)];
            bids[uint(i)] = bids[uint(j)];
            bids[uint(j)] = temp;

            i++;
            j--;
        }
    }
    if (left < j)
        quickSortDescending(bids, left, j);
    if (i < right)
        quickSortDescending(bids, i, right);
}

function quickSortAscending(Bid[] storage bids, int left, int right) internal {
    int i = left;
    int j = right;
    if (i == j) return;
    uint pivot = bids[uint(left + (right - left) / 2)].price;
    while (i <= j) {
        while (bids[uint(i)].price < pivot) i++;
        while (pivot < bids[uint(j)].price) j--;
        if (i <= j) {
            // Perform the swap with a temporary variable to avoid the storage issue
            Bid memory temp = bids[uint(i)];
            bids[uint(i)] = bids[uint(j)];
            bids[uint(j)] = temp;

            i++;
            j--;
        }
    }
    if (left < j)
        quickSortAscending(bids, left, j);
    if (i < right)
        quickSortAscending(bids, i, right);
}


    // Function to compute clearing price and quantity
    function computeClearing() public onlyMarketOwner {
        quickSortDescending(demandBids, 0, int(demandBids.length - 1));
        quickSortAscending(supplyBids, 0, int(supplyBids.length - 1));

        uint256 i = 0;
        uint256 j = 0;

        while (i < demandBids.length && j < supplyBids.length) {
            if (demandBids[i].price >= supplyBids[j].price) {
                uint256 matchedQuantity = min(demandBids[i].amount, supplyBids[j].amount);
                clearingQuantity += matchedQuantity;
                clearingPrice = supplyBids[j].price;
                demandBids[i].amount -= matchedQuantity;
                supplyBids[j].amount -= matchedQuantity;
                
                if (demandBids[i].amount == 0) i++;
                if (supplyBids[j].amount == 0) j++;
            } else {
                break;
            }
        }

        emit MarketCleared(clearingPrice, clearingQuantity);
        performTransactions();
    }

    // Function to perform transactions between winning buyers and sellers
    function performTransactions() internal {
        for (uint i = 0; i < demandBids.length; i++) {
            if (demandBids[i].amount > 0) continue;
            for (uint j = 0; j < supplyBids.length; j++) {
                if (supplyBids[j].amount > 0) continue;
                
                uint256 amount = min(demandBids[i].amount, supplyBids[j].amount);
                if (amount == 0) continue;

                uint256 totalPrice = amount * clearingPrice;
                
                // Transfer funds from buyer to seller (pseudocode for clarity)
                payable(supplyBids[j].bidder).transfer(totalPrice);
                // Assuming the energy transfer happens off-chain or through another mechanism
                
                emit TransactionPerformed(demandBids[i].bidder, supplyBids[j].bidder, amount, clearingPrice);
            }
        }
    }

    // Helper function to find the minimum of two numbers
    function min(uint256 a, uint256 b) internal pure returns (uint256) {
        return a < b ? a : b;
    }

    // Function to view current demand and supply bids
    function getBids() public view returns (Bid[] memory, Bid[] memory) {
        return (demandBids, supplyBids);
    }
}

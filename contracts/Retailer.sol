pragma solidity ^0.5.0;

import "./Product.sol";
import "./WholeSaler.sol";

contract Retailer {

    Product productContract;
    Wholesaler wholeSalerContract;

    event soldWine(uint256 wineBatchId);
    event buyWineBatch(uint256 wineBatchId);
    event wineBatchReceived(uint256 wineBatchId);

    mapping(uint256 => uint256) public wineRemainingInBatch;

    //modifiers
    modifier ownerOnly(uint256 productId) {
        require(productContract.getCurrentOwner(productId) == msg.sender);
        _;
    }

    constructor(Product productAddress, Wholesaler wholeSalerAddress) public {
        productContract = productAddress;
        wholeSalerContract = wholeSalerAddress;
    }

    //buy wine batch from wholesaler
    function buyWineFromWholesaler(uint256 productId, string memory dispatchDate) public payable {
        uint256 productPrice = productContract.getUnitPrice(productId) * productContract.getBatchQuantity(productId);
        require(msg.value > productPrice, "Insufficent amount to buy the wine batch");
        address payable targetAddress = address(uint160(productContract.getCurrentOwner(productId)));
        targetAddress.transfer(productPrice);

        wholeSalerContract.disbatchWineToRetailer(productId, dispatchDate, msg.sender, address(this));
        emit buyWineBatch(productId);
    }

    //Receive From fillerpacker
    function receiveWine(
        uint256 productId,
        string memory currentLocation,
        string memory arrivalDate
    ) public ownerOnly(productId) {
        require(productContract.getReceived(productId) == false);
        require(productContract.getCurrentContractAddress(productId) == address(this));
        require(productContract.getReadyToShip(productId) == true);
        (string memory location, string memory dispatchDate, string memory prevArrivalDate) = productContract.getCurrentLocation(productId);
        productContract.addPreviousLocation(productId, location, dispatchDate, prevArrivalDate);
        productContract.setCurrentLocation(productId, currentLocation, "", arrivalDate);

        productContract.setReceived(productId, true);
        productContract.setReadyToShip(productId, false);

        emit wineBatchReceived(productId);
    }

    function sellWine(uint256 productId, uint256 quantity) public {
        wineRemainingInBatch[productId] -= quantity;
    }

}
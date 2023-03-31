pragma solidity ^0.5.0;

import "./Product.sol";

contract TransitCellar {
    
    //variables
    Product productContract;
    address owner = msg.sender;
    mapping(uint256 => string) private analysisDetails; // Analysis details of each product

    //events
    event wineReceived(uint productId);
    event wineAnalysed(uint productId); 
    event wineDispatched(uint productId);

    //modifiers
    modifier ownerOnly(uint256 productId) {
        require(productContract.getCurrentOwner(productId) == msg.sender);
        _;
    }

    // modifier validProductId(uint256 productId) {
    //     require(productId < productContract.noProduct);
    //     _;
    // }

    //methods
    function getAnalysisDetails(uint256 productId) public view returns(string memory) {
       return analysisDetails[productId];
    }

    function receiveWineFromBulkDistributor(uint256 productId, string memory currentLocation, string memory arrivalDate) public payable ownerOnly(productId) {
        (string memory location, string memory dispatchDate, string memory prevArrivalDate) = productContract.getCurrentLocation(productId);
        productContract.addPreviousLocation(productId, location, dispatchDate, prevArrivalDate);
        productContract.setCurrentLocation(productId, currentLocation, "", arrivalDate);
        
        productContract.setReceived(productId, true);
        
        emit wineReceived(productId);
    }

    function analyseWine(uint256 productId, string memory analysisDetail) public {
        analysisDetails[productId] = analysisDetail;
        emit wineAnalysed(productId);
    }

    function dispatchWineToFillerPacker(uint256 productId, string memory dispatchDate, address newOwner, address newContractAddress) public ownerOnly(productId) {
        (string memory location, , string memory prevArrivalDate) = productContract.getCurrentLocation(productId);
        productContract.addPreviousLocation(productId, location, dispatchDate, prevArrivalDate);
        productContract.setCurrentLocation(productId, "", "", "");

        productContract.transferProduct(productId, newOwner, newContractAddress);
        productContract.setReceived(productId, false);
        
        emit wineDispatched(productId);
    }

}
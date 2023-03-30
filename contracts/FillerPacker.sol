pragma solidity >=0.5.0;

import "./Product.sol";

contract FillerPacker {
    
    //variables
    Product productContract;
    mapping(uint256 => string) private packagingDetails; // Packaging details of each product
    mapping(uint256 => string) private labelDetails; // Label details of each product

    //events
    event wineReceived(uint productId);
    event winePackaged(uint productId); 
    event wineLabelled(uint productId); 
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
    function getOwner() public view returns(address) {
       return owner;
    }

    function getPackagingDetails(uint256 productId) public view returns(string memory) {
       return packagingDetails[productId];
    }

    function getLabelDetails(uint256 productId) public view returns(string memory) {
       return labelDetails[productId];
    }

    function getDispatchDetails(uint256 productId) public view  returns(string memory) {
       return dispatchDates[productId];
    }

    function receiveWineFromTransitCellar(uint256 productId, string memory currentLocation, string memory arrivalDate) public ownerOnly(productId) {
        (string memory location, string memory dispatchDate, string memory prevArrivalDate) = productContract.getCurrentLocation(productId);
        productContract.addPreviousLocation(productId, location, dispatchDate, prevArrivalDate);
        productContract.setCurrentLocation(productId, currentLocation, "", arrivalDate);
        
        productContract.setReceived(productId, true);
        
        emit wineReceived(productId);
    }

    function packageWine(uint256 productId, string memory packagingDetail) public {
        packagingDetails[productId] = packagingDetail;
        emit winePackaged(productId);
    }

    function labelWine(uint256 productId, string memory labelDetail) public {
        labelDetails[productId] = labelDetail;
        emit wineLabelled(productId);
    }

    function dispatchWineToGoodsDistributor(uint256 productId, string memory labelDetail, string memory dispatchDate, address newOwner, address newContractAddress) public ownerOnly(productId) {
        (string memory location, string memory prevDispatchDate, string memory prevArrivalDate) = productContract.getCurrentLocation(productId);
        productContract.addPreviousLocation(productId, location, dispatchDate, prevArrivalDate);
        productContract.setCurrentLocation(productId, "", "", "");
        
        productContract.transferProduct(productId, newOwner, newContractAddress);

        productContract.setReceived(productId, false);
        
        emit wineDispatched(productId);
    }
}
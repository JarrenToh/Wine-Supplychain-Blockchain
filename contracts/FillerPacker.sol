pragma solidity ^0.5.0;

import "./Product.sol";
import "./TransitCellar.sol";

contract FillerPacker {
    
    //variables
    Product productContract;
    TransitCellar transitCellarContract;
    address owner = msg.sender;
    mapping(uint256 => string) private packagingDetails; // Packaging details of each product
    mapping(uint256 => string) private labelDetails; // Label details of each product

    constructor(Product productContractAddress, TransitCellar transitCellarAddress) public {
        productContract = productContractAddress;
        transitCellarContract = transitCellarAddress;
    }

    //events
    event wineBought(uint productId);
    event wineReceived(uint productId);
    event winePackaged(uint productId); 
    event wineLabelled(uint productId); 
    event wineDispatched(uint productId);
    event wineReturned(uint productId);

    //modifiers
    modifier ownerOnly(uint256 productId) {
        require(productContract.getCurrentOwner(productId) == msg.sender);
        _;
    }

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

    //Buy wine from transit cellar
    function buyWineFromTransitCellar(uint256 productId, string memory dispatchDate) public payable {
        uint256 productPrice = productContract.getUnitPrice(productId) * productContract.getBatchQuantity(productId);
        require(msg.value > productPrice, "Insufficent amount to buy the wine");
        address payable targetAddress = address(uint160(productContract.getCurrentOwner(productId)));
        targetAddress.transfer(productPrice);

        transitCellarContract.dispatchWineToFillerPacker(productId, dispatchDate, msg.sender, address(this));
        emit wineBought(productId);
    }

    //Receive wine from transit cellar
    function receiveWineFromTransitCellar(uint256 productId, string memory currentLocation, string memory arrivalDate) public ownerOnly(productId) {
        require(productContract.getReceived(productId) == false);
        require(productContract.getCurrentContractAddress(productId) == address(this));
        require(productContract.getReadyToShip(productId) == true);
        (string memory location, string memory dispatchDate, string memory prevArrivalDate) = productContract.getCurrentLocation(productId);
        productContract.addPreviousLocation(productId, location, dispatchDate, prevArrivalDate);
        productContract.setCurrentLocation(productId, currentLocation, "", arrivalDate);
        
        productContract.setReceived(productId, true);
        productContract.setReadyToShip(productId, false);
        
        emit wineReceived(productId);
    }

     //Return wine to bulk distributor
     function returnWine(uint256 productId) public payable {

        require(productContract.getReceived(productId) == true, "Wine is not yet received for return");
        require(productContract.getPreviousOwner(productId) == msg.sender, "Unable to refund items");

        uint256 productPrice = productContract.getUnitPrice(productId) * productContract.getBatchQuantity(productId);
        require(msg.value >= productPrice, "Insufficent amount for refund");
        address payable targetAddress = address(uint160(productContract.getCurrentOwner(productId)));
        targetAddress.transfer(productPrice);

        productContract.setPreviousOwner(productId, productContract.getCurrentOwner(productId));
        productContract.setCurrentOwner(productId, msg.sender);
        productContract.setPreviousContractAddress(productId, productContract.getCurrentContractAddress(productId));
        productContract.setCurrentContractAddress(productId, productContract.getPreviousContractAddress(productId));

        emit wineReturned(productId);
    }

    //Package wine and store packaging details
    function packageWine(uint256 productId, string memory packagingDetail) public {
        packagingDetails[productId] = packagingDetail;
        emit winePackaged(productId);
    }

    //Label wine and store labelling details
    function labelWine(uint256 productId, string memory labelDetail) public {
        labelDetails[productId] = labelDetail;
        emit wineLabelled(productId);
    }

    //Set wine as ready to ship to goods distributor
    function materialReadyToShip(uint256 productId) public ownerOnly(productId) {
        require(productContract.getReadyToShip(productId) == false, "Product is already ready for shipping");
        productContract.setReadyToShip(productId, true);
    }

    //Dispatch wine to goods distributor
    function dispatchWineToGoodsDistributor(uint256 productId, string memory dispatchDate, address newOwner, address newContractAddress) public ownerOnly(productId) {
        require(productContract.getReadyToShip(productId) == true, "Product not ready for shipping");
        require(productContract.getCurrentContractAddress(productId) == address(this));
        (string memory location, , string memory arrivalDate) = productContract.getCurrentLocation(productId);
        productContract.setCurrentLocation(productId, location, dispatchDate, arrivalDate);
        
        productContract.transferProduct(productId, newOwner, newContractAddress);

        productContract.setReceived(productId, false);
        
        emit wineDispatched(productId);
    }
}
pragma solidity ^0.5.0;

import "./Product.sol";
import "./BulkDistributor.sol";

contract TransitCellar {
    
    //variables
    Product productContract;
    BulkDistributor bulkDistributorContract;
    address owner = msg.sender;
    mapping(uint256 => string) private analysisDetails; // Analysis details of each product

    constructor(Product productContractAddress, BulkDistributor bulkDistributorAddress) public {
        productContract = productContractAddress;
        bulkDistributorContract = bulkDistributorAddress;
    }

    //events
    event wineBought(uint productId);
    event wineReceived(uint productId);
    event wineAnalysed(uint productId); 
    event wineDispatched(uint productId);
    event wineReturned(uint productId);
    event wineRemoved(uint productId);

    //modifiers
    modifier ownerOnly(uint256 productId) {
        require(productContract.getCurrentOwner(productId) == msg.sender);
        _;
    }

    //methods
    function getAnalysisDetails(uint256 productId) public view returns(string memory) {
       return analysisDetails[productId];
    }

     //Buy wine from bulk distributor
    function buyWineFromBulkDistributor(uint256 productId, string memory dispatchDate) public payable {
        uint256 productPrice = productContract.getUnitPrice(productId) * productContract.getBatchQuantity(productId);
        require(msg.value > productPrice, "Insufficent amount to buy the wine");
        address payable targetAddress = address(uint160(productContract.getCurrentOwner(productId)));
        targetAddress.transfer(productPrice);

        bulkDistributorContract.disbatchWineToTransitCellar(productId, dispatchDate, msg.sender, address(this));
        emit wineBought(productId);
    }

    //Receive wine from bulk distributor
    function receiveWineFromBulkDistributor(uint256 productId, string memory currentLocation, string memory arrivalDate) public payable ownerOnly(productId) {
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

    //Remove wine from products
    function removeWine(uint256 productId) public ownerOnly(productId) {
        productContract.removeProduct(productId);
        emit wineRemoved(productId);
    }

    //Analyse wine and store analysis details
    function analyseWine(uint256 productId, string memory analysisDetail) public {
        analysisDetails[productId] = analysisDetail;
        emit wineAnalysed(productId);
    }

    //Set wine as ready to ship to filler packer
    function materialReadyToShip(uint256 productId) public ownerOnly(productId) {
        require(productContract.getReadyToShip(productId) == false, "Product is already ready for shipping");
        productContract.setReadyToShip(productId, true);
    }

    //Dispatch wine to filler packer
    function dispatchWineToFillerPacker(uint256 productId, string memory dispatchDate, address newOwner, address newContractAddress) public ownerOnly(productId) {
        require(productContract.getReadyToShip(productId) == true, "Product not ready for shipping");
        require(productContract.getCurrentContractAddress(productId) == address(this));
        (string memory location, , string memory arrivalDate) = productContract.getCurrentLocation(productId);
        productContract.setCurrentLocation(productId, location, dispatchDate, arrivalDate);

        productContract.transferProduct(productId, newOwner, newContractAddress);
        productContract.setReceived(productId, false);
        
        emit wineDispatched(productId);
    }

}
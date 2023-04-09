pragma solidity ^0.5.0;

contract Product {
    address contractOwner = msg.sender;
    //struct
    struct product {
        uint256[] componentProductIds;
        uint256 productId;
        string name;
        address currentOwner;
        address currentContractAddress;
        address previousOwner;
        address previousContractAddress;
        string placeOfOrigin;
        string productionDate;
        string expirationDate;
        uint256 unitQuantity;
        string unitQuantityType;
        uint256 batchQuantity;
        uint256 unitPrice;
        string category;
        bool received;
        bool used;
        uint256[] previousLocationIds;
        productLocation currentLocation;
        bool readyToShip;
    }

    struct productLocation {
        string location;
        string disbatchDate;
        string arrivalDate;
    }

    //variables
    uint256 public noProduct = 0;
    uint256 public noLocation = 0;
    mapping(uint256 => product) private products;
    mapping(uint256 => productLocation) private location;

    //Events
    event ProductCreated(
        uint256 newProductId,
        string name,
        address currentContractAddress
    );
    event testing(uint256 productId);

    //modifiers
    modifier ownerOnly(uint256 productId) {
        require(products[productId].currentOwner == tx.origin);
        _;
    }

    modifier validProductId(uint256 productId) {
        require(productId < noProduct);
        _;
    }

    //methods
    // function createProduct(
    //     string memory name,
    //     address currentContractAddress,
    //     string memory placeOfOrigin,
    //     string memory productionDate,
    //     string memory expirationDate,
    //     uint256 unitQuantity,
    //     string memory unitQuantityType,
    //     uint256 batchQuantity,
    //     uint256 unitPrice,
    //     string memory category,
    //     string memory currentPhysicalLocation
    // ) public returns (uint256) {
    //     require(bytes(name).length > 0, "Name cannot be empty");

    //     //create new product
    //     uint256 newProductId = noProduct++;
    //     products[newProductId] = product({
    //         componentProductIds: new uint256[](0),
    //         productId: newProductId,
    //         name: name,
    //         currentOwner: msg.sender,
    //         currentContractAddress: currentContractAddress,
    //         previousOwner: address(0),
    //         previousContractAddress: address(0),
    //         placeOfOrigin: placeOfOrigin,
    //         productionDate: productionDate,
    //         expirationDate: expirationDate,
    //         unitQuantity: unitQuantity,
    //         unitQuantityType: unitQuantityType,
    //         batchQuantity: batchQuantity,
    //         unitPrice: unitPrice,
    //         category: category,
    //         received: false,
    //         used: false,
    //         previousLocationIds: new uint256[](0),
    //         currentLocation: productLocation({
    //             location: currentPhysicalLocation,
    //             disbatchDate: "null",
    //             arrivalDate: "null"
    //         }),
    //         readyToShip: false
    //     });
    //     emit ProductCreated(newProductId, name, msg.sender);
    //     return newProductId;
    // }

    function createProduct(
        string memory name,
        address currentContractAddress,
        uint256 unitQuantity,
        string memory unitQuantityType,
        uint256 batchQuantity,
        uint256 unitPrice,
        string memory category,
        address messageSender
    ) public returns (uint256) {
        require(bytes(name).length > 0, "Name cannot be empty");

        //create new product
        uint256 newProductId = noProduct++;
       // uint256 newProductId = noProduct;
        product memory newProduct = product({
            componentProductIds: new uint256[](0),
            productId: newProductId,
            name: name,
            currentOwner: messageSender,
            currentContractAddress: currentContractAddress,
            previousOwner: address(0),
            previousContractAddress: address(0),
            placeOfOrigin: "",
            productionDate: "",
            expirationDate: "",
            unitQuantity: unitQuantity,
            unitQuantityType: unitQuantityType,
            batchQuantity: batchQuantity,
            unitPrice: unitPrice,
            category: category,
            received: false,
            used: false,
            previousLocationIds: new uint256[](0),
            currentLocation: productLocation({
                location: "",
                disbatchDate: "",
                arrivalDate: ""
            }),
            readyToShip: false
        });

        products[newProductId] = newProduct;
        emit ProductCreated(newProductId, name, messageSender);
        return newProductId;
    }

    function addComponentProduct(
        uint256 mainProductId,
        uint256 productId
    ) public ownerOnly(productId) validProductId(productId) {
        products[mainProductId].componentProductIds.push(productId);
    }

    function getComponentProductIds (
        uint256 mainProductId
    ) public view validProductId(mainProductId) returns (uint256[] memory) {
        return products[mainProductId].componentProductIds;
    }

    //transfer ownership when it moves from one entity to another entity in the supplychain
    function transferProduct(
        uint256 productId,
        address newOwner,
        address newContractAdddress
    ) public ownerOnly(productId) validProductId(productId) {
        products[productId].previousOwner = products[productId].currentOwner;
        products[productId].currentOwner = newOwner;

        products[productId].previousContractAddress = products[productId]
            .currentContractAddress;
        products[productId].currentContractAddress = newContractAdddress;
    }

    function removeProduct(
        uint256 productId
    ) public ownerOnly(productId) validProductId(productId) {
        delete products[productId];
    }

    function getProductName(
        uint256 productId
    ) public view validProductId(productId) returns (string memory) {
        return products[productId].name;
    }

    function getCurrentOwner(
        uint256 productId
    ) public view validProductId(productId) returns (address) {
        return products[productId].currentOwner;
    }

    function setCurrentOwner(
        uint256 productId,
        address newOwner
    ) public ownerOnly(productId) validProductId(productId) {
        products[productId].currentOwner = newOwner;
    }

    function getCurrentContractAddress(
        uint256 productId
    ) public view validProductId(productId) returns (address) {
        return products[productId].currentContractAddress;
    }

    function setCurrentContractAddress(
        uint256 productId,
        address newContractAddress
    ) public ownerOnly(productId) validProductId(productId) {
        products[productId].currentContractAddress = newContractAddress;
    }

    function getPreviousOwner(
        uint256 productId
    ) public view validProductId(productId) returns (address) {
        return products[productId].previousOwner;
    }

    function setPreviousOwner(
        uint256 productId,
        address newPreviousOwner
    ) public ownerOnly(productId) validProductId(productId) {
        products[productId].previousOwner = newPreviousOwner;
    }

    function getPreviousContractAddress(
        uint256 productId
    ) public view validProductId(productId) returns (address) {
        return products[productId].previousContractAddress;
    }

    function setPreviousContractAddress(
        uint256 productId,
        address newPreviousContractAddress
    ) public ownerOnly(productId) validProductId(productId) {
        products[productId]
            .previousContractAddress = newPreviousContractAddress;
    }

    function getPlaceOfOrigin(
        uint256 productId
    ) public view validProductId(productId) returns (string memory) {
        return products[productId].placeOfOrigin;
    }

    function setPlaceOfOrigin(
        uint256 productId,
        string memory newPlaceOfOrigin
    ) public ownerOnly(productId) validProductId(productId) {
        products[productId].placeOfOrigin = newPlaceOfOrigin;
    }

    function getProductionDate(
        uint256 productId
    ) public view validProductId(productId) returns (string memory) {
        return products[productId].productionDate;
    }

    function setProductionDate(
        uint256 productId,
        string memory newProductionDate
    ) public ownerOnly(productId) validProductId(productId) {
        products[productId].productionDate = newProductionDate;
    }

    function getExpirationDate(
        uint256 productId
    ) public view validProductId(productId) returns (string memory) {
        return products[productId].expirationDate;
    }

    function setExpirationDate(
        uint256 productId,
        string memory newExpirationDate
    ) public ownerOnly(productId) validProductId(productId) {
        products[productId].expirationDate = newExpirationDate;
    }

    function getUnitQuantity(
        uint256 productId
    ) public view validProductId(productId) returns (uint256) {
        return products[productId].unitQuantity;
    }

    function setUnitQuantity(
        uint256 productId,
        uint256 newUnitQuantity
    ) public ownerOnly(productId) validProductId(productId) {
        products[productId].unitQuantity = newUnitQuantity;
    }

    function getUnitQuantityType(
        uint256 productId
    ) public view validProductId(productId) returns (string memory) {
        return products[productId].unitQuantityType;
    }

    function setUnitQuantityType(
        uint256 productId,
        string memory newUnitQuantityType
    ) public ownerOnly(productId) validProductId(productId) {
        products[productId].unitQuantityType = newUnitQuantityType;
    }

    function getBatchQuantity(
        uint256 productId
    ) public view validProductId(productId) returns (uint256) {
        return products[productId].batchQuantity;
    }

    function setBatchQuantity(
        uint256 productId,
        uint256 newBatchQuantity
    ) public ownerOnly(productId) validProductId(productId) {
        products[productId].batchQuantity = newBatchQuantity;
    }

    function getUnitPrice(
        uint256 productId
    ) public view validProductId(productId) returns (uint256) {
        return products[productId].unitPrice;
    }

    function setUnitPrice(
        uint256 productId,
        uint256 newUnitPrice
    ) public ownerOnly(productId) validProductId(productId) {
        products[productId].unitPrice = newUnitPrice;
    }

    function getCategory(
        uint256 productId
    ) public view validProductId(productId) returns (string memory) {
        return products[productId].category;
    }

    function setCategory(
        uint256 productId,
        string memory newCategory
    ) public ownerOnly(productId) validProductId(productId) {
        products[productId].category = newCategory;
    }

    function getReceived(
        uint256 productId
    ) public view validProductId(productId) returns (bool) {
        return products[productId].received;
    }

    function setReceived(
        uint256 productId,
        bool newReceived
    ) public ownerOnly(productId) validProductId(productId) {
        products[productId].received = newReceived;
    }

    function getUsed(
        uint256 productId
    ) public view validProductId(productId) returns (bool) {
        return products[productId].used;
    }

    function setUsed(
        uint256 productId,
        bool used
    ) public ownerOnly(productId) validProductId(productId) {
        products[productId].used = used;
    }

    function getPreviousLocation(
        uint256 productId,
        uint256 index
    )
        public
        view
        validProductId(productId)
        returns (string memory, string memory, string memory)
    {
        require(
            index < products[productId].previousLocationIds.length,
            "Invalid index"
        );
        return (
            location[products[productId].previousLocationIds[index]].location,
            location[products[productId].previousLocationIds[index]]
                .disbatchDate,
            location[products[productId].previousLocationIds[index]].arrivalDate
        );
    }

    function addPreviousLocation(
        uint256 productId,
        string memory prevLocation,
        string memory prevDisbatchDate,
        string memory prevArrivalDate
    ) public ownerOnly(productId) validProductId(productId) {
        uint256 newLocationId = noLocation++;
        location[newLocationId] = productLocation({
            location: prevLocation,
            disbatchDate: prevDisbatchDate,
            arrivalDate: prevArrivalDate
        });
        products[productId].previousLocationIds.push(newLocationId);
    }

    function getCurrentLocation(
        uint256 productId
    )
        public
        view
        validProductId(productId)
        returns (string memory, string memory, string memory)
    {
        return (
            products[productId].currentLocation.location,
            products[productId].currentLocation.disbatchDate,
            products[productId].currentLocation.arrivalDate
        );
    }

    function setCurrentLocation(
        uint256 productId,
        string memory newLocation,
        string memory newDisbatchDate,
        string memory newArrivalDate
    ) public ownerOnly(productId) validProductId(productId) {
        products[productId].currentLocation = productLocation({
            location: newLocation,
            disbatchDate: newDisbatchDate,
            arrivalDate: newArrivalDate
        });
    }

    function getReadyToShip(
        uint256 productId
    ) public view ownerOnly(productId) returns (bool) {
        return products[productId].readyToShip;
    }

    function setReadyToShip(
        uint256 productId,
        bool _shipStatus
    ) public ownerOnly(productId) validProductId(productId) {

        products[productId].readyToShip = _shipStatus;
        // products[productId].readyToShip = true;
    }

    function getComponentProductIds(uint256 productId) public view validProductId(productId) returns (uint256[] memory) {
        return products[productId].componentProductIds;
    }

}

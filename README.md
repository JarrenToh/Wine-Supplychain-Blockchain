# Wine Supply Chain Smart Contract Readme
This smart contract is designed to implement a supply chain for the production and distribution of wine, from the grape grower to the retailer. The supply chain consists of several stages, including grape growing, wine production, bulk distribution, transit storage, filling/packaging, goods distribution, wholesaling, and retailing. Each stage is represented by a different actor in the supply chain and has its own set of functions and responsibilities

## Requirement

Ganache: A personal blockchain for Ethereum development.

Truffle: A development framework for building and deploying smart contracts.

Visual Studio Code: Integrated Development Environment

## Actors
The actors in the supply chain are as follows:

  GrapeGrower: This actor is responsible for growing and harvesting the grapes that will be used to produce wine.
  
  WineProducer: This actor is responsible for transforming the grapes into wine, including fermentation and aging.
  
  BulkDistributor: This actor is responsible for transporting the wine from the wine producer to the transit cellar, where it will be stored temporarily.
  
  TransitCellar: This actor is responsible for storing the wine temporarily until it is ready to be packaged and distributed.
  
  Filler/Packer: This actor is responsible for filling and packaging the wine for distribution.
  
  GoodsDistributor: This actor is responsible for transporting the packaged wine from the filler/packer to the wholesaler.
  
  Wholesaler: This actor is responsible for distributing the wine to retailers.
  
  Retailer: This actor is responsible for selling the wine to end customers.

## Functions

The following functions are available for each actor in the supply chain:

### Product.sol

  1. createProduct: This function is used to create a new product instance in the system. It takes in various parameters such as name, current contract address, unit quantity, unit quantity type, batch quantity, unit price, category and message sender address. It then creates a new product instance using the Product contract and sets the required information for the product such as product ID, name, current owner, current contract address, unit quantity, unit quantity type, batch quantity, unit price, category and other details such as whether the product is received or used, its current and previous location, and whether it is ready to ship.
  
  2. addComponentProduct: This function adds a component product to the given main product. It takes two parameters: mainProductId, which is the ID of the main product, and productId, which is the ID of the component product to be added. The function first checks if the caller of the function is the owner of the productId using the ownerOnly modifier, and then checks if the productId is valid using the validProductId modifier. Finally, it adds the productId to the componentProductIds array of the main product.
  
  3. getComponentProductIds: This function returns an array of component product IDs for the given main product. It takes one parameter: mainProductId, which is the ID of the main product. The function first checks if the mainProductId is valid using the validProductId modifier, and then returns the componentProductIds array of the main product.
  
  4. transferProduct: This function transfers ownership of the given product to a new owner and updates the contract address. It takes three parameters: productId, which is the ID of the product to be transferred, newOwner, which is the address of the new owner, and newContractAddress, which is the address of the new contract. The function first checks if the caller of the function is the owner of the productId using the ownerOnly modifier, and then checks if the productId is valid using the validProductId modifier. The function then updates the previousOwner and previousContractAddress fields of the product with the current owner and contract address, and then updates the currentOwner and currentContractAddress fields with the new owner and contract address.

  5. removeProduct: This function removes the given product from the system. It takes one parameter: productId, which is the ID of the product to be removed. The function first checks if the caller of the function is the owner of the productId using the ownerOnly modifier, and then checks if the productId is valid using the validProductId modifier. Finally, it deletes the product from the system.
  
  6. getProductName: This function returns the name of the given product. It takes one parameter: productId, which is the ID of the product. The function first checks if the productId is valid using the validProductId modifier, and then returns the name field of the product.
  
  7. getCurrentOwner: This function returns the current owner address of the given product. It takes one parameter: productId, which is the ID of the product. The function first checks if the productId is valid using the validProductId modifier, and then returns the currentOwner field of the product.
  
  8. setCurrentOwner: This function updates the current owner address of the given product. It takes two parameters: productId, which is the ID of the product, and newOwner, which is the address of the new owner. The function first checks if the caller of the function is the owner of the productId using the ownerOnly modifier, and then checks if the productId is valid using the validProductId modifier. The function then updates the currentOwner field of the product with the new owner address.
  
  9. getCurrentContractAddress: This function returns the current contract address of the product with the given productId.
  
  10. setCurrentContractAddress: This function sets the current contract address of the product with the given productId to the new address newContractAddress.
  
  11. getPreviousOwner: This function returns the previous owner of the product with the given productId.
  
  12. setPreviousOwner: This function sets the previous owner of the product with the given productId to the new owner address newPreviousOwner.
  
  13. getPreviousContractAddress: This function returns the previous contract address of the product with the given productId
  
  14. setPreviousContractAddress: This function sets the previous contract address of the product with the given productId to the new address newPreviousContractAddress.
  
  15. getPlaceOfOrigin: This function returns the place of origin of the product with the given productId.
  
  16. setPlaceOfOrigin: This function sets the place of origin of the product with the given productId to the new value newPlaceOfOrigin.

  17. getProductionDate: This function returns the production date of the product with the given productId.

  18: setProductionDate: This function sets the production date of the product with the given productId to the new value newProductionDate.

  19: getExpirationDate: This function returns the expiration date of the product with the given productId.

  20. setExpirationDate: This function sets the expiration date of the product with the given productId to the new value newExpirationDate.

  21. getUnitQuantity: This function returns the unit quantity of the product with the given productId.

  22. setUnitQuantity: This function sets the unit quantity of the product with the given productId to the new value newUnitQuantity.

  23. getUnitQuantityType: This function returns the unit quantity type of the product with the given productId.

  24. setUnitQuantityType: This function sets the unit quantity type of the product with the given productId to the new value newUnitQuantityType.

  25. getBatchQuantity: This function returns the batch quantity of the product with the given productId.

  26. setBatchQuantity: This function sets the batch quantity of the product with the given productId to the new value newBatchQuantity.

  27. getUnitPrice: This function returns the unit price of the product with the given productId.

  28. setUnitPrice: This function sets the unit price of the product with the given productId to the new value newUnitPrice.

  29. getCategory: This function returns the category of the product with the given productId.
  
  30. setCategory: This function sets the category of the product with the given productId to the specified newCategory.

  31. getReceived: This function returns a boolean value indicating whether the product with the given productId has been received.

  32. setReceived: This function sets the received status of the product with the given productId to the specified newReceived boolean value.

  33. getUsed: This function returns a boolean value indicating whether the product with the given productId has been used.

  34. setUsed: This function sets the used status of the product with the given productId to the specified used boolean value.

  35. getPreviousLocation: This function returns a tuple of three strings representing the location, dispatch date, and arrival date of the product with the given productId at the specified index in its previous location history.

  36. addPreviousLocation: This function adds a new previous location to the product with the given productId, recording the location name, dispatch date, and arrival date as specified in the function arguments.

  37. getCurrentLocation: This function returns a tuple of three strings representing the current location, dispatch date, and arrival date of the product with the given productId.

  38. setCurrentLocation: This function sets the current location of the product with the given productId to the specified location name, dispatch date, and arrival date.

  39. getReadyToShip: This function returns a boolean value indicating whether the product with the given productId is ready to be shipped.

  40. setReadyToShip: This function sets the ready to ship status of the product with the given productId to the specified boolean value.

### RawMaterialSupplier.sol

  1. addRawMaterial: This function is used to add new raw materials to the system. It takes in various parameters such as name, place of origin, production and expiration dates, unit quantity, unit quantity type, batch quantity, unit price, category and current physical location. It then creates a new product instance using the Product contract and sets the required information for the raw material.

  2. removeRawMaterial: This function is used to remove raw materials from the system. It takes in the product ID of the raw material to be removed and calls the removeProduct function in the Product contract.

  3. materialReadyToShip: This function is used to indicate that a raw material is ready for shipping. It takes in the product ID of the raw material and sets the readyToShip flag to true.

  4. dispatchRawMaterial: This function is used to dispatch a raw material to a wine producer. It takes in the product ID of the raw material, the new dispatch date, and the address of the wine producer and the wine producer contract address. It then sets the previous owner and contract address, updates the current location and owner, and emits an event indicating that the raw material has been dispatched.

  5. refundWineProducer: 


### WineProducer.sol


### BulkDistributor.sol


### TransitCellar.sol


### FillerPacker.sol


### GoodsDistributor.sol


### Wholesaler.sol


### Retailer.sol


## Deployment
To deploy the smart contract, you can use Solidity 9 and deploy it on any compatible blockchain platform, like Ethereum. One way to deploy it is by using a smart contract deployment tool such as Remix. Alternatively, you can use Visual Studio Code (VSCode) to compile and deploy the contract. To do this, you will need to install the necessary extensions and configure your development environment accordingly. Once set up, you can compile the contract using the Solidity Compiler extension and deploy it to the blockchain of your choice using the Truffle Suite.

To run the smart contract and associated tests, you will need to follow these steps:

Start Ganache: ganache-cli

Compile the Solidity contract: truffle compile

Deploy the contract to the local blockchain: truffle migrate

Run the tests: truffle test test_supplyChain.js

This will execute the test_supplyChain.js file, which contains a series of tests to ensure that the smart contract functions as expected.


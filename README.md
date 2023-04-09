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

### RawMaterialSupplier.sol
  1. addRawMaterial: This function is used to add new raw materials to the system. It takes in various parameters such as name, place of origin, production and expiration dates, unit quantity, unit quantity type, batch quantity, unit price, category and current physical location. It then creates a new product instance using the Product contract and sets the required information for the raw material.

  2. removeRawMaterial: This function is used to remove raw materials from the system. It takes in the product ID of the raw material to be removed and calls the removeProduct function in the Product contract.

  3. materialReadyToShip: This function is used to indicate that a raw material is ready for shipping. It takes in the product ID of the raw material and sets the readyToShip flag to true.

  4. dispatchRawMaterial: This function is used to dispatch a raw material to a wine producer. It takes in the product ID of the raw material, the new dispatch date, and the address of the wine producer and the wine producer contract address. It then sets the previous owner and contract address, updates the current location and owner, and emits an event indicating that the raw material has been dispatched.

  5. refundWineProducer: This function is used by the wine producer to request a refund for a raw material. It takes in the product ID of the raw material and checks that the caller is the current owner. It then calculates the refund amount based on the product price and sends it back to the previous owner.


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


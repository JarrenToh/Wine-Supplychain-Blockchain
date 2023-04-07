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


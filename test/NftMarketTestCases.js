const { italic } = require("ansi-colors");
const { expect } = require("chai");
const { ethers } = require("hardhat");
const { waffle } = require("hardhat");

describe("simple Nft Market Place",()=>{
 
 let owner,signer1,signer2,nftMarket,_transferAmount;

 beforeEach(async()=>{
    [owner,signer1,signer2] = await  ethers.getSigners();

    const NftMarket = await ethers.getContractFactory("NftMarketPlace");
    nftMarket = await NftMarket.deploy();
    nftMarket.deployed();
     _transferAmount = ethers.utils.parseEther("1");


 })



})
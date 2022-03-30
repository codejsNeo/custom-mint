const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("CustomMint", function () {
  let contractFactory;
  let contract;
  let owner;
  let ownerAddress;
  let ownerBalance;


  beforeEach(async () => {
    owner = await ethers.getSigner();
    contractFactory = await ethers.getContractFactory("CustomMint");
    contract = await contractFactory.deploy();
    ownerAddress = await owner.getAddress();
    // ownerBalance = await owner.balanceOf(owner.address);
    // console.log(ownerBalance);
  });


  describe("Correct setup", () => {
    it("should have max supply of 100", async () => {
        const maxSupply = await contract.maxSupply();
        expect(maxSupply).to.equal(100);
    });

    it("should reject if max supply is not 100", async () => {
      const maxSupply = await contract.maxSupply();
      expect(maxSupply).to.not.equal(50);
    });

    // it("should have mint fee equal to 0.001 ether", async () => {
    //   const mintFee = await contract.mintFee();
    //   expect(mintFee).to.not.equal(0.001);
    // });
  });

  describe("mint fee function", () => {
    it("should update the mint fee only by owner", async () => {
      const fee = await contract.setMintFee(3);
      expect(fee).to.be.not.undefined;
      expect(fee).to.be.not.null;
      expect(fee).to.be.not.NaN;
      // expect(fee).to.equal(3);
    })
  })

  describe.only("withdraw function",() => {
    it("should transfer all sent ETH to the owner", async () => {
      
    })
  });

  
});
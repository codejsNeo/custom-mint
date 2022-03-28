const { expect } = require("chai");

describe("Token contract", function () {
  it("Check the token supply", async function () {
    const [owner] = await ethers.getSigners();

    const Token = await ethers.getContractFactory("CustomMint");

    const hardhatToken = await Token.deploy();

    expect(await hardhatToken.setMintFee()).to.equal(100);
    // const ownerBalance = await hardhatToken.balanceOf(owner.address);
    // expect(await hardhatToken.totalSupply()).to.equal(ownerBalance);
    done()
  });
});
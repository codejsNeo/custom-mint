async function main() {
    const CustomMint = await ethers.getContractFactory("CustomMint");
 
    // Start deployment, returning a promise that resolves to a contract object
    const custom_mint = await CustomMint.deploy();
    console.log("Contract deployed to address:", custom_mint.address);
 }
 
 main()
   .then(() => process.exit(0))
   .catch(error => {
     console.error(error);
     process.exit(1);
   });
import { ethers } from "hardhat";

async function deployToken() {
  const merkleDrop = await ethers.getContractFactory("SuperWaleMustapha");
  const merkle_drop = await merkleDrop.deploy("Super Wale Mustapha", "SWM");
  await merkle_drop.deployed();
  console.log("contract address: ", merkle_drop.address);
}

deployToken().catch((error) => {
  console.error(error);
  process.exit(1);
});

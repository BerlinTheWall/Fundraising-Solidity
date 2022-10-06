const { utils } = require("ethers");

async function main() {
  // Get owner/deployer's wallet address
  const [owner, addr1] = await ethers.getSigners();

  // Get contract that we want to deploy
  const contractFactory = await hre.ethers.getContractFactory("Fundraising");

  // Deploy contract with the correct constructor arguments (goal, minContribute, deadline in secs)
  // 1 ether = 1000000000000000000 wei
  // 1 week = 604800 secs
  const contract = await contractFactory.deploy(
    1000000000000000000n,
    1000000000000000,
    604800
  );

  // Wait for this transaction to be mined
  await contract.deployed();
  const deadline = await contract.getDeadline();
  const goal = await contract.getGoal();
  const admin = await contract.getAdmin();
  const balance = await contract.getBalance();
  console.log(owner.address);
  // Sending 0.0001 ether to contract
  const params = {
    to: contract.address,
    value: ethers.utils.parseUnits("0.001", "ether").toHexString(),
  };
  const txHash = await owner.sendTransaction(params);
  console.log("Transaction done");
  // Get contract info
  console.log("Admin: ", admin);
  console.log("Goal: ", goal);
  console.log("Deadline: ", deadline);
  console.log("Balance: ", balance);
  // Get contract address
  console.log("Contract deployed to:", contract.address);
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });

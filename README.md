# Sample Hardhat Project

This project demonstrates a basic Hardhat use case. It comes with a sample contract, a test for that contract, and a script that deploys that contract.

Try running some of the following tasks:

```shell
npx hardhat help
npx hardhat test
GAS_REPORT=true npx hardhat test
npx hardhat node
npx hardhat run scripts/deploy.ts
```

#### usage
- off-chain
  1.signer : sign-Sign typed data EIP721
  2.relayer: call forwarder contract execute()
- on-chain
  3.forwarder: verify signature / call nft contract
  4.target contract: mintTo


//defender -> relay autotask   :TODO

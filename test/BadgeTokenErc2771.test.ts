//测试正常的erc721
import {expect} from "chai";
import {ethers} from "hardhat";
const { signMetaTxRequest } = require("../src/signRequest");

async function deploy(name:string, ...params:any) {
    const Contract = await ethers.getContractFactory(name);
    return await Contract.deploy(...params).then(f => f.deployed());
  }

  describe("contracts/BadgeTokenERC2771",function (){
    beforeEach(async function(){
        this.forwarderContract = await deploy('MinimalForwarder');
        this.token = await deploy("BadgeTokenERC2771", this.forwarderContract.address);  
        this.accounts = await ethers.getSigners() 
    })

    it("mintTo an NFT with tokenID directly",async function(){
        const sender = this.accounts[1]
        const token = this.token.connect(sender)
        let tokenId = 0;
        const txresponse = await token.mintTo(tokenId)
        const receipt = await txresponse.wait()

        expect(receipt.events[0].event).to.equal('Transfer')
        expect(await token.ownerOf(tokenId)).to.equal(sender.address)
    })

    it("mintTo an NFT with tokenID  via a meta-tx", async function() {
        const signer = this.accounts[2]
        const relayer = this.accounts[3]
        const forwarderContractNew = this.forwarderContract.connect(relayer)
        const token = this.token;

        let tokenId = 0;
        const {signature,request} = await signMetaTxRequest(signer,forwarderContractNew,{
            from:signer.address,
            to:token.address,
            data:token.interface.encodeFunctionData("mintTo",[tokenId])
        })
        console.log('signature,request',signature,request)
        const txresponse = await forwarderContractNew.execute(request,signature)
        const receipt = await txresponse.wait()

        expect(await token.ownerOf(tokenId)).to.be.equal(signer.address)
    })
  })

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/utils/Base64.sol";
import "@openzeppelin/contracts/metatx/ERC2771Context.sol";
import "@openzeppelin/contracts/metatx/MinimalForwarder.sol";

contract BadgeTokenERC2771 is ERC721, ERC2771Context {
    string[1024] internal wordlist=["abandon","ability","able","about","above","absent","absorb","abstract","absurd","abuse","access","accident","account","accuse","achieve","acid","acoustic","acquire","across","act","action","actor","actress","actual","adapt","add","addict","address","adjust","admit","adult","advance","advice","aerobic","affair","afford","afraid","again","age","agent","agree","ahead","aim","air","airport","aisle","alarm","album","alcohol","alert","alien","all","alley","allow","almost","alone","alpha","already","also","alter","always","amateur","amazing","among","amount","amused","analyst","anchor","ancient","anger","angle","angry","animal","ankle","announce","annual","another","answer","antenna","antique","anxiety","any","apart","apology","appear","apple","approve","april","arch","arctic","area","arena","argue","arm","armed","armor","army","around","arrange","arrest"];
    constructor(MinimalForwarder forwarder)
        ERC721("Web3Elite","WE")
        ERC2771Context(address(forwarder))
    {}

    function _msgSender() internal view virtual override(Context,ERC2771Context) returns (address){
        return super._msgSender();
    }
    function _msgData() internal view virtual override(Context, ERC2771Context) returns (bytes calldata) {
        return super._msgData();
    }
    function mintTo(uint256 tokenId) public {
        require(tokenId<1000,"invalid tokenid");
        require(_exists(tokenId)==false,"tokenId already exist");
        _mint(_msgSender(),tokenId);
    }

    function tokenURI(uint256 tokenId) override public view returns (string memory) {
        string[3] memory parts;

        parts[0] = "<svg xmlns='http://www.w3.org/2000/svg' preserveAspectRatio='xMinYMin meet' viewBox='0 0 350 350'><style>.base { fill: white; font-family: serif; font-size: 100px; }</style><rect width='100%' height='100%' fill='darkblue' /><text x='50%' y='200' class='base' text-anchor='middle'>";

        parts[1] = wordlist[tokenId % 100];

        parts[2] = "</text></svg>";

        string memory json = Base64.encode(bytes(string(
            abi.encodePacked(
                "{\"name\":\"WE #", 
                Strings.toString(tokenId), 
                "\",\"description\":\"Web3 Elite Badge by Huoda Education.\",",
                "\"image\": \"data:image/svg+xml;base64,", 
                Base64.encode(bytes(abi.encodePacked(parts[0], parts[1], parts[2]))),     
                "\"}"
                )
            )));
            
        return string(abi.encodePacked("data:application/json;base64,", json));
    }

}
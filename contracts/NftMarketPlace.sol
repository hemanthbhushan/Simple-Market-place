// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";



contract NftMarketPlace is ERC1155,Ownable{

using Counters for Counters.Counter;
Counters.Counter tokenId;

uint public listingFee = 1 ether;
uint public flatFormFee = 1 ether;

  constructor() ERC1155(""){ }


struct NftDetails{
    uint _tokenId;
    address payable  owner;
    address payable seller;
    uint price;
    bool listed;

}


NftDetails[] getRegisteredNfts;

mapping (uint => NftDetails) public  idToNftDetails;

function UpdateListingFee(uint price) external onlyOwner{
    listingFee = price;
}
//if the user want to buy the nft he need to have the registration Nft
//this Nft can be used to acces special function for the users than the normal users

function getDetailsOfTokenId(uint _TokenId) public view returns(NftDetails memory) {
    return idToNftDetails[_TokenId];

}

function createNft() public payable returns(uint _TokenId){
     require(msg.value==listingFee,"enter proper listing fee");
  
   tokenId.increment();
   _TokenId = tokenId.current();

   idToNftDetails[_TokenId] = NftDetails({
       _tokenId:_TokenId,
       owner:payable(msg.sender),
       seller:payable (address(0)),
       price:0,
       listed:false
 });

    getRegisteredNfts.push(idToNftDetails[_TokenId]);
   _mint(msg.sender, _TokenId, 1, "");

   }


function listNftForSale(uint _TokenId,uint _price) public  {
 require(msg.sender==idToNftDetails[_TokenId].owner,"only owner of the Nft Can list the Nft");
 require(idToNftDetails[_TokenId].listed == false,"the token is  listed");

   idToNftDetails[_TokenId].listed = true;
   idToNftDetails[_TokenId].price = _price;
   idToNftDetails[_TokenId].seller = payable (msg.sender);

   safeTransferFrom(msg.sender, owner(), _TokenId, 1,"");
  //  isApprovedForAll(msg.sender,owner());
   uint length = getRegisteredNfts.length;
   for(uint i;i<length;i++){

     if ( getRegisteredNfts[i]._tokenId==_TokenId){
         getRegisteredNfts[i].listed = true;
         getRegisteredNfts[i].price = _price;
         getRegisteredNfts[i].seller =  payable (msg.sender);
         break;
     }


   }
}
function GetRegisteredNfts() public view returns(NftDetails[] memory){
    return getRegisteredNfts;
}

function buyListedNft(uint _TokenId) public payable {
    address seller = idToNftDetails[_TokenId].seller;
 require(msg.sender!=seller,"seller cant buy his own nft");
 require(idToNftDetails[_TokenId].listed == true,"the token is not listed");
    uint _price = idToNftDetails[_TokenId].price;

    require(msg.value == _price+flatFormFee,"price should be equal to the listed price");
     idToNftDetails[_TokenId].seller.transfer(_price);
      payable( owner()).transfer(flatFormFee);
  

     _safeTransferFrom(owner(), msg.sender, _TokenId, 1,"");


 uint length = getRegisteredNfts.length;

 for(uint i;i<length;i++){
     if(getRegisteredNfts[i].seller ==  idToNftDetails[_TokenId].seller ){
         getRegisteredNfts[i] =  getRegisteredNfts[length-1];
         getRegisteredNfts.pop();
         break ;
     }
 }

        
   idToNftDetails[_TokenId] = NftDetails({
       _tokenId:_TokenId,
       owner:payable(msg.sender),
       seller:payable (address(0)),
       price:_price,
       listed:false
 });
 getRegisteredNfts.push(idToNftDetails[_TokenId]);

 
  

   }





     
}






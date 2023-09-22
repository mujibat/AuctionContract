// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";


contract NFT is ERC721, Ownable{

    address nftCon;
    uint totalSupply;

    constructor(uint tokenId) ERC721("DOLNFT", "DNFT"){
        nftCon = msg.sender;
        _mint(msg.sender, tokenId);

    }
    function safeMint(address to, uint256 tokenId) public onlyOwner {
        _safeMint(to, tokenId);
    }

}



contract Auction {

        struct AuctionHouse {
            address owner;
            uint highestBid;
            bool auctionEnd;
            uint auctionDurationTime;
            address[] approvedBidders;
        }

        struct Auctioner{
            uint bidAmount;
            bool paid;
            address auctionbidder;
            
        }

        address administrator;
        uint tokenID;
        IERC721 nftCon;

        constructor(uint ID) {
            nftCon = IERC721(administrator);
            tokenID = ID;
        }

        modifier onlyAdmin() {
            require(msg.sender == administrator, "Only Administrator");
            _;
        }
       
    mapping(address => Auctioner) public _auctioner;
    mapping(uint => AuctionHouse) public _auction;

    function createAuction(uint _id, uint _auctionDurationTime) external {
      AuctionHouse storage auction = _auction[_id];
        auction.auctionDurationTime = _auctionDurationTime + block.timestamp; 
    }

    function placeBid(uint _bidAmount, uint _id) external {
        AuctionHouse storage auction = _auction[_id];
        Auctioner storage auctioner = _auctioner[msg.sender]; 
        require(auction.auctionDurationTime > block.timestamp, "Bid Ended");
        require(auctioner.bidAmount > 0, "amount zero than zero");
        require(auctioner.bidAmount > auction.highestBid, "Bid higher that current bidder");
        auctioner.bidAmount = _bidAmount;
        auction.highestBid = _bidAmount;
        address[] storage approvedBidders = auction.approvedBidders;
        for(uint i=0; i < approvedBidders.length; i++){
            
        }
        approvedBidders.push(msg.sender);
    }

       
        function claimBid(uint _id) external payable{
            AuctionHouse storage auction = _auction[_id];
            Auctioner storage auctioner = _auctioner[msg.sender];
            require(msg.value == auction.highestBid, "Input bid amount");
            require(auction.auctionDurationTime <= block.timestamp, " ");
            nftCon.safeTransferFrom(address(this), auctioner.auctionbidder, tokenID);
             auctioner.paid = true;
            
        }
    
     function endAuction(uint _id) external payable onlyAdmin{
        AuctionHouse storage auction = _auction[_id];
       require(block.timestamp > auction.auctionDurationTime, "Auction Ended");
            auction.auctionEnd = true;
       
    }
}
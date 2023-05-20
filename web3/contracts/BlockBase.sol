// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

contract BlockBase {
//===================STATE VAR

struct Property{
    uint256 id;
    address owner;
    uint256 price;
    string title;
    string category;
    string image;
    string localAddress;
    string description;
    address[] reviewers;
    string[] reviews;
}
uint256 public propertyIndex;
//===================MAPS
mapping(uint256 => Property) private properties;



//===================EVENTS
event PropertyListed(uint256 indexed _id, address indexed _owner,uint256 _price);
event PropertySold(uint256 indexed _id, address indexed _oldOwner, address indexed _newOwner,uint256 price);
event PropertyResold(uint256 indexed _id, address indexed _oldOwner, address indexed _newOwner,uint256 price);

//================ REVIEWSECION
struct Review{
address reviewer;
uint256 productId;
uint256 rating;
string comment;
uint256 likes;
}
struct Product{
uint256 productId;
uint256 totalRating;
uint256 numReviews;
}

uint256 public reviewsCounter;

//===================MAPS
mapping (uint256 => Review[]) private reviews;
mapping (address => uint256[]) private userReviews;
mapping (uint256 => Product) private products;

//==================EVENTS
event ReviewAdded(uint256 indexed productId, address indexed reviewer, uint256 rating, string comment);
event ReviewLiked(uint256 indexed productId, uint256 indexed reviewIndex, address indexed liker, uint256 likes);

    
//===================PROPERTIES FUNCS

function listProperty(address _owner,uint256 _price, string memory _title,string memory _category,string memory _image,string memory _localAddress,string memory _description) external returns(uint256){

    require(_price>0,"Price must be greater than zero.");
     uint256 newPropertyId = propertyIndex++;
     Property storage newProperty = properties[newPropertyId];

     newProperty.id = newPropertyId;
     newProperty.owner = _owner;
     newProperty.price = _price;
     newProperty.title = _title;
     newProperty.category = _category;
     newProperty.image = _image;
     newProperty.localAddress = _localAddress;
     newProperty.description = _description;
     emit PropertyListed(newPropertyId,_owner,_price);
    return newPropertyId;
}





function updateProperty(address _owner, uint256 _id,string memory _title, string memory _category,string memory _image,string memory _localAddress,string memory _description) external returns(uint256){
    Property storage updatedProperty = properties[_id];
    require(updatedProperty.owner==_owner,"you are not owner");
    updatedProperty.title = _title; 
    updatedProperty.category = _category; 
    updatedProperty.image = _image; 
    updatedProperty.localAddress = _localAddress; 
    updatedProperty.description = _description;

return _id;
}

function updatePropertyPrice(address _owner, uint256 _id, uint256 _price) external returns(string memory){
    Property storage updatedProperty = properties[_id];
    require(updatedProperty.owner==_owner,"you are not owner");
    updatedProperty.price = _price; 

return "Property price has been updated";
}


function buyProperty(uint256 _id,address _buyer) external payable {
    uint256 buyerPrice= msg.value;
    Property storage property = properties[_id];
    require(buyerPrice >= property.price,"Insufficient Funds");

    (bool sent,) = payable(property.owner).call{value:buyerPrice}("");
    if(sent){
        address _oldOwner = property.owner;
        property.owner = _buyer;
        emit PropertySold(_id, _oldOwner,_buyer,buyerPrice);
    }
}






function getAllProperties() public view returns(Property[] memory){

    uint256 itemCount = propertyIndex;
    uint256 currentIndex = 0;
    Property[] memory items = new Property[](itemCount);
    for(uint256 i = 0; i < itemCount; i++) {
    uint256 currentId = i + 1;
    Property storage currentItem= properties[currentId];
    items [currentIndex] = currentItem;
    currentIndex += 1;
    }

    return items;
} 


function getSingleProperty(uint256 _id) external view returns(uint256,address,uint256,string memory,string memory,string memory, string memory,string memory){
    Property storage singleProperty = properties[_id];

    return(
        singleProperty.id,
        singleProperty.owner,
        singleProperty.price,
        singleProperty.title,
        singleProperty.category,
        singleProperty.image,
        singleProperty.localAddress,
        singleProperty.description
    );

} 


function getUserProperties(address _user) external view returns(Property[] memory){
    uint256 totalItemCount = propertyIndex;
    uint256 itemCount = 0;
    uint256 currentIndex = 0;
    for(uint256 i = 0; i < totalItemCount; i++){
        if(properties[i+1].owner==_user){
            itemCount +=1;

        }
    }


    Property[] memory items = new Property[](itemCount);
    for(uint256 i = 0; i < totalItemCount; i++) {

        if(properties[i+1].owner==_user){
            itemCount +=1;
            uint256 currentId = i + 1;
            Property storage currentItem= properties[currentId];
            items[currentIndex] = currentItem;
            currentIndex += 1;

        }
    
    }
 return items;
} 

//===================REVIEWS
function addReview() external {}
function getPropertyReviews() external view returns(Review[] memory) {}
function getUserReviews() external view returns(Review[] memory) {}
function likeReview() external {}
function getHighestRatedProperty() external view returns(uint256) {}


}

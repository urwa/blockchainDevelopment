pragma solidity ^0.5.0;

contract Adoption {
    address[16] public adopters;

    function adopt(uint petId) public returns(int) {
        require(petId >= 0 && petId <= 15, "pet Id out of range");

        adopters[petId] = msg.sender;
        return int(petId);
    }

    function getAdopters() public view returns(address[16] memory) {
        return adopters;
    }
}
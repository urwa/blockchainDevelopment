pragma solidity ^0.5.8;

/*
Election contract that allows the owner to issue voting rights
to anybody and also end the election and announce results
*/
contract Election {
    
    struct Candidate {
        string name;
        uint voteCount;
    }
    
    struct Voter {
        bool voted;
        uint vote;
        uint weight;
    }
    
    address public owner;
    string public name;
    mapping(address => Voter) public voters;
    Candidate[] public candidates;
    
    event ElectionResult(string candidateName, uint voteCount);
    
    constructor(string memory _name, string memory candidate1, string memory candidate2) public {
        owner = msg.sender;
        
        name = _name;
        //initialize list of candidates to vote for
        candidates.push(Candidate(candidate1, 0));
        candidates.push(Candidate(candidate2, 0));
    }
    
    function authorize(address voter) public {
        //make sure only owner can authorize voting rights
        require(msg.sender == owner, "Voter not authorized");
        //make sure voter has not already voted
        require(!voters[voter].voted, "Voter has already voted");

        //assign voting rights
        voters[voter].weight = 1;
    }
    
    function vote(uint voteIndex) public {
        //make sure voter has not already voted
        require(!voters[msg.sender].voted, "Voter has already voted");
        
        //record vote
        voters[msg.sender].vote = voteIndex;
        voters[msg.sender].voted = true;
        
        //increase candidate vote count by voter weight
        candidates[voteIndex].voteCount += voters[msg.sender].weight;
    }
    
    function end() public {
        //make sure only owner can end voting
        require(msg.sender == owner, "Only owner can end voting");
        
        //announce each candidates results
        for(uint i = 0; i < candidates.length; i++){
            emit ElectionResult(candidates[i].name, candidates[i].voteCount);
        }
        
        //destroy the contract
        selfdestruct(msg.sender);
    }
}
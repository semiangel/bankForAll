pragma solidity ^0.8.0;

contract Crowdfunding {
    uint public totalAmount;
    uint public interestRate;
    mapping(address => uint) public contributions;
    address payable public loaner;

    constructor() {
        interestRate = 5;
        loaner = payable(msg.sender);
    }

    function join() public payable {
        require(msg.value > 0, "You must contribute funds");
        contributions[msg.sender] += msg.value;
        totalAmount += msg.value;
    }

    function lend(address payable _borrower, uint _amount) public {
        require(msg.sender == loaner, "Only the loaner can lend money");
        require(_amount <= totalAmount, "Insufficient funds");
        require(contributions[_borrower] > 0, "Borrower is not a member");

        _borrower.transfer(_amount);
        totalAmount -= _amount;
    }

    function withdraw() public {
        require(contributions[msg.sender] > 0, "You have not contributed any funds");

        uint amount = contributions[msg.sender] * (100 + interestRate) / 100;
        contributions[msg.sender] = 0;
        totalAmount -= amount;

        payable(msg.sender).transfer(amount);
    }
}

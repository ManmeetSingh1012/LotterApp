//SPDX-License-Identifier:GPL-3.0
pragma solidity >=0.5.0 <0.9.0;

contract Lottery{
    // for players
    address payable[] public players;
    // manager: we 
    address public manager;
    // winner we will select
    address payable public winner;

    constructor(){
        // adress of the persong who is deploying the smart contract
        manager=msg.sender;
    }

    

    receive()  external payable{
        // if fees is paid 2nd line other wise 1 st line message
        require(msg.value==1 ether,"Pay the god damm fees man");
        players.push(payable(msg.sender));
    }
// this will return the balance if you are the manager
    function getBalance() public view returns(uint){
        require(manager==msg.sender,"You are not the manager");
        return address(this).balance;
    }

// genrate random no for declaring winner
    function random() internal view returns(uint)
    {
        return uint(keccak256(abi.encodePacked(block.difficulty,block.timestamp,players.length)));
    }

    function pickWinner() public {
        require(msg.sender==manager,"You are not a manager");
        require(players.length>=3,"Players are less than 3");

        uint r=random();
        uint index = r%players.length;// index for selecting the winner
        winner=players[index];
        winner.transfer(getBalance());
        players = new address payable[](0);
    }

    // tells who is participating in the lottery
    function allPlayers() public view returns(address payable[] memory){
        return  players;
    }

}

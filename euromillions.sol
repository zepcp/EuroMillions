pragma solidity ^0.4.19;

//Decentralized EuroMillions, where the money from the bets is added to the EuroMillions contract 
//until someone guesses the right combination which is randomly generated once a week.
contract euromillions {
	
	//Event writes on log file to enable alert to listeners
	event newDraw(uint nb1, uint nb2, uint nb3, uint nb4, uint nb5, uint star1, uint star2);
	event winner(address account, uint amount);
	
	struct selection {
      uint nb1;
      uint nb2;
      uint nb3;
      uint nb4;
      uint nb5;
	  uint star1;
	  uint star2;
	  uint time;
    }
	
	selection lastDraw;
	
	//Mapping is a dictionary, relating (A => B)
	mapping (address => selection) addressToSelection;

	//Draws new numbers, time to roll!
	function drawNewNumbers () internal {
	    //TO DO - generate random numbers
	    //TO DO - auto invoque weekly
	    lastDraw.nb1 = 10;
        lastDraw.nb2 = 13;
        lastDraw.nb3 = 24;
        lastDraw.nb4 = 32;
        lastDraw.nb5 = 64;
        lastDraw.star1 = 3;
        lastDraw.star2 = 8;
        lastDraw.time = now;

 		//Call event to inform that we have a new draw
 		newDraw(10, 13, 24, 32, 64, 3, 8);
	}

	//pay 0,01 ETH to select your lucky numbers, they are valid for 1 week, stay alert and good luck!
	function play (uint _nb1, uint _nb2, uint _nb3, uint _nb4, uint _nb5, uint _star1, uint _star2) public payable {
	    //Constraints - Require the minimum bet amount (0,01 ETH)
		require (msg.value >= 10000000000000000);

        //Save selection and current time
		addressToSelection[msg.sender].time = now;
		addressToSelection[msg.sender].nb1 = _nb1;
		addressToSelection[msg.sender].nb2 = _nb2;
		addressToSelection[msg.sender].nb3 = _nb3;
		addressToSelection[msg.sender].nb4 = _nb4;
		addressToSelection[msg.sender].nb5 = _nb5;
		addressToSelection[msg.sender].star1 = _star1;
		addressToSelection[msg.sender].star2 = _star2;
	}
	
	//withdraws prize if it's called by the winner of the week, if there are two winners only the first will get the prize
	function withdrawPrize () public {
	    //Constraints - Same Combination
	    require(addressToSelection[msg.sender].nb1 == lastDraw.nb1);
	    require(addressToSelection[msg.sender].nb2 == lastDraw.nb2);
	    require(addressToSelection[msg.sender].nb3 == lastDraw.nb3);
	    require(addressToSelection[msg.sender].nb4 == lastDraw.nb4);
	    require(addressToSelection[msg.sender].nb5 == lastDraw.nb5);
	    require(addressToSelection[msg.sender].star1 == lastDraw.star1);
	    require(addressToSelection[msg.sender].star2 == lastDraw.star2);

        //Constraints - Played before lastDraw, but no more than 1 week before
	    require(addressToSelection[msg.sender].time < lastDraw.time);
	    require(lastDraw.time - addressToSelection[msg.sender].time < 7 days);

        //Send Funds - TO DO - Change 5 for balance of contract
 		msg.sender.transfer(5);
 		
 		//Call event to inform that we have a new winner
 		winner(msg.sender, 5);
	}
	
	//check which numbers were drawn this week
	function numbersDrawn () external view returns(uint, uint, uint, uint, uint, uint, uint, uint) {
	    return (lastDraw.nb1, 
	            lastDraw.nb2, 
	            lastDraw.nb3, 
	            lastDraw.nb4, 
	            lastDraw.nb5, 
	            lastDraw.star1, 
	            lastDraw.star2, 
	            lastDraw.time);
	}
	
	//Check your own numbers and when did you play
    function yourNumbers () external view returns(uint, uint, uint, uint, uint, uint, uint, uint) {
	    return (addressToSelection[msg.sender].nb1, 
	            addressToSelection[msg.sender].nb2, 
	            addressToSelection[msg.sender].nb3,
	            addressToSelection[msg.sender].nb4, 
	            addressToSelection[msg.sender].nb5,
	            addressToSelection[msg.sender].star1, 
	            addressToSelection[msg.sender].star2,
	            addressToSelection[msg.sender].time);
	}

}
pragma solidity ^0.4.11;

/**
 * The JSCTFactory contract does this and that...
 */
contract JSCTFactory {
	JSCTToken[] public tokens;

	event ReleasedToken(address token, address debtor, address seller, uint256 amount, uint8 term, uint8 interest);

	function JSCTFactory () public {

	}

	function ReleaseToken (address _seller, uint256 _amount, uint8 _term, uint8 _interest) public{
		JSCTToken token = new JSCTToken(msg.sender, _seller, _amount, _term, _interest);
		tokens.push(token);
		ReleasedToken(token, msg.sender, _seller, _amount, _term, _interest);
	}

}

/**
 * The JSCTToken contract does this and that...
 */
contract JSCTToken {
	address public debtor;
	address public seller;
	uint256 public amount;
	uint8 public term;
	uint8 public interest;
	uint public releaseDate;
	uint public lastChargeDate;
	bool public closed;


	event Payment(uint256 value);
	event ChargeInterest(uint256 value);

	function JSCTToken (address _debtor, address _seller, uint256 _amount, uint8 _term, uint8 _interest) public {
		debtor = _debtor;
		seller = _seller;
		amount = _amount * 1 ether;
		term = _term;
		interest = _interest;

		releaseDate = now;
		lastChargeDate = releaseDate;
		closed = false;
	}

	function () payable public {
		_pay();
	}

	function pay () payable public {
		_pay();
	}

	function _pay () internal {
		_chargeInterest();
		Payment(msg.value);
		seller.transfer(msg.value);
		amount -= msg.value;
		if (amount <= 0){
			closed = true;
		}


	}

	function _chargeInterest() internal{
		uint256 currentInterest = CalulateInterest();
		if (currentInterest > 0) {
	 	   amount += currentInterest;
	    	lastChargeDate = now;
	    	ChargeInterest(currentInterest);
		}

	}


	function CalulateInterest() public view returns (uint256) {
		uint256 currentInterest = 0;
		uint256 currentTerm = lastChargeDate / 1 minutes;
		uint256 lastTerm = now / 1 minutes;
		uint256 counter = 0;
		while (currentTerm < lastTerm) {
		    currentInterest += (amount + currentInterest) * interest / 100 / 12;
		    currentTerm += 1 minutes;
		    counter += 1;
		}

		return currentInterest;
	}

}

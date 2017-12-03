pragma solidity ^0.4.11;
import "github.com/oraclize/ethereum-api/oraclizeAPI.sol";


contract RatingContract is usingOraclize {
  uint public rating;

  function __callback (bytes32 myid, string result) {
    if(msg.sender != oraclize_cbAddress()) throw;
    rating = parseInt(result, 3);

  }
  function updateRating() payable{
    if (oraclize_getPrice("URL") > this.balance){
      return;
    }
    else{
      //strConcat();// Встроенная функция в библиотеке Ораклайз, это необходимо, т.к. запрос каждый раз приходит на разные address.
      oraclize_query("URL", "json(http://juryev.ru/address.json).result.address.0");
    }
  }
}

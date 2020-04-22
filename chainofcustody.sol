pragma solidity >=0.5.0;

import "./transaction.sol";
import "./safemath.sol";
import "./ownable.sol";

contract ChainOfCustody is Ownable{

    using SafeMath for uint256;
    
    event NewTransaction(uint tracking_number, string purpose);
    
    uint number_of_items = 0;
    address internal forensic_agent;
    uint creation_time; //UNIX Timestamp 
    Case_Info case_info;
    Transaction[] transactions; 
    Data_Copy[] data_copies;
    Evidence[] evidence;
    
    struct Case_Info{
        string case_name;
        uint case_number;
    }
    
    struct Evidence{
        address content_collector;
        uint identifier;
        string reason_obtained;
        string manufacturer;
        string model_number;
        string serial_number;
        string content_description;
    }
    
    struct Data_Copy{ //multiple copies necessary from different tools
        string copy_method;
        uint hash_value; //Data acquisitions
    }
    
    mapping (uint => address) evidence_holder;
    
    modifier only_owner(){
        require(msg.sender == forensic_agent);
        _;
    }
    
}

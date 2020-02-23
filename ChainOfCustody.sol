pragma solidity >=0.5.0;

import "./Transaction.sol";

contract ChainOfCustody{
    
    struct Case_Info{
        string case_name;
        uint case_number;
    }
    
    struct Evidence_Info{
        address content_owner;
        uint item_number;
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
    
    event NewTransaction(uint tracking_number, string purpose);
    
    uint number_of_items = 0;
    address internal forensic_agent;
    uint creation_time; //UNIX Timestamp 
    Case_Info case_info;
    Transaction[] transactions; 
    Data_Copy[] data_copies;
    Evidence_Info[] evidence;
    
    modifier only_owner(){
        require(msg.sender == forensic_agent);
        _;
    }
    
}

contract Case is ChainOfCustody{
    
    constructor(string memory _case_name, uint _case_number) public{
        case_info = Case_Info(_case_name, _case_number);
        forensic_agent = msg.sender;
        creation_time = now;
    }
    
    //Evidence Functions
    
    function log_evidence(address _owner, 
                          string memory _reason, 
                          string memory _manufacturer, 
                          string memory _model_number, 
                          string memory _serial_number, 
                          string memory _content_description) only_owner public{
        evidence.push(Evidence_Info(_owner, 
                                    ++number_of_items, 
                                    _reason, _manufacturer, 
                                    _model_number, 
                                    _serial_number, 
                                    _content_description));
        number_of_items++;
    }
    
    function make_a_copy(string memory _method, uint _hash) only_owner public{
        data_copies.push(Data_Copy(_method, _hash));
    }
    
    //Transactions Functions
    
    function take_out_evidence(string memory _personnel, string memory _purpose) public returns(uint){
        Transaction t = new Transaction();
        evidence_holder[t.get_tracking_number()] = msg.sender;
        t.check_out(_personnel, _purpose);
        transactions.push(t);
        emit NewTransaction(t.get_tracking_number(), _purpose);
        return t.get_tracking_number();
    }
    
    function return_evidence(string memory _personnel, uint _tracking_num) public {
        require(evidence_holder[_tracking_num] == msg.sender);
        for(uint i = 0; i < transactions.length; i++){
            if(transactions[i].get_tracking_number() == _tracking_num){
                transactions[i].reinstate(_personnel);
            }
            break;
        }
    }
    
    //getters
    
    function item_count() public view returns(uint){
        return number_of_items;
    }
    
    function is_closed_transaction(Transaction _t) public view returns(bool){
        return _t.get_status();
    }
    
    function copy_count() public view returns(uint){
        return data_copies.length;
    }
    
    function transaction_count() public view returns(uint){
        return transactions.length;
    }
    
}

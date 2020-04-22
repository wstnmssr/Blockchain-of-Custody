import "./chainofcustody.sol";

contract Case is ChainOfCustody{
    
    constructor(string memory _case_name, uint _case_number) public{
        case_info = Case_Info(_case_name, _case_number);
        forensic_agent = msg.sender;
        creation_time = now;
    }
    
    //Evidence Functions
    
    function log_evidence(address _collector, 
                          string memory _reason, 
                          string memory _manufacturer, 
                          string memory _model_number, 
                          string memory _serial_number, 
                          string memory _content_description) only_owner public{
        evidence.push(Evidence(_collector, 
                                ++number_of_items, 
                                _reason,
                                _manufacturer, 
                                _model_number, 
                                _serial_number, 
                                _content_description));
        number_of_items = number_of_items.add(1);
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

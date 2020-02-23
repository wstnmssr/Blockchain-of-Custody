pragma solidity >=0.5.0;

contract Transaction{
    
    uint tracking_number;
    uint in_time; //UNIX Timestamps
    uint out_time;
    string in_personnel;
    string out_personnel;
    string purpose;

    bool complete = false;
    
    constructor() public {
        tracking_number = uint(keccak256(abi.encodePacked(now, msg.sender)));
    }
    
    function check_out(string calldata _personnel, string calldata _purpose) external {
        out_personnel = _personnel;
        out_time = now;
        purpose = _purpose;
        
    }
    
    function reinstate(string calldata _personnel) external {
        in_personnel = _personnel;
        in_time = now;
        complete = true;
        
    }
    
    function get_tracking_number() external view returns(uint){
        return tracking_number;
    }
    
    function get_status() external view returns(bool){
        return complete;
    }
    
}

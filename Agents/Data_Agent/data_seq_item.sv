class data_seq_item extends uvm_sequence_item;
  
  //---------------------------------------
  //data and control fields
  //---------------------------------------
  bit data_we_o ;
  bit[3:0] data_be_o;
  bit [31:0] data_addr_o ;
  int data_wdata_o ;
  rand int data_rdata_i ; // should be integer or logic 
  //---------------------------------------
  //Utility and Field macros
  //---------------------------------------
  `uvm_object_utils_begin(data_seq_item)
  	`uvm_field_int(data_we_o,UVM_ALL_ON)
  	`uvm_field_int(data_be_o,UVM_ALL_ON)
  	`uvm_field_int(data_addr_o,UVM_ALL_ON)
  	`uvm_field_int(data_wdata_o,UVM_ALL_ON)
  	`uvm_field_int(data_rdata_i,UVM_ALL_ON)	
  `uvm_object_utils_end
  //---------------------------------------
  //Constructor
  //---------------------------------------
  function new(string name = "data_seq_item");
    super.new(name);
  endfunction
  //---------------------------------------
  // printing
  //---------------------------------------
   
  function string convert2string();
    return($sformatf("we : %0d , be : %0d , addr : %0d , wdata : %0d , rdata : %0d  ",data_we_o,data_be_o,data_addr_o,data_wdata_o,data_rdata_i));
  endfunction
  //---------------------------------------
  //Constrains
  //---------------------------------------
  constraint data {
    rdata dist{ –2147483648 := 25 ,  2147483647 := 25 , 0 :=25 , [-2147483647 : -1 ] :/ 12.5 , [1 : 2147483646] :/ 12.5 }; 
  				  }
endclass
  

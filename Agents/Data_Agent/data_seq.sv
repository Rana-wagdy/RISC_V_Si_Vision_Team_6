class data_seq extends uvm_sequence #(data_seq_item);
    `uvm_object_utils(data_seq)    
    data_seq_item req,rsp;
    data_seq_item q [$:2];
    [7:0] data_mem [int];
    //[31:0] data_mem [32];

    
    int num_items;

    function new(string name="data_seq");
        super.new(name);
    endfunction

    virtual task pre_body();
        `uvm_info("Seq", "Starting pre body ", UVM_MEDIUM)
        cfg=data_agent_cfg::type_id::create("cfg");

        if(!uvm_config_db#(data_agent_cfg)::get(m_sequencer, "", "cfg", cfg))
            `uvm_fatal("NOCFG", "No configuration object found");
        
        num_items = cfg.num_items;
        `uvm_info("Seq", "Finished pre body ", UVM_MEDIUM)

    endtask

    virtual task body();

        `uvm_info("Seq", "Starting sequence", UVM_MEDIUM)
    
        item = data_seq_item::type_id::create("item");
        // Load the memory with some important values
        {data_mem[0],data_mem[1],data_mem[2],data_mem[3]} = 32'b0;               // zero
        {data_mem[4],data_mem[5],data_mem[6],data_mem[7]} = {1'b0,31{1'b1}};     // max positive%%%?
        {data_mem[8],data_mem[8],data_mem[10],data_mem[11]} = {1'b1,31{1'b0}};   // max positive


        forever begin

            start_item(req);
            finish_item(req);
            
            
            start_item(rsp);
                rsp.copy(req);
                rsp.rdata = 0;

                if(req.we) begin
                    foreach(req.be[i]) begin
                        if(req.be[i]) begin
                            data_mem[req.addr+i] = req.wdata>>(i*8);
                        end
                    end

                end
                else begin

                    foreach(req.be[i]) begin
                        if(req.be[i]) begin
                            rsp.rdata |= data_mem[req.addr+i]<<(i*8);
                        end
                    end
                end
            finish_item(rsp);
        
        end
        

        `uvm_info("Seq", "Finishing sequence", UVM_MEDIUM)
        
    endtask
endclass
//capture the reqeset 
//put it in a queue
//choose whether to respond now or later
//if the randomized signals the rvalid is high
//the response will be sent to the driver based on the request that should be poped from the queue

module alu(A,B,ALUControl,Result,Z,N,V,C);
    input [31:0] A,B;
    input [2:0] ALUControl;

    output [31:0] Result;
    output Z,N,V,C;

    // decalring the interim wires
    wire [31:0] a_and_b;
    wire [31:0] a_or_b;
    wire [31:0] not_b;

    wire [31:0] mux_1;
    wire [31:0] mux_2;

    wire [31:0] slt;

    wire[31:0] sum;
    wire cout;

    // logic design
    assign a_and_b = A & B;
    assign a_or_b = A | B;
    assign not_b = ~B;
    
    assign {cout, sum} = A + mux_1 + ALUControl[0];
    
    //flags assign
    assign Z =&(~Result); //zero flag
    assign N = Result[31]; //negative flag
    assign C = cout & (~ALUControl[1]); //carry flag
    assign V = (~ALUControl[1]) & (A[31] ^ sum[31]) & (~(A[31] ^ sum[31] ^ ALUControl[0])); //overflow flag

    // ternary operator 
    assign mux_1 = (ALUControl[0]== 1'b0) ? B : not_b;
    
    //zero extension
    assign slt = {31'b0000000000000000000000000000000,{sum[31]}};

    //sum
    assign sum = A + mux_1 + ALUControl[0];
    assign mux_2 = (ALUControl[2:0] == 3'b000) ?
     sum : (ALUControl[2:0] == 3'b001) ?
     sum : (ALUControl[2:0] == 3'b010) ? a_and_b : 
           (ALUControl[2:0] == 3'b011) ? a_or_b :
           (ALUControl[2:0] == 3'b101) ? slt : 32'h00000000;
    
    assign Result = mux_2;
    
endmodule
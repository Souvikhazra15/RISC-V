module alu(A,B,ALUControl,Result);
    input [31:0] A,B;
    input [2:0] ALUControl;

    output [31:0] Result;

    // decalring the interim wires
    wire [31:0] a_and_b;
    wire [31:0] a_or_b;
    wire [31:0] not_b;

    wire [31:0] mux_1;
    wire [31:0] mux_2;

    wire[31:0] sum;

    // logic design
    assign a_and_b = A & B;
    assign a_or_b = A | B;
    assign not_b = ~B;


    // ternary operator 
    assign mux_1 = (ALUControl[0]== 1'b0) ? B : not_b;

    //sum
    assign sum = A + mux_1 + ALUControl[0];
    assign mux_2 = (ALUControl[1:0] == 2'b00) ?
     sum : (ALUControl[1:0] == 2'b01) ?
     sum : (ALUControl[1:0] == 2'b10) ? a_and_b : a_or_b;
    
    assign Result = mux_2;
    
endmodule
`include "cla_design.v"

module testbench;
    reg clk,cin;
    reg [3:0] a,b;

    wire [3:0] s;
    wire cout;

    final_circuit uut(a,b,cin,s,cout,clk);
    initial begin
        $dumpfile("testbench.vcd");
        $dumpvars(0,testbench);

        clk = 0; cin=0; a=4'b0000; b=4'b0000;
        #3 a=4'b1001; b=4'b1101;
        #10;
        $monitor("a=%4b b=%4b \t cout=%b s=%4b",a,b,cout,s);
        a=4'b1010; b=4'b0101;
        #10;
        $monitor("a=%4b b=%4b \t cout=%b s=%4b",a,b,cout,s);
        a=4'b0000; b=4'b0000;
        #12;
        $monitor("a=%4b b=%4b \t cout=%b s=%4b",a,b,cout,s);
        $finish;
    end
    always #5 clk=~clk;
endmodule

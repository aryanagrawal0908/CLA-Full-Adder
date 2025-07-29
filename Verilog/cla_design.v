module dff(d,q,clk);
    input clk;
    input d;
    output reg q;
    always @(posedge clk)
    begin
        q <= d;
    end
endmodule

module cla_adder(a,b,cin,s,cout);
    input [3:0] a,b;
    input cin;

    output [3:0] s;
    output cout;

    wire [3:0] g,p;
    wire c1,c2,c3;
    wire w1,w21,w22,w31,w32,w33,w41,w42,w43,w44;
    
    // Generate and propagate (P/G)
    and g0(g[0],a[0],b[0]);
    and g1(g[1],a[1],b[1]);
    and g2(g[2],a[2],b[2]);
    and g3(g[3],a[3],b[3]);

    xor p0(p[0],a[0],b[0]);
    xor p1(p[1],a[1],b[1]);
    xor p2(p[2],a[2],b[2]);
    xor p3(p[3],a[3],b[3]);

    // Carry Look Ahead (CLA)
    and a1(w1,p[0],cin);
    or o1(c1,g[0],w1);

    and a2(w21,p[1],g[0]);
    and a3(w22,p[1],p[0],cin);
    or o2(c2,g[1],w21,w22);

    and a4(w31,p[2],g[1]);
    and a5(w32,p[2],p[1],g[0]);
    and a6(w33,p[2],p[1],p[0],cin);
    or o3(c3,g[2],w31,w32,w33);

    and a7(w41,p[3],g[2]);
    and a8(w42,p[3],p[2],g[1]);
    and a9(w43,p[3],p[2],p[1],g[0]);
    and a10(w44,p[3],p[2],p[1],p[0],cin);
    or o4(cout,g[3],w41,w42,w43,w44); // Final carry

    // Sum
    xor s0(s[0],p[0],cin);
    xor s1(s[1],p[1],c1);
    xor s2(s[2],p[2],c2);
    xor s3(s[3],p[3],c3);
endmodule

module final_circuit(a,b,cin,s,cout,clk);
    input [3:0] a,b;
    input cin,clk;

    output [3:0] s;
    output cout;

    wire [3:0] amid,bmid;
    wire [3:0] smid;
    wire cmid;

    // For inputs
    dff dff1(a[0],amid[0],clk);
    dff dff2(a[1],amid[1],clk);
    dff dff3(a[2],amid[2],clk);
    dff dff4(a[3],amid[3],clk);

    dff dff5(b[0],bmid[0],clk);
    dff dff6(b[1],bmid[1],clk);
    dff dff7(b[2],bmid[2],clk);
    dff dff8(b[3],bmid[3],clk);

    cla_adder cla(amid,bmid,cin,smid,cmid);

    // For outputs
    dff dff10(smid[0],s[0],clk);
    dff dff11(smid[1],s[1],clk);
    dff dff12(smid[2],s[2],clk);
    dff dff13(smid[3],s[3],clk);

    dff dff9(cmid,cout,clk);
endmodule

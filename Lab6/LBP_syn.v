/////////////////////////////////////////////////////////////
// Created by: Synopsys DC Expert(TM) in wire load mode
// Version   : P-2019.03
// Date      : Sun Oct 16 00:33:23 2022
/////////////////////////////////////////////////////////////


module LBP_DW01_add_0 ( A, B, CI, SUM, CO );
  input [7:0] A;
  input [7:0] B;
  output [7:0] SUM;
  input CI;
  output CO;
  wire   n1;
  wire   [7:1] carry;

  ADDFXL U1_6 ( .A(A[6]), .B(B[6]), .CI(carry[6]), .CO(carry[7]), .S(SUM[6])
         );
  ADDFXL U1_5 ( .A(A[5]), .B(B[5]), .CI(carry[5]), .CO(carry[6]), .S(SUM[5])
         );
  ADDFXL U1_4 ( .A(A[4]), .B(B[4]), .CI(carry[4]), .CO(carry[5]), .S(SUM[4])
         );
  ADDFXL U1_3 ( .A(A[3]), .B(B[3]), .CI(carry[3]), .CO(carry[4]), .S(SUM[3])
         );
  ADDFXL U1_2 ( .A(A[2]), .B(B[2]), .CI(carry[2]), .CO(carry[3]), .S(SUM[2])
         );
  ADDFXL U1_1 ( .A(A[1]), .B(B[1]), .CI(n1), .CO(carry[2]), .S(SUM[1]) );
  XOR3XL U1_7 ( .A(A[7]), .B(B[7]), .C(carry[7]), .Y(SUM[7]) );
  AND2X2 U1 ( .A(B[0]), .B(A[0]), .Y(n1) );
  XOR2XL U2 ( .A(B[0]), .B(A[0]), .Y(SUM[0]) );
endmodule


module LBP_DW01_inc_0 ( A, SUM );
  input [6:0] A;
  output [6:0] SUM;

  wire   [6:2] carry;

  ADDHXL U1_1_5 ( .A(A[5]), .B(carry[5]), .CO(carry[6]), .S(SUM[5]) );
  ADDHXL U1_1_4 ( .A(A[4]), .B(carry[4]), .CO(carry[5]), .S(SUM[4]) );
  ADDHXL U1_1_2 ( .A(A[2]), .B(carry[2]), .CO(carry[3]), .S(SUM[2]) );
  ADDHXL U1_1_3 ( .A(A[3]), .B(carry[3]), .CO(carry[4]), .S(SUM[3]) );
  ADDHXL U1_1_1 ( .A(A[1]), .B(A[0]), .CO(carry[2]), .S(SUM[1]) );
  CLKINVX1 U1 ( .A(A[0]), .Y(SUM[0]) );
  XOR2X1 U2 ( .A(carry[6]), .B(A[6]), .Y(SUM[6]) );
endmodule


module LBP_DW01_inc_1 ( A, SUM );
  input [6:0] A;
  output [6:0] SUM;

  wire   [6:2] carry;

  ADDHXL U1_1_5 ( .A(A[5]), .B(carry[5]), .CO(carry[6]), .S(SUM[5]) );
  ADDHXL U1_1_4 ( .A(A[4]), .B(carry[4]), .CO(carry[5]), .S(SUM[4]) );
  ADDHXL U1_1_2 ( .A(A[2]), .B(carry[2]), .CO(carry[3]), .S(SUM[2]) );
  ADDHXL U1_1_3 ( .A(A[3]), .B(carry[3]), .CO(carry[4]), .S(SUM[3]) );
  ADDHXL U1_1_1 ( .A(A[1]), .B(A[0]), .CO(carry[2]), .S(SUM[1]) );
  CLKINVX1 U1 ( .A(A[0]), .Y(SUM[0]) );
  XOR2X1 U2 ( .A(carry[6]), .B(A[6]), .Y(SUM[6]) );
endmodule


module LBP ( clk, reset, gray_addr, gray_req, gray_ready, gray_data, lbp_addr, 
        lbp_valid, lbp_data, finish );
  output [13:0] gray_addr;
  input [7:0] gray_data;
  output [13:0] lbp_addr;
  output [7:0] lbp_data;
  input clk, reset, gray_ready;
  output gray_req, lbp_valid, finish;
  wire   n390, n391, n392, n393, n394, n395, n396, n397, n398, n399, n400,
         n401, n402, n403, n404, n405, n406, n407, n408, n409, n410, n411,
         \g[1][6] , \g[1][5] , \g[1][4] , \g[1][3] , \g[1][2] , \g[1][1] ,
         \g[1][0] , \g[3][13] , \g[3][12] , \g[3][11] , \g[3][10] , \g[3][9] ,
         \g[3][8] , \g[3][7] , N140, N142, N143, N145, N146, N147, N148, N149,
         N150, N151, N152, N153, N154, N155, N156, N157, N158, N159, N160,
         N161, N162, N172, n13, n14, n16, n17, n18, n19, n20, n21, n22, n23,
         n24, n25, n26, n27, n28, n29, n30, n31, n32, n35, n36, n39, n40, n41,
         n44, n45, n46, n47, n49, n50, n51, n53, n54, n55, n56, n57, n58, n59,
         n60, n62, n63, n64, n65, n66, n67, n68, n69, n70, n71, n72, n73, n74,
         n75, n76, n77, n78, n79, n80, n81, n82, n83, n84, n85, n86, n87, n88,
         n89, n90, n91, n92, n93, n94, n95, n96, n97, n98, n99, n100, n101,
         n102, n103, n104, n105, n106, n107, n108, n109, n110, n111, n112,
         n113, n114, n115, n116, n117, n118, n119, n120, n121, n122, n123,
         n124, n125, n126, n127, n128, n129, n130, n131, n132, n133, n134,
         n135, n136, n137, n138, n139, n140, n141, n142, n143, n144, n145,
         n146, n147, n148, n149, n150, n151, n152, n153, n154, n155, n156,
         n157, n158, n159, n160, n161, n162, n163, n164, n165, n166, n167,
         n168, n169, n171, n243, n244, n245, n246, n247, n248, n249, n251,
         n253, n255, n257, n259, n261, n263, n265, n274, n276, n278, n280,
         n283, n285, n287, n289, n305, n306, n307, n308, n309, n310, n311,
         n312, n313, n314, n315, n316, n317, n318, n319, n320, n321, n322,
         n323, n324, n325, n326, n327, n328, n329, n330, n331, n332, n333,
         n334, n335, n336, n337, n338, n339, n340, n341, n342, n343, n344,
         n345, n346, n347, n348, n349, n350, n351, n352, n353, n354, n355,
         n356, n357, n358, n359, n360, n361, n362, n363, n364, n365, n366,
         n367, n368, n369, n370, n371, n372, n373, n374, n375, n376, n377,
         n378, n379, n380, n381, n382, n383, n384, n385, n386, n387, n388,
         n389;
  wire   [6:0] x_s;
  wire   [6:0] x_p;
  wire   [6:0] y_s;
  wire   [6:0] y_p;
  wire   [2:0] state;
  wire   [2:0] next_state;
  wire   [3:0] g_cnt;
  wire   [13:0] gc_addr;
  wire   [7:0] gc_data;

  LBP_DW01_add_0 add_253 ( .A({lbp_data[7:1], n411}), .B({N153, N152, N151, 
        N150, N149, N148, N147, N146}), .CI(1'b0), .SUM({N161, N160, N159, 
        N158, N157, N156, N155, N154}) );
  LBP_DW01_inc_0 r392 ( .A({\g[3][13] , \g[3][12] , \g[3][11] , \g[3][10] , 
        \g[3][9] , \g[3][8] , \g[3][7] }), .SUM(y_p) );
  LBP_DW01_inc_1 r390 ( .A({\g[1][6] , \g[1][5] , \g[1][4] , \g[1][3] , 
        \g[1][2] , \g[1][1] , \g[1][0] }), .SUM(x_p) );
  EDFFX1 \gc_data_reg[6]  ( .D(gray_data[6]), .E(N162), .CK(clk), .QN(n248) );
  EDFFX1 \gc_data_reg[7]  ( .D(gray_data[7]), .E(N162), .CK(clk), .Q(
        gc_data[7]) );
  DFFRX1 \y_reg[6]  ( .D(n163), .CK(clk), .RN(n333), .Q(\g[3][13] ), .QN(n98)
         );
  DFFSX1 \gc_addr_reg[7]  ( .D(n145), .CK(clk), .SN(n336), .Q(gc_addr[7]), 
        .QN(n90) );
  DFFSX1 \gc_addr_reg[0]  ( .D(n171), .CK(clk), .SN(n333), .Q(gc_addr[0]), 
        .QN(n116) );
  DFFRX1 \gc_addr_reg[9]  ( .D(n147), .CK(clk), .RN(n334), .Q(gc_addr[9]), 
        .QN(n92) );
  DFFRX1 \y_reg[4]  ( .D(n165), .CK(clk), .RN(n333), .Q(\g[3][11] ), .QN(n100)
         );
  DFFRX1 \y_reg[5]  ( .D(n164), .CK(clk), .RN(n333), .Q(\g[3][12] ), .QN(n99)
         );
  EDFFX1 \gc_data_reg[0]  ( .D(gray_data[0]), .E(N162), .CK(clk), .QN(n247) );
  EDFFX1 \gc_data_reg[4]  ( .D(gray_data[4]), .E(N162), .CK(clk), .Q(
        gc_data[4]) );
  EDFFX1 \gc_data_reg[2]  ( .D(gray_data[2]), .E(N162), .CK(clk), .Q(
        gc_data[2]) );
  EDFFX1 \gc_data_reg[1]  ( .D(gray_data[1]), .E(N162), .CK(clk), .Q(
        gc_data[1]) );
  DFFRX1 \g_cnt_reg[3]  ( .D(n152), .CK(clk), .RN(n334), .Q(g_cnt[3]), .QN(n97) );
  EDFFX1 \gc_data_reg[3]  ( .D(gray_data[3]), .E(N162), .CK(clk), .Q(
        gc_data[3]) );
  EDFFX1 \gc_data_reg[5]  ( .D(gray_data[5]), .E(N162), .CK(clk), .Q(
        gc_data[5]) );
  DFFRX1 \gc_addr_reg[13]  ( .D(n151), .CK(clk), .RN(n334), .Q(gc_addr[13]), 
        .QN(n96) );
  DFFRX1 \state_reg[2]  ( .D(next_state[2]), .CK(clk), .RN(n333), .Q(n111), 
        .QN(n245) );
  DFFRX1 \gc_addr_reg[5]  ( .D(n143), .CK(clk), .RN(n335), .Q(gc_addr[5]), 
        .QN(n88) );
  DFFRX1 \gc_addr_reg[6]  ( .D(n144), .CK(clk), .RN(n335), .Q(gc_addr[6]), 
        .QN(n89) );
  DFFRX1 \gc_addr_reg[8]  ( .D(n146), .CK(clk), .RN(n335), .Q(gc_addr[8]), 
        .QN(n91) );
  DFFRX1 \gc_addr_reg[1]  ( .D(n139), .CK(clk), .RN(n335), .Q(gc_addr[1]), 
        .QN(n84) );
  DFFRX1 \gc_addr_reg[10]  ( .D(n148), .CK(clk), .RN(n334), .Q(gc_addr[10]), 
        .QN(n93) );
  DFFRX1 \gc_addr_reg[2]  ( .D(n140), .CK(clk), .RN(n335), .Q(gc_addr[2]), 
        .QN(n85) );
  DFFRX1 \gc_addr_reg[11]  ( .D(n149), .CK(clk), .RN(n334), .Q(gc_addr[11]), 
        .QN(n94) );
  DFFRX1 \gc_addr_reg[3]  ( .D(n141), .CK(clk), .RN(n335), .Q(gc_addr[3]), 
        .QN(n86) );
  DFFRX1 \gc_addr_reg[12]  ( .D(n150), .CK(clk), .RN(n334), .Q(gc_addr[12]), 
        .QN(n95) );
  DFFRX1 \gc_addr_reg[4]  ( .D(n142), .CK(clk), .RN(n335), .Q(gc_addr[4]), 
        .QN(n87) );
  DFFRX1 \y_reg[2]  ( .D(n167), .CK(clk), .RN(n333), .Q(\g[3][9] ), .QN(n102)
         );
  DFFRX1 \x_reg[2]  ( .D(n160), .CK(clk), .RN(n333), .Q(\g[1][2] ), .QN(n108)
         );
  DFFRX1 \y_reg[3]  ( .D(n166), .CK(clk), .RN(n333), .Q(\g[3][10] ), .QN(n101)
         );
  DFFRX2 \state_reg[0]  ( .D(next_state[0]), .CK(clk), .RN(n333), .Q(state[0])
         );
  DFFRX1 \y_reg[1]  ( .D(n168), .CK(clk), .RN(n333), .Q(\g[3][8] ), .QN(n103)
         );
  DFFRX1 \x_reg[1]  ( .D(n162), .CK(clk), .RN(n333), .Q(\g[1][1] ), .QN(n109)
         );
  DFFRX1 \g_cnt_reg[1]  ( .D(n154), .CK(clk), .RN(n334), .Q(g_cnt[1]), .QN(
        n114) );
  DFFRX2 \g_cnt_reg[2]  ( .D(n153), .CK(clk), .RN(n334), .Q(g_cnt[2]), .QN(
        n112) );
  DFFRX2 \g_cnt_reg[0]  ( .D(n155), .CK(clk), .RN(n334), .Q(g_cnt[0]), .QN(
        n113) );
  DFFRX1 \x_reg[6]  ( .D(n156), .CK(clk), .RN(n334), .Q(\g[1][6] ), .QN(n104)
         );
  DFFRX1 \x_reg[4]  ( .D(n158), .CK(clk), .RN(n334), .Q(\g[1][4] ), .QN(n106)
         );
  DFFRX1 \x_reg[5]  ( .D(n157), .CK(clk), .RN(n334), .Q(\g[1][5] ), .QN(n105)
         );
  DFFRX1 \x_reg[3]  ( .D(n159), .CK(clk), .RN(n333), .Q(\g[1][3] ), .QN(n107)
         );
  DFFSX1 \y_reg[0]  ( .D(n169), .CK(clk), .SN(n334), .Q(\g[3][7] ), .QN(n110)
         );
  DFFSX1 \x_reg[0]  ( .D(n161), .CK(clk), .SN(n333), .Q(\g[1][0] ), .QN(n115)
         );
  DFFRX1 \state_reg[1]  ( .D(n378), .CK(clk), .RN(n333), .Q(state[1]), .QN(
        n246) );
  DFFRX1 \lbp_data_reg[0]  ( .D(n124), .CK(clk), .RN(n336), .Q(n411), .QN(n69)
         );
  DFFRX1 \lbp_data_reg[6]  ( .D(n118), .CK(clk), .RN(n335), .Q(n405), .QN(n63)
         );
  DFFRX1 \lbp_data_reg[5]  ( .D(n119), .CK(clk), .RN(n336), .Q(n406), .QN(n64)
         );
  DFFRX1 \lbp_data_reg[4]  ( .D(n120), .CK(clk), .RN(n334), .Q(n407), .QN(n65)
         );
  DFFRX1 \lbp_data_reg[3]  ( .D(n121), .CK(clk), .RN(n333), .Q(n408), .QN(n66)
         );
  DFFRX1 \lbp_data_reg[2]  ( .D(n122), .CK(clk), .RN(n336), .Q(n409), .QN(n67)
         );
  DFFRX1 \lbp_data_reg[7]  ( .D(n117), .CK(clk), .RN(n335), .Q(n404), .QN(n62)
         );
  DFFRX1 \gray_addr_reg[0]  ( .D(n125), .CK(clk), .RN(n336), .Q(n403), .QN(n70) );
  DFFRX1 \gray_addr_reg[1]  ( .D(n126), .CK(clk), .RN(n336), .Q(n402), .QN(n71) );
  DFFRX1 \gray_addr_reg[2]  ( .D(n127), .CK(clk), .RN(n336), .Q(n401), .QN(n72) );
  DFFRX1 \gray_addr_reg[3]  ( .D(n128), .CK(clk), .RN(n336), .Q(n400), .QN(n73) );
  DFFRX1 \gray_addr_reg[4]  ( .D(n129), .CK(clk), .RN(n336), .Q(n399), .QN(n74) );
  DFFRX1 \gray_addr_reg[5]  ( .D(n130), .CK(clk), .RN(n336), .Q(n398), .QN(n75) );
  DFFRX1 \gray_addr_reg[6]  ( .D(n131), .CK(clk), .RN(n336), .Q(n397), .QN(n76) );
  DFFRX1 finish_reg ( .D(n244), .CK(clk), .RN(n336), .QN(n289) );
  DFFRX1 lbp_valid_reg ( .D(n338), .CK(clk), .RN(n372), .QN(n287) );
  DFFRX1 gray_req_reg ( .D(N172), .CK(clk), .RN(n372), .QN(n285) );
  EDFFX1 \lbp_addr_reg[0]  ( .D(gc_addr[0]), .E(n337), .CK(clk), .QN(n283) );
  DFFRX1 \lbp_data_reg[1]  ( .D(n123), .CK(clk), .RN(n336), .Q(n410), .QN(n68)
         );
  EDFFX1 \lbp_addr_reg[1]  ( .D(gc_addr[1]), .E(n337), .CK(clk), .QN(n280) );
  EDFFX1 \lbp_addr_reg[2]  ( .D(gc_addr[2]), .E(n338), .CK(clk), .QN(n278) );
  EDFFX1 \lbp_addr_reg[3]  ( .D(gc_addr[3]), .E(n338), .CK(clk), .QN(n276) );
  EDFFX1 \lbp_addr_reg[6]  ( .D(gc_addr[6]), .E(n337), .CK(clk), .QN(n274) );
  DFFRX1 \gray_addr_reg[7]  ( .D(n132), .CK(clk), .RN(n336), .Q(n396), .QN(n77) );
  DFFRX1 \gray_addr_reg[8]  ( .D(n133), .CK(clk), .RN(n336), .Q(n395), .QN(n78) );
  DFFRX1 \gray_addr_reg[9]  ( .D(n134), .CK(clk), .RN(n335), .Q(n394), .QN(n79) );
  DFFRX1 \gray_addr_reg[10]  ( .D(n135), .CK(clk), .RN(n335), .Q(n393), .QN(
        n80) );
  DFFRX1 \gray_addr_reg[11]  ( .D(n136), .CK(clk), .RN(n335), .Q(n392), .QN(
        n81) );
  DFFRX1 \gray_addr_reg[12]  ( .D(n137), .CK(clk), .RN(n335), .Q(n391), .QN(
        n82) );
  DFFRX1 \gray_addr_reg[13]  ( .D(n138), .CK(clk), .RN(n335), .Q(n390), .QN(
        n83) );
  EDFFX1 \lbp_addr_reg[4]  ( .D(gc_addr[4]), .E(n338), .CK(clk), .QN(n265) );
  EDFFX1 \lbp_addr_reg[12]  ( .D(gc_addr[12]), .E(n337), .CK(clk), .QN(n263)
         );
  EDFFX1 \lbp_addr_reg[5]  ( .D(gc_addr[5]), .E(n338), .CK(clk), .QN(n261) );
  EDFFX1 \lbp_addr_reg[13]  ( .D(gc_addr[13]), .E(n337), .CK(clk), .QN(n259)
         );
  EDFFX1 \lbp_addr_reg[7]  ( .D(gc_addr[7]), .E(n338), .CK(clk), .QN(n257) );
  EDFFX1 \lbp_addr_reg[8]  ( .D(gc_addr[8]), .E(n338), .CK(clk), .QN(n255) );
  EDFFX1 \lbp_addr_reg[9]  ( .D(gc_addr[9]), .E(n338), .CK(clk), .QN(n253) );
  EDFFX1 \lbp_addr_reg[10]  ( .D(gc_addr[10]), .E(n338), .CK(clk), .QN(n251)
         );
  EDFFX1 \lbp_addr_reg[11]  ( .D(gc_addr[11]), .E(n338), .CK(clk), .QN(n249)
         );
  AND2X2 U193 ( .A(next_state[0]), .B(n51), .Y(n305) );
  INVX12 U194 ( .A(n249), .Y(lbp_addr[11]) );
  INVX12 U195 ( .A(n251), .Y(lbp_addr[10]) );
  INVX12 U196 ( .A(n253), .Y(lbp_addr[9]) );
  INVX12 U197 ( .A(n255), .Y(lbp_addr[8]) );
  INVX12 U198 ( .A(n257), .Y(lbp_addr[7]) );
  INVX12 U199 ( .A(n259), .Y(lbp_addr[13]) );
  INVX12 U200 ( .A(n261), .Y(lbp_addr[5]) );
  INVX12 U201 ( .A(n263), .Y(lbp_addr[12]) );
  INVX12 U202 ( .A(n265), .Y(lbp_addr[4]) );
  BUFX12 U203 ( .A(n390), .Y(gray_addr[13]) );
  BUFX12 U204 ( .A(n391), .Y(gray_addr[12]) );
  BUFX12 U205 ( .A(n392), .Y(gray_addr[11]) );
  BUFX12 U206 ( .A(n393), .Y(gray_addr[10]) );
  BUFX12 U207 ( .A(n394), .Y(gray_addr[9]) );
  BUFX12 U208 ( .A(n395), .Y(gray_addr[8]) );
  BUFX12 U209 ( .A(n396), .Y(gray_addr[7]) );
  NOR2BX2 U210 ( .AN(n307), .B(n331), .Y(n316) );
  INVX12 U211 ( .A(n274), .Y(lbp_addr[6]) );
  INVX12 U212 ( .A(n276), .Y(lbp_addr[3]) );
  NOR2BX2 U213 ( .AN(n320), .B(n112), .Y(n327) );
  OAI32X4 U214 ( .A0(n331), .A1(g_cnt[2]), .A2(n114), .B0(g_cnt[1]), .B1(n308), 
        .Y(n315) );
  INVX12 U215 ( .A(n278), .Y(lbp_addr[2]) );
  INVX12 U216 ( .A(n280), .Y(lbp_addr[1]) );
  NOR2BX2 U217 ( .AN(n319), .B(g_cnt[2]), .Y(n328) );
  BUFX12 U218 ( .A(n410), .Y(lbp_data[1]) );
  OAI32X4 U219 ( .A0(n331), .A1(g_cnt[1]), .A2(n112), .B0(n308), .B1(n114), 
        .Y(n317) );
  INVX12 U220 ( .A(n283), .Y(lbp_addr[0]) );
  INVX12 U221 ( .A(n285), .Y(gray_req) );
  INVX12 U222 ( .A(n287), .Y(lbp_valid) );
  INVX12 U223 ( .A(n289), .Y(finish) );
  BUFX12 U224 ( .A(n397), .Y(gray_addr[6]) );
  BUFX12 U225 ( .A(n398), .Y(gray_addr[5]) );
  BUFX12 U226 ( .A(n399), .Y(gray_addr[4]) );
  BUFX12 U227 ( .A(n400), .Y(gray_addr[3]) );
  BUFX12 U228 ( .A(n401), .Y(gray_addr[2]) );
  BUFX12 U229 ( .A(n402), .Y(gray_addr[1]) );
  BUFX12 U230 ( .A(n403), .Y(gray_addr[0]) );
  BUFX12 U231 ( .A(n404), .Y(lbp_data[7]) );
  BUFX12 U232 ( .A(n409), .Y(lbp_data[2]) );
  BUFX12 U233 ( .A(n408), .Y(lbp_data[3]) );
  BUFX12 U234 ( .A(n407), .Y(lbp_data[4]) );
  BUFX12 U235 ( .A(n406), .Y(lbp_data[5]) );
  BUFX12 U236 ( .A(n405), .Y(lbp_data[6]) );
  BUFX12 U237 ( .A(n411), .Y(lbp_data[0]) );
  OAI22X2 U238 ( .A0(n320), .A1(n112), .B0(g_cnt[2]), .B1(n319), .Y(n329) );
  INVX3 U239 ( .A(next_state[0]), .Y(n375) );
  INVX1 U240 ( .A(n32), .Y(n374) );
  NAND2X1 U241 ( .A(n378), .B(n375), .Y(n32) );
  NAND2BX1 U242 ( .AN(n312), .B(n18), .Y(n21) );
  NAND2BXL U243 ( .AN(n313), .B(n18), .Y(n22) );
  NAND2BXL U244 ( .AN(n314), .B(n18), .Y(n23) );
  NAND2BXL U245 ( .AN(n318), .B(n18), .Y(n24) );
  NAND2BXL U246 ( .AN(n321), .B(n18), .Y(n25) );
  NAND2BXL U247 ( .AN(n322), .B(n18), .Y(n26) );
  NAND2BXL U248 ( .AN(n323), .B(n18), .Y(n27) );
  NAND2BXL U249 ( .AN(n324), .B(n18), .Y(n28) );
  NAND2BXL U250 ( .AN(n325), .B(n18), .Y(n29) );
  NAND2BXL U251 ( .AN(n326), .B(n18), .Y(n30) );
  NAND2BXL U252 ( .AN(n330), .B(n18), .Y(n31) );
  NAND2BXL U253 ( .AN(n309), .B(n18), .Y(n17) );
  NAND2BXL U254 ( .AN(n310), .B(n18), .Y(n19) );
  NAND2BXL U255 ( .AN(n311), .B(n18), .Y(n20) );
  OAI211XL U256 ( .A0(n383), .A1(g_cnt[0]), .B0(n39), .C0(n374), .Y(n41) );
  NAND3XL U257 ( .A(n374), .B(g_cnt[2]), .C(n380), .Y(n36) );
  CLKINVX1 U258 ( .A(reset), .Y(n372) );
  NOR2BX4 U259 ( .AN(n332), .B(n32), .Y(n18) );
  INVX3 U260 ( .A(n341), .Y(n340) );
  NAND2X1 U261 ( .A(n340), .B(n32), .Y(N172) );
  INVX3 U262 ( .A(n341), .Y(n339) );
  NOR2BX1 U263 ( .AN(n337), .B(n373), .Y(n45) );
  CLKBUFX3 U264 ( .A(n243), .Y(n337) );
  CLKBUFX3 U265 ( .A(n305), .Y(n341) );
  CLKBUFX3 U266 ( .A(n243), .Y(n338) );
  INVX3 U267 ( .A(n14), .Y(n376) );
  NOR2X1 U268 ( .A(n51), .B(n375), .Y(n243) );
  INVX3 U269 ( .A(n46), .Y(n373) );
  NAND3BX1 U270 ( .AN(N143), .B(n306), .C(n382), .Y(n384) );
  NAND3X1 U271 ( .A(n306), .B(n382), .C(N143), .Y(n389) );
  CLKINVX1 U272 ( .A(N142), .Y(n381) );
  CLKINVX1 U273 ( .A(N145), .Y(n382) );
  NAND2X1 U274 ( .A(n113), .B(n381), .Y(n386) );
  NOR2X1 U275 ( .A(n385), .B(n384), .Y(N146) );
  NAND2X1 U276 ( .A(N142), .B(n113), .Y(n388) );
  CLKINVX1 U277 ( .A(n308), .Y(n331) );
  CLKINVX1 U278 ( .A(n51), .Y(n378) );
  NAND2X1 U279 ( .A(g_cnt[0]), .B(n383), .Y(n39) );
  CLKINVX1 U280 ( .A(n44), .Y(n379) );
  AO21X1 U281 ( .A0(n377), .A1(n379), .B0(n244), .Y(next_state[2]) );
  CLKBUFX3 U282 ( .A(n372), .Y(n336) );
  CLKBUFX3 U283 ( .A(n372), .Y(n335) );
  CLKBUFX3 U284 ( .A(n372), .Y(n334) );
  CLKBUFX3 U285 ( .A(n372), .Y(n333) );
  OAI211X1 U286 ( .A0(state[0]), .A1(N140), .B0(n245), .C0(state[1]), .Y(n14)
         );
  CLKINVX1 U287 ( .A(gray_data[7]), .Y(n371) );
  NOR2X2 U288 ( .A(n14), .B(state[0]), .Y(n13) );
  OAI2BB2XL U289 ( .B0(n62), .B1(n376), .A0N(N161), .A1N(n13), .Y(n117) );
  NOR2X1 U290 ( .A(n389), .B(n388), .Y(N153) );
  OAI2BB2XL U291 ( .B0(n63), .B1(n376), .A0N(N160), .A1N(n13), .Y(n118) );
  OAI2BB2XL U292 ( .B0(n64), .B1(n376), .A0N(N159), .A1N(n13), .Y(n119) );
  OAI2BB2XL U293 ( .B0(n65), .B1(n376), .A0N(N158), .A1N(n13), .Y(n120) );
  OAI2BB2XL U294 ( .B0(n66), .B1(n376), .A0N(N157), .A1N(n13), .Y(n121) );
  OAI2BB2XL U295 ( .B0(n67), .B1(n376), .A0N(N156), .A1N(n13), .Y(n122) );
  OAI2BB2XL U296 ( .B0(n68), .B1(n376), .A0N(N155), .A1N(n13), .Y(n123) );
  OAI2BB2XL U297 ( .B0(n69), .B1(n376), .A0N(N154), .A1N(n13), .Y(n124) );
  CLKINVX1 U298 ( .A(gray_data[5]), .Y(n370) );
  CLKINVX1 U299 ( .A(gray_data[3]), .Y(n369) );
  CLKINVX1 U300 ( .A(gray_data[1]), .Y(n368) );
  OAI32X1 U301 ( .A0(n54), .A1(state[0]), .A2(n111), .B0(n377), .B1(n44), .Y(
        next_state[0]) );
  AOI32X1 U302 ( .A0(n112), .A1(n113), .A2(n60), .B0(gray_ready), .B1(n246), 
        .Y(n54) );
  NOR3X1 U303 ( .A(n383), .B(n97), .C(n246), .Y(n60) );
  OAI221XL U304 ( .A0(n115), .A1(n339), .B0(n70), .B1(n332), .C0(n17), .Y(n125) );
  OAI221XL U305 ( .A0(n109), .A1(n339), .B0(n71), .B1(n332), .C0(n19), .Y(n126) );
  OAI221XL U306 ( .A0(n108), .A1(n339), .B0(n72), .B1(n332), .C0(n20), .Y(n127) );
  OAI221XL U307 ( .A0(n107), .A1(n340), .B0(n73), .B1(n332), .C0(n21), .Y(n128) );
  OAI221XL U308 ( .A0(n106), .A1(n340), .B0(n74), .B1(n332), .C0(n22), .Y(n129) );
  OAI221XL U309 ( .A0(n105), .A1(n340), .B0(n75), .B1(n332), .C0(n23), .Y(n130) );
  OAI221XL U310 ( .A0(n104), .A1(n340), .B0(n76), .B1(n332), .C0(n24), .Y(n131) );
  OAI221XL U311 ( .A0(n110), .A1(n340), .B0(n77), .B1(n332), .C0(n25), .Y(n132) );
  OAI221XL U312 ( .A0(n103), .A1(n340), .B0(n78), .B1(n332), .C0(n26), .Y(n133) );
  OAI221XL U313 ( .A0(n102), .A1(n340), .B0(n79), .B1(n332), .C0(n27), .Y(n134) );
  OAI221XL U314 ( .A0(n101), .A1(n340), .B0(n80), .B1(n332), .C0(n28), .Y(n135) );
  OAI221XL U315 ( .A0(n100), .A1(n340), .B0(n81), .B1(n332), .C0(n29), .Y(n136) );
  OAI221XL U316 ( .A0(n99), .A1(n340), .B0(n82), .B1(n332), .C0(n30), .Y(n137)
         );
  OAI221XL U317 ( .A0(n98), .A1(n340), .B0(n83), .B1(n332), .C0(n31), .Y(n138)
         );
  NAND4X1 U318 ( .A(n115), .B(n337), .C(n49), .D(n50), .Y(n46) );
  NOR2X1 U319 ( .A(n108), .B(n109), .Y(n49) );
  NOR4X1 U320 ( .A(n104), .B(n105), .C(n106), .D(n107), .Y(n50) );
  NOR2X1 U321 ( .A(n379), .B(n35), .Y(n152) );
  XNOR2X1 U322 ( .A(n97), .B(n36), .Y(n35) );
  CLKINVX1 U323 ( .A(n39), .Y(n380) );
  OAI32X1 U324 ( .A0(n39), .A1(g_cnt[2]), .A2(n32), .B0(n112), .B1(n40), .Y(
        n153) );
  AOI2BB2X1 U325 ( .B0(n374), .B1(n39), .A0N(n374), .A1N(n379), .Y(n40) );
  OAI2BB2XL U326 ( .B0(n110), .B1(n373), .A0N(y_p[0]), .A1N(n373), .Y(n169) );
  OAI2BB2XL U327 ( .B0(n107), .B1(n337), .A0N(x_p[3]), .A1N(n45), .Y(n159) );
  OAI2BB2XL U328 ( .B0(n106), .B1(n337), .A0N(x_p[4]), .A1N(n45), .Y(n158) );
  OAI2BB2XL U329 ( .B0(n105), .B1(n337), .A0N(x_p[5]), .A1N(n45), .Y(n157) );
  OAI2BB2XL U330 ( .B0(n104), .B1(n337), .A0N(x_p[6]), .A1N(n45), .Y(n156) );
  OAI2BB2XL U331 ( .B0(n109), .B1(n337), .A0N(x_p[1]), .A1N(n45), .Y(n162) );
  OAI2BB2XL U332 ( .B0(n108), .B1(n337), .A0N(x_p[2]), .A1N(n45), .Y(n160) );
  OAI2BB2XL U333 ( .B0(n98), .B1(n373), .A0N(y_p[6]), .A1N(n373), .Y(n163) );
  OAI2BB2XL U334 ( .B0(n99), .B1(n373), .A0N(y_p[5]), .A1N(n373), .Y(n164) );
  OAI2BB2XL U335 ( .B0(n100), .B1(n373), .A0N(y_p[4]), .A1N(n373), .Y(n165) );
  OAI2BB2XL U336 ( .B0(n101), .B1(n373), .A0N(y_p[3]), .A1N(n373), .Y(n166) );
  OAI2BB2XL U337 ( .B0(n102), .B1(n373), .A0N(y_p[2]), .A1N(n373), .Y(n167) );
  OAI2BB2XL U338 ( .B0(n103), .B1(n373), .A0N(y_p[1]), .A1N(n373), .Y(n168) );
  CLKBUFX3 U339 ( .A(n16), .Y(n332) );
  OAI2BB1X1 U340 ( .A0N(n374), .A1N(n97), .B0(n340), .Y(n16) );
  OAI32X1 U341 ( .A0(n374), .A1(n113), .A2(n379), .B0(g_cnt[0]), .B1(n32), .Y(
        n155) );
  OAI211X1 U342 ( .A0(n115), .A1(n337), .B0(n46), .C0(n47), .Y(n161) );
  NAND2X1 U343 ( .A(x_p[0]), .B(n337), .Y(n47) );
  OAI31XL U344 ( .A0(n374), .A1(n114), .A2(n379), .B0(n41), .Y(n154) );
  OAI22XL U345 ( .A0(n116), .A1(n341), .B0(n115), .B1(n339), .Y(n171) );
  OAI22XL U346 ( .A0(n90), .A1(n341), .B0(n110), .B1(n339), .Y(n145) );
  OAI22XL U347 ( .A0(n86), .A1(n341), .B0(n107), .B1(n339), .Y(n141) );
  OAI22XL U348 ( .A0(n87), .A1(n341), .B0(n106), .B1(n339), .Y(n142) );
  OAI22XL U349 ( .A0(n88), .A1(n341), .B0(n105), .B1(n339), .Y(n143) );
  OAI22XL U350 ( .A0(n89), .A1(n341), .B0(n104), .B1(n339), .Y(n144) );
  OAI22XL U351 ( .A0(n84), .A1(n341), .B0(n109), .B1(n340), .Y(n139) );
  OAI22XL U352 ( .A0(n85), .A1(n341), .B0(n108), .B1(n340), .Y(n140) );
  OAI22XL U353 ( .A0(n91), .A1(n305), .B0(n103), .B1(n339), .Y(n146) );
  OAI22XL U354 ( .A0(n92), .A1(n305), .B0(n102), .B1(n339), .Y(n147) );
  OAI22XL U355 ( .A0(n93), .A1(n305), .B0(n101), .B1(n339), .Y(n148) );
  OAI22XL U356 ( .A0(n94), .A1(n305), .B0(n100), .B1(n339), .Y(n149) );
  OAI22XL U357 ( .A0(n95), .A1(n305), .B0(n99), .B1(n339), .Y(n150) );
  OAI22XL U358 ( .A0(n96), .A1(n305), .B0(n98), .B1(n339), .Y(n151) );
  NAND2X1 U359 ( .A(g_cnt[0]), .B(n381), .Y(n385) );
  AOI21X1 U360 ( .A0(n353), .A1(g_cnt[3]), .B0(N145), .Y(n306) );
  NOR2X1 U361 ( .A(n386), .B(n384), .Y(N147) );
  NOR2X1 U362 ( .A(n387), .B(n384), .Y(N148) );
  NOR2X1 U363 ( .A(n388), .B(n384), .Y(N149) );
  NOR2X1 U364 ( .A(n389), .B(n385), .Y(N150) );
  NOR2X1 U365 ( .A(n389), .B(n386), .Y(N151) );
  NOR2X1 U366 ( .A(n389), .B(n387), .Y(N152) );
  NAND2X1 U367 ( .A(N142), .B(g_cnt[0]), .Y(n387) );
  NOR4X1 U368 ( .A(n84), .B(n85), .C(n86), .D(n87), .Y(n59) );
  NAND3X1 U369 ( .A(state[0]), .B(n245), .C(state[1]), .Y(n44) );
  CLKINVX1 U370 ( .A(n114), .Y(n383) );
  NAND3BX1 U371 ( .AN(n96), .B(n90), .C(n116), .Y(n56) );
  CLKINVX1 U372 ( .A(n55), .Y(n377) );
  NAND4BX1 U373 ( .AN(n56), .B(n57), .C(n58), .D(n59), .Y(n55) );
  NOR3X1 U374 ( .A(n91), .B(n88), .C(n89), .Y(n58) );
  NOR4X1 U375 ( .A(n92), .B(n93), .C(n94), .D(n95), .Y(n57) );
  NAND2X1 U376 ( .A(n53), .B(n245), .Y(n51) );
  XOR2X1 U377 ( .A(state[1]), .B(state[0]), .Y(n53) );
  AND3X2 U378 ( .A(state[0]), .B(n246), .C(n245), .Y(N162) );
  NOR3X1 U379 ( .A(state[0]), .B(state[1]), .C(n245), .Y(n244) );
  XOR2X1 U380 ( .A(g_cnt[0]), .B(g_cnt[2]), .Y(n308) );
  XOR2X1 U381 ( .A(n114), .B(g_cnt[2]), .Y(n307) );
  AOI222XL U382 ( .A0(x_p[0]), .A1(n317), .B0(\g[1][0] ), .B1(n316), .C0(n115), 
        .C1(n315), .Y(n309) );
  AOI222XL U383 ( .A0(x_p[1]), .A1(n317), .B0(\g[1][1] ), .B1(n316), .C0(
        x_s[1]), .C1(n315), .Y(n310) );
  AOI222XL U384 ( .A0(x_p[2]), .A1(n317), .B0(\g[1][2] ), .B1(n316), .C0(
        x_s[2]), .C1(n315), .Y(n311) );
  AOI222XL U385 ( .A0(x_p[3]), .A1(n317), .B0(\g[1][3] ), .B1(n316), .C0(
        x_s[3]), .C1(n315), .Y(n312) );
  AOI222XL U386 ( .A0(x_p[4]), .A1(n317), .B0(\g[1][4] ), .B1(n316), .C0(
        x_s[4]), .C1(n315), .Y(n313) );
  AOI222XL U387 ( .A0(x_p[5]), .A1(n317), .B0(\g[1][5] ), .B1(n316), .C0(
        x_s[5]), .C1(n315), .Y(n314) );
  AOI222XL U388 ( .A0(x_p[6]), .A1(n317), .B0(\g[1][6] ), .B1(n316), .C0(
        x_s[6]), .C1(n315), .Y(n318) );
  NAND2BX1 U389 ( .AN(g_cnt[0]), .B(n114), .Y(n320) );
  NAND2X1 U390 ( .A(g_cnt[1]), .B(g_cnt[0]), .Y(n319) );
  AOI222XL U391 ( .A0(\g[3][7] ), .A1(n329), .B0(n110), .B1(n328), .C0(y_p[0]), 
        .C1(n327), .Y(n321) );
  AOI222XL U392 ( .A0(\g[3][8] ), .A1(n329), .B0(y_s[1]), .B1(n328), .C0(
        y_p[1]), .C1(n327), .Y(n322) );
  AOI222XL U393 ( .A0(\g[3][9] ), .A1(n329), .B0(y_s[2]), .B1(n328), .C0(
        y_p[2]), .C1(n327), .Y(n323) );
  AOI222XL U394 ( .A0(\g[3][10] ), .A1(n329), .B0(y_s[3]), .B1(n328), .C0(
        y_p[3]), .C1(n327), .Y(n324) );
  AOI222XL U395 ( .A0(\g[3][11] ), .A1(n329), .B0(y_s[4]), .B1(n328), .C0(
        y_p[4]), .C1(n327), .Y(n325) );
  AOI222XL U396 ( .A0(\g[3][12] ), .A1(n329), .B0(y_s[5]), .B1(n328), .C0(
        y_p[5]), .C1(n327), .Y(n326) );
  AOI222XL U397 ( .A0(\g[3][13] ), .A1(n329), .B0(y_s[6]), .B1(n328), .C0(
        y_p[6]), .C1(n327), .Y(n330) );
  NAND2BX1 U398 ( .AN(\g[1][1] ), .B(n115), .Y(n342) );
  OAI2BB1X1 U399 ( .A0N(\g[1][0] ), .A1N(\g[1][1] ), .B0(n342), .Y(x_s[1]) );
  OR2X1 U400 ( .A(n342), .B(\g[1][2] ), .Y(n343) );
  OAI2BB1X1 U401 ( .A0N(n342), .A1N(\g[1][2] ), .B0(n343), .Y(x_s[2]) );
  NOR2X1 U402 ( .A(n343), .B(\g[1][3] ), .Y(n344) );
  AO21X1 U403 ( .A0(n343), .A1(\g[1][3] ), .B0(n344), .Y(x_s[3]) );
  NAND2X1 U404 ( .A(n344), .B(n106), .Y(n345) );
  OAI21XL U405 ( .A0(n344), .A1(n106), .B0(n345), .Y(x_s[4]) );
  XNOR2X1 U406 ( .A(\g[1][5] ), .B(n345), .Y(x_s[5]) );
  NOR2X1 U407 ( .A(\g[1][5] ), .B(n345), .Y(n346) );
  XOR2X1 U408 ( .A(\g[1][6] ), .B(n346), .Y(x_s[6]) );
  NAND2BX1 U409 ( .AN(\g[3][8] ), .B(n110), .Y(n347) );
  OAI2BB1X1 U410 ( .A0N(\g[3][7] ), .A1N(\g[3][8] ), .B0(n347), .Y(y_s[1]) );
  OR2X1 U411 ( .A(n347), .B(\g[3][9] ), .Y(n348) );
  OAI2BB1X1 U412 ( .A0N(n347), .A1N(\g[3][9] ), .B0(n348), .Y(y_s[2]) );
  NOR2X1 U413 ( .A(n348), .B(\g[3][10] ), .Y(n349) );
  AO21X1 U414 ( .A0(n348), .A1(\g[3][10] ), .B0(n349), .Y(y_s[3]) );
  NAND2X1 U415 ( .A(n349), .B(n100), .Y(n350) );
  OAI21XL U416 ( .A0(n349), .A1(n100), .B0(n350), .Y(y_s[4]) );
  XNOR2X1 U417 ( .A(\g[3][12] ), .B(n350), .Y(y_s[5]) );
  NOR2X1 U418 ( .A(\g[3][12] ), .B(n350), .Y(n351) );
  XOR2X1 U419 ( .A(\g[3][13] ), .B(n351), .Y(y_s[6]) );
  NAND2BX1 U420 ( .AN(g_cnt[1]), .B(n113), .Y(n352) );
  OAI2BB1X1 U421 ( .A0N(g_cnt[0]), .A1N(g_cnt[1]), .B0(n352), .Y(N142) );
  OR2X1 U422 ( .A(n352), .B(g_cnt[2]), .Y(n353) );
  OAI2BB1X1 U423 ( .A0N(n352), .A1N(g_cnt[2]), .B0(n353), .Y(N143) );
  NOR2X1 U424 ( .A(n353), .B(g_cnt[3]), .Y(N145) );
  NAND2BX1 U425 ( .AN(gc_data[4]), .B(gray_data[4]), .Y(n354) );
  OAI222XL U426 ( .A0(gc_data[5]), .A1(n370), .B0(gc_data[5]), .B1(n354), .C0(
        n370), .C1(n354), .Y(n355) );
  OAI222XL U427 ( .A0(gray_data[6]), .A1(n355), .B0(n248), .B1(n355), .C0(
        gray_data[6]), .C1(n248), .Y(n366) );
  NOR2BX1 U428 ( .AN(gc_data[4]), .B(gray_data[4]), .Y(n356) );
  OAI22XL U429 ( .A0(n356), .A1(n370), .B0(gc_data[5]), .B1(n356), .Y(n364) );
  NAND2BX1 U430 ( .AN(gc_data[2]), .B(gray_data[2]), .Y(n362) );
  OAI2BB2XL U431 ( .B0(gray_data[0]), .B1(n247), .A0N(n368), .A1N(gc_data[1]), 
        .Y(n357) );
  OAI21XL U432 ( .A0(gc_data[1]), .A1(n368), .B0(n357), .Y(n360) );
  NOR2BX1 U433 ( .AN(gc_data[2]), .B(gray_data[2]), .Y(n358) );
  OAI22XL U434 ( .A0(n358), .A1(n369), .B0(gc_data[3]), .B1(n358), .Y(n359) );
  AOI2BB2X1 U435 ( .B0(n360), .B1(n359), .A0N(n362), .A1N(n369), .Y(n361) );
  OAI221XL U436 ( .A0(gc_data[3]), .A1(n362), .B0(gc_data[3]), .B1(n369), .C0(
        n361), .Y(n363) );
  OAI211X1 U437 ( .A0(gray_data[6]), .A1(n248), .B0(n364), .C0(n363), .Y(n365)
         );
  AO22X1 U438 ( .A0(n371), .A1(gc_data[7]), .B0(n366), .B1(n365), .Y(n367) );
  OAI21XL U439 ( .A0(gc_data[7]), .A1(n371), .B0(n367), .Y(N140) );
endmodule


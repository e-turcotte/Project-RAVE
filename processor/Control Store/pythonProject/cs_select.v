module cs_select(
output[227:0] chosen,

input [227:0] w0,
input [227:0] w1,
input [227:0] w2,
input [227:0] w3,
input [227:0] w4,
input [227:0] w5,
input [227:0] w6,
input [227:0] w7,
input [227:0] w8,
input [227:0] w9,
input [227:0] w10,
input [227:0] w11,
input [227:0] w12,
input [227:0] w13,
input [227:0] w14,
input [227:0] w15,
input [227:0] w16,
input [227:0] w17,
input [227:0] w18,
input [227:0] w19,
input [227:0] w20,
input [227:0] w21,
input [227:0] w22,
input [227:0] w23,
input [227:0] w24,
input [227:0] w25,
input [227:0] w26,
input [227:0] w27,
input [227:0] w28,
input [227:0] w29,
input [227:0] w30,
input [227:0] w31,
input [227:0] w32,
input [227:0] w33,
input [227:0] w34,
input [227:0] w35,
input [227:0] w36,
input [227:0] w37,
input [227:0] w38,
input [227:0] w39,
input [227:0] w40,
input [227:0] w41,
input [227:0] w42,
input [227:0] w43,
input [227:0] w44,
input [227:0] w45,
input [227:0] w46,
input [227:0] w47,
input [227:0] w48,
input [227:0] w49,
input [227:0] w50,
input [227:0] w51,
input [227:0] w52,
input [227:0] w53,
input [227:0] w54,
input [227:0] w55,
input [227:0] w56,
input [227:0] w57,
input [227:0] w58,
input [227:0] w59,
input [227:0] w60,
input [227:0] w61,
input [227:0] w62,
input [227:0] w63,
input [227:0] w64,
input [227:0] w65,
input [227:0] w66,
input [227:0] w67,
input [227:0] w68,
input [227:0] w69,
input [227:0] w70,
input [227:0] w71,
input [227:0] w72,
input [227:0] w73,
input [227:0] w74,
input [227:0] w75,
input [227:0] w76,
input [227:0] w77,
input [227:0] w78,
input [227:0] w79,
input [227:0] w80,
input [227:0] w81,
input [227:0] w82,
input [227:0] w83,
input [227:0] w84,
input [227:0] w85,
input [227:0] w86,
input [227:0] w87,
input [227:0] w88,
input [227:0] w89,
input [227:0] w90,
input [227:0] w91,
input [227:0] w92,
input [227:0] w93,
input [227:0] w94,
input [227:0] w95,
input [227:0] w96,
input [227:0] w97,
input [227:0] w98,
input [227:0] w99,
input [227:0] w100,
input [227:0] w101,
input [227:0] w102,
input [227:0] w103,
input [227:0] w104,
input [227:0] w105,
input [227:0] w106,
input [227:0] w107,
input [227:0] w108,
input [227:0] w109,
input [227:0] w110,
input [227:0] w111,
input [227:0] w112,
input [227:0] w113,
input [227:0] w114,
input [227:0] w115,
input [227:0] w116,
input [227:0] w117,
input [227:0] w118,
input [227:0] w119,
input [227:0] w120,
input [227:0] w121,
input [227:0] w122,
input [227:0] w123,
input [227:0] w124,
input [227:0] w125,
input [227:0] w126,
input [227:0] w127,
input [227:0] w128,
input [227:0] w129,
input [227:0] w130,
input [227:0] w131,
input [227:0] w132,
input [227:0] w133,
input [227:0] w134,
input [227:0] w135,
input [227:0] w136,
input [227:0] w137,
input [227:0] w138,
input [227:0] w139,
input [7:0] B1, B2, B3);

equaln #(8) e0({B1}, {8'h04}, weq0);
equaln #(8) e1({B1}, {8'h05}, weq1);
equaln #(11) e2({B1, B2[5:3]}, {8'h80, 3'd0}, weq2);
equaln #(11) e3({B1, B2[5:3]}, {8'h81, 3'd0}, weq3);
equaln #(11) e4({B1, B2[5:3]}, {8'h83, 3'd0}, weq4);
equaln #(8) e5({B1}, {8'h00}, weq5);
equaln #(8) e6({B1}, {8'h01}, weq6);
equaln #(8) e7({B1}, {8'h02}, weq7);
equaln #(8) e8({B1}, {8'h03}, weq8);
equaln #(8) e9({B1}, {8'h24}, weq9);
equaln #(8) e10({B1}, {8'h25}, weq10);
equaln #(11) e11({B1, B2[5:3]}, {8'h80, 3'd4}, weq11);
equaln #(11) e12({B1, B2[5:3]}, {8'h81, 3'd4}, weq12);
equaln #(11) e13({B1, B2[5:3]}, {8'h83, 3'd4}, weq13);
equaln #(8) e14({B1}, {8'h20}, weq14);
equaln #(8) e15({B1}, {8'h21}, weq15);
equaln #(8) e16({B1}, {8'h22}, weq16);
equaln #(8) e17({B1}, {8'h23}, weq17);
equaln #(8) e18({B1}, {8'h0F}, weq18);
equaln #(8) e19({B1}, {8'hE8}, weq19);
equaln #(11) e20({B1, B2[5:3]}, {8'hFF, 3'd2}, weq20);
equaln #(8) e21({B1}, {8'h9A}, weq21);
equaln #(8) e22({B1}, {8'hFC}, weq22);
equaln #(8) e23({B1}, {8'h0F}, weq23);
equaln #(8) e24({B1}, {8'h0F}, weq24);
equaln #(8) e25({B1}, {8'h0F}, weq25);
equaln #(8) e26({B1}, {8'h27}, weq26);
equaln #(8) e27({B1}, {8'hF4}, weq27);
equaln #(8) e28({B1}, {8'hCF}, weq28);
equaln #(8) e29({B1}, {8'h77}, weq29);
equaln #(8) e30({B1}, {8'h75}, weq30);
equaln #(8) e31({B1}, {8'h0F}, weq31);
equaln #(8) e32({B1}, {8'h0F}, weq32);
equaln #(8) e33({B1}, {8'hEB}, weq33);
equaln #(8) e34({B1}, {8'hE9}, weq34);
equaln #(11) e35({B1, B2[5:3]}, {8'hFF, 3'd4}, weq35);
equaln #(8) e36({B1}, {8'hEA}, weq36);
equaln #(8) e37({B1}, {8'h88}, weq37);
equaln #(8) e38({B1}, {8'h89}, weq38);
equaln #(8) e39({B1}, {8'h8A}, weq39);
equaln #(8) e40({B1}, {8'h8B}, weq40);
equaln #(8) e41({B1}, {8'h8C}, weq41);
equaln #(8) e42({B1}, {8'h8E}, weq42);
equaln #(8) e43({B1}, {8'hB0}, weq43);
equaln #(8) e44({B1}, {8'hB1}, weq44);
equaln #(8) e45({B1}, {8'hB2}, weq45);
equaln #(8) e46({B1}, {8'hB3}, weq46);
equaln #(8) e47({B1}, {8'hB4}, weq47);
equaln #(8) e48({B1}, {8'hB5}, weq48);
equaln #(8) e49({B1}, {8'hB6}, weq49);
equaln #(8) e50({B1}, {8'hB7}, weq50);
equaln #(8) e51({B1}, {8'hB8}, weq51);
equaln #(8) e52({B1}, {8'hB9}, weq52);
equaln #(8) e53({B1}, {8'hBA}, weq53);
equaln #(8) e54({B1}, {8'hBB}, weq54);
equaln #(8) e55({B1}, {8'hBC}, weq55);
equaln #(8) e56({B1}, {8'hBD}, weq56);
equaln #(8) e57({B1}, {8'hBE}, weq57);
equaln #(8) e58({B1}, {8'hBF}, weq58);
equaln #(8) e59({B1}, {8'hC6}, weq59);
equaln #(8) e60({B1}, {8'hC7}, weq60);
equaln #(8) e61({B1}, {8'h0F}, weq61);
equaln #(8) e62({B1}, {8'h0F}, weq62);
equaln #(8) e63({B1}, {8'hA4}, weq63);
equaln #(8) e64({B1}, {8'hA5}, weq64);
equaln #(8) e65({B1}, {8'hF6}, weq65);
equaln #(8) e66({B1}, {8'hF7}, weq66);
equaln #(8) e67({B1}, {8'h0C}, weq67);
equaln #(8) e68({B1}, {8'h0D}, weq68);
equaln #(11) e69({B1, B2[5:3]}, {8'h80, 3'd1}, weq69);
equaln #(11) e70({B1, B2[5:3]}, {8'h81, 3'd1}, weq70);
equaln #(11) e71({B1, B2[5:3]}, {8'h83, 3'd1}, weq71);
equaln #(8) e72({B1}, {8'h08}, weq72);
equaln #(8) e73({B1}, {8'h09}, weq73);
equaln #(8) e74({B1}, {8'h0A}, weq74);
equaln #(8) e75({B1}, {8'h0B}, weq75);
equaln #(8) e76({B1}, {8'h0F}, weq76);
equaln #(8) e77({B1}, {8'h0F}, weq77);
equaln #(8) e78({B1}, {8'h0F}, weq78);
equaln #(8) e79({B1}, {8'h0F}, weq79);
equaln #(8) e80({B1}, {8'h0F}, weq80);
equaln #(8) e81({B1}, {8'h0F}, weq81);
equaln #(8) e82({B1}, {8'h8F}, weq82);
equaln #(8) e83({B1}, {8'h58}, weq83);
equaln #(8) e84({B1}, {8'h59}, weq84);
equaln #(8) e85({B1}, {8'h5A}, weq85);
equaln #(8) e86({B1}, {8'h5B}, weq86);
equaln #(8) e87({B1}, {8'h5C}, weq87);
equaln #(8) e88({B1}, {8'h5D}, weq88);
equaln #(8) e89({B1}, {8'h5E}, weq89);
equaln #(8) e90({B1}, {8'h5F}, weq90);
equaln #(8) e91({B1}, {8'h1F}, weq91);
equaln #(8) e92({B1}, {8'h7}, weq92);
equaln #(8) e93({B1}, {8'h17}, weq93);
equaln #(8) e94({B1}, {8'h0F}, weq94);
equaln #(8) e95({B1}, {8'h0F}, weq95);
equaln #(11) e96({B1, B2[5:3]}, {8'hFF, 3'd6}, weq96);
equaln #(8) e97({B1}, {8'h50}, weq97);
equaln #(8) e98({B1}, {8'h51}, weq98);
equaln #(8) e99({B1}, {8'h52}, weq99);
equaln #(8) e100({B1}, {8'h53}, weq100);
equaln #(8) e101({B1}, {8'h54}, weq101);
equaln #(8) e102({B1}, {8'h55}, weq102);
equaln #(8) e103({B1}, {8'h56}, weq103);
equaln #(8) e104({B1}, {8'h57}, weq104);
equaln #(8) e105({B1}, {8'h6A}, weq105);
equaln #(8) e106({B1}, {8'h68}, weq106);
equaln #(8) e107({B1}, {8'h0E}, weq107);
equaln #(8) e108({B1}, {8'h16}, weq108);
equaln #(8) e109({B1}, {8'h1E}, weq109);
equaln #(8) e110({B1}, {8'h6}, weq110);
equaln #(8) e111({B1}, {8'h0F}, weq111);
equaln #(8) e112({B1}, {8'h0F}, weq112);
equaln #(8) e113({B1}, {8'hC3}, weq113);
equaln #(8) e114({B1}, {8'hCB}, weq114);
equaln #(8) e115({B1}, {8'hC2}, weq115);
equaln #(8) e116({B1}, {8'hCA}, weq116);
equaln #(11) e117({B1, B2[5:3]}, {8'hD0, 3'd4}, weq117);
equaln #(11) e118({B1, B2[5:3]}, {8'hD2, 3'd4}, weq118);
equaln #(8) e119({B1}, {8'hC0}, weq119);
equaln #(11) e120({B1, B2[5:3]}, {8'hD1, 3'd4}, weq120);
equaln #(11) e121({B1, B2[5:3]}, {8'hD3, 3'd4}, weq121);
equaln #(11) e122({B1, B2[5:3]}, {8'hC1, 3'd4}, weq122);
equaln #(11) e123({B1, B2[5:3]}, {8'hD0, 3'd7}, weq123);
equaln #(11) e124({B1, B2[5:3]}, {8'hD2, 3'd7}, weq124);
equaln #(8) e125({B1}, {8'hC0}, weq125);
equaln #(11) e126({B1, B2[5:3]}, {8'hD1, 3'd7}, weq126);
equaln #(11) e127({B1, B2[5:3]}, {8'hD3, 3'd7}, weq127);
equaln #(11) e128({B1, B2[5:3]}, {8'hC1, 3'd7}, weq128);
equaln #(8) e129({B1}, {8'hFD}, weq129);
equaln #(8) e130({B1}, {8'h90}, weq130);
equaln #(8) e131({B1}, {8'h91}, weq131);
equaln #(8) e132({B1}, {8'h92}, weq132);
equaln #(8) e133({B1}, {8'h93}, weq133);
equaln #(8) e134({B1}, {8'h94}, weq134);
equaln #(8) e135({B1}, {8'h95}, weq135);
equaln #(8) e136({B1}, {8'h96}, weq136);
equaln #(8) e137({B1}, {8'h97}, weq137);
equaln #(8) e138({B1}, {8'h86}, weq138);
equaln #(8) e139({B1}, {8'h87}, weq139);
bufferH256$ b0(beq0, weq0);
bufferH256$ b1(beq1, weq1);
bufferH256$ b2(beq2, weq2);
bufferH256$ b3(beq3, weq3);
bufferH256$ b4(beq4, weq4);
bufferH256$ b5(beq5, weq5);
bufferH256$ b6(beq6, weq6);
bufferH256$ b7(beq7, weq7);
bufferH256$ b8(beq8, weq8);
bufferH256$ b9(beq9, weq9);
bufferH256$ b10(beq10, weq10);
bufferH256$ b11(beq11, weq11);
bufferH256$ b12(beq12, weq12);
bufferH256$ b13(beq13, weq13);
bufferH256$ b14(beq14, weq14);
bufferH256$ b15(beq15, weq15);
bufferH256$ b16(beq16, weq16);
bufferH256$ b17(beq17, weq17);
bufferH256$ b18(beq18, weq18);
bufferH256$ b19(beq19, weq19);
bufferH256$ b20(beq20, weq20);
bufferH256$ b21(beq21, weq21);
bufferH256$ b22(beq22, weq22);
bufferH256$ b23(beq23, weq23);
bufferH256$ b24(beq24, weq24);
bufferH256$ b25(beq25, weq25);
bufferH256$ b26(beq26, weq26);
bufferH256$ b27(beq27, weq27);
bufferH256$ b28(beq28, weq28);
bufferH256$ b29(beq29, weq29);
bufferH256$ b30(beq30, weq30);
bufferH256$ b31(beq31, weq31);
bufferH256$ b32(beq32, weq32);
bufferH256$ b33(beq33, weq33);
bufferH256$ b34(beq34, weq34);
bufferH256$ b35(beq35, weq35);
bufferH256$ b36(beq36, weq36);
bufferH256$ b37(beq37, weq37);
bufferH256$ b38(beq38, weq38);
bufferH256$ b39(beq39, weq39);
bufferH256$ b40(beq40, weq40);
bufferH256$ b41(beq41, weq41);
bufferH256$ b42(beq42, weq42);
bufferH256$ b43(beq43, weq43);
bufferH256$ b44(beq44, weq44);
bufferH256$ b45(beq45, weq45);
bufferH256$ b46(beq46, weq46);
bufferH256$ b47(beq47, weq47);
bufferH256$ b48(beq48, weq48);
bufferH256$ b49(beq49, weq49);
bufferH256$ b50(beq50, weq50);
bufferH256$ b51(beq51, weq51);
bufferH256$ b52(beq52, weq52);
bufferH256$ b53(beq53, weq53);
bufferH256$ b54(beq54, weq54);
bufferH256$ b55(beq55, weq55);
bufferH256$ b56(beq56, weq56);
bufferH256$ b57(beq57, weq57);
bufferH256$ b58(beq58, weq58);
bufferH256$ b59(beq59, weq59);
bufferH256$ b60(beq60, weq60);
bufferH256$ b61(beq61, weq61);
bufferH256$ b62(beq62, weq62);
bufferH256$ b63(beq63, weq63);
bufferH256$ b64(beq64, weq64);
bufferH256$ b65(beq65, weq65);
bufferH256$ b66(beq66, weq66);
bufferH256$ b67(beq67, weq67);
bufferH256$ b68(beq68, weq68);
bufferH256$ b69(beq69, weq69);
bufferH256$ b70(beq70, weq70);
bufferH256$ b71(beq71, weq71);
bufferH256$ b72(beq72, weq72);
bufferH256$ b73(beq73, weq73);
bufferH256$ b74(beq74, weq74);
bufferH256$ b75(beq75, weq75);
bufferH256$ b76(beq76, weq76);
bufferH256$ b77(beq77, weq77);
bufferH256$ b78(beq78, weq78);
bufferH256$ b79(beq79, weq79);
bufferH256$ b80(beq80, weq80);
bufferH256$ b81(beq81, weq81);
bufferH256$ b82(beq82, weq82);
bufferH256$ b83(beq83, weq83);
bufferH256$ b84(beq84, weq84);
bufferH256$ b85(beq85, weq85);
bufferH256$ b86(beq86, weq86);
bufferH256$ b87(beq87, weq87);
bufferH256$ b88(beq88, weq88);
bufferH256$ b89(beq89, weq89);
bufferH256$ b90(beq90, weq90);
bufferH256$ b91(beq91, weq91);
bufferH256$ b92(beq92, weq92);
bufferH256$ b93(beq93, weq93);
bufferH256$ b94(beq94, weq94);
bufferH256$ b95(beq95, weq95);
bufferH256$ b96(beq96, weq96);
bufferH256$ b97(beq97, weq97);
bufferH256$ b98(beq98, weq98);
bufferH256$ b99(beq99, weq99);
bufferH256$ b100(beq100, weq100);
bufferH256$ b101(beq101, weq101);
bufferH256$ b102(beq102, weq102);
bufferH256$ b103(beq103, weq103);
bufferH256$ b104(beq104, weq104);
bufferH256$ b105(beq105, weq105);
bufferH256$ b106(beq106, weq106);
bufferH256$ b107(beq107, weq107);
bufferH256$ b108(beq108, weq108);
bufferH256$ b109(beq109, weq109);
bufferH256$ b110(beq110, weq110);
bufferH256$ b111(beq111, weq111);
bufferH256$ b112(beq112, weq112);
bufferH256$ b113(beq113, weq113);
bufferH256$ b114(beq114, weq114);
bufferH256$ b115(beq115, weq115);
bufferH256$ b116(beq116, weq116);
bufferH256$ b117(beq117, weq117);
bufferH256$ b118(beq118, weq118);
bufferH256$ b119(beq119, weq119);
bufferH256$ b120(beq120, weq120);
bufferH256$ b121(beq121, weq121);
bufferH256$ b122(beq122, weq122);
bufferH256$ b123(beq123, weq123);
bufferH256$ b124(beq124, weq124);
bufferH256$ b125(beq125, weq125);
bufferH256$ b126(beq126, weq126);
bufferH256$ b127(beq127, weq127);
bufferH256$ b128(beq128, weq128);
bufferH256$ b129(beq129, weq129);
bufferH256$ b130(beq130, weq130);
bufferH256$ b131(beq131, weq131);
bufferH256$ b132(beq132, weq132);
bufferH256$ b133(beq133, weq133);
bufferH256$ b134(beq134, weq134);
bufferH256$ b135(beq135, weq135);
bufferH256$ b136(beq136, weq136);
bufferH256$ b137(beq137, weq137);
bufferH256$ b138(beq138, weq138);
bufferH256$ b139(beq139, weq139);
wire[139:0] sigCat0;
assign sigCat0 = {beq0, beq1, beq2, beq3, beq4, beq5, beq6, beq7, beq8, beq9, beq10, beq11, beq12, beq13, beq14, beq15, beq16, beq17, beq18, beq19, beq20, beq21, beq22, beq23, beq24, beq25, beq26, beq27, beq28, beq29, beq30, beq31, beq32, beq33, beq34, beq35, beq36, beq37, beq38, beq39, beq40, beq41, beq42, beq43, beq44, beq45, beq46, beq47, beq48, beq49, beq50, beq51, beq52, beq53, beq54, beq55, beq56, beq57, beq58, beq59, beq60, beq61, beq62, beq63, beq64, beq65, beq66, beq67, beq68, beq69, beq70, beq71, beq72, beq73, beq74, beq75, beq76, beq77, beq78, beq79, beq80, beq81, beq82, beq83, beq84, beq85, beq86, beq87, beq88, beq89, beq90, beq91, beq92, beq93, beq94, beq95, beq96, beq97, beq98, beq99, beq100, beq101, beq102, beq103, beq104, beq105, beq106, beq107, beq108, beq109, beq110, beq111, beq112, beq113, beq114, beq115, beq116, beq117, beq118, beq119, beq120, beq121, beq122, beq123, beq124, beq125, beq126, beq127, beq128, beq129, beq130, beq131, beq132, beq133, beq134, beq135, beq136, beq137, beq138, beq139};
wire[31779:0] dataCat0;
 assign dataCat0 ={w0, w1, w2, w3, w4, w5, w6, w7, w8, w9, w10, w11, w12, w13, w14, w15, w16, w17, w18, w19, w20, w21, w22, w23, w24, w25, w26, w27, w28, w29, w30, w31, w32, w33, w34, w35, w36, w37, w38, w39, w40, w41, w42, w43, w44, w45, w46, w47, w48, w49, w50, w51, w52, w53, w54, w55, w56, w57, w58, w59, w60, w61, w62, w63, w64, w65, w66, w67, w68, w69, w70, w71, w72, w73, w74, w75, w76, w77, w78, w79, w80, w81, w82, w83, w84, w85, w86, w87, w88, w89, w90, w91, w92, w93, w94, w95, w96, w97, w98, w99, w100, w101, w102, w103, w104, w105, w106, w107, w108, w109, w110, w111, w112, w113, w114, w115, w116, w117, w118, w119, w120, w121, w122, w123, w124, w125, w126, w127, w128, w129, w130, w131, w132, w133, w134, w135, w136, w137, w138, w139};
muxnm_tristate #(8, 227) mxt1(dataCat0, sigCat0 ,chosen);

endmodule
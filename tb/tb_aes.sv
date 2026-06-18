// Copyright (c) 2026 stefand-0
// SPDX-License-Identifier: SHL-2.1
//
// Licensed under the Solderpad Hardware License, Version 2.1 (the "License");
// you may not use this file except in compliance with the License, or,
// at your option, the Apache License version 2.0.
// You may obtain a copy of the License at
//
// https://solderpad.org/licenses/SHL-2.1/
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.


`timescale 1ns/1ps

module tb_aes;

    logic         clk;
    logic         rst;
    logic         start;
    logic [127:0] data_in;
    logic [127:0] key_in;
    logic [127:0] data_out;
    logic         done;

    smallAES uut (
        .clk(clk),
        .rst(rst),
        .start(start),
        .data_in(data_in),
        .key_in(key_in),
        .data_out(data_out),
        .done(done)
    );

    always #5 clk = ~clk;

    initial begin
        clk = 0;
        rst = 1;
        start = 0;
        data_in = 128'h00112233445566778899aabbccddeeff;
        key_in = 128'h000102030405060708090a0b0c0d0e0f;

        #20;
        rst = 0;
        #10;
        start = 1;
        #10;
        start = 0;

        @ (posedge done);
        #20;
        $display("Data Out: %h", data_out);
        $finish;
    end

endmodule


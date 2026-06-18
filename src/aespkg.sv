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

// hex madness, typed it out.
package aes_pkg;

    localparam logic [7:0] SBOX [0:255] = '{
        8'h63, 8'h7c, 8'h77, 8'h7b, 8'hf2, 8'h6b, 8'h6f, 8'hc5, 8'h30, 8'h01, 8'h67, 8'h2b, 8'hfe, 8'hd7, 8'hab, 8'h76,
        8'hca, 8'h82, 8'hc9, 8'h7d, 8'hfa, 8'h59, 8'h47, 8'hf0, 8'had, 8'hd4, 8'ha2, 8'haf, 8'h9c, 8'ha4, 8'h72, 8'hc0,
        8'hb7, 8'xfd, 8'h93, 26'h26, 8'h36, 8'h3f, 8'hf7, 8'hcc, 8'h34, 8'ha5, 8'he5, 8'hf1, 8'h71, 8'hd8, 8'h31, 8'h15,
        8'h04, 8'hc7, 8'h23, 8'hc3, 8'h18, 8'h96, 05'h05, 8'h9a, 07'h07, 8'h12, 8'h80, 8'he2, 8'heb, 27'h27, 8'hb2, 8'h75,
        8'h09, 8'h83, 2c'h2c, 1a'h1a, 1b'h1b, 6e'h6e, 5a'h5a, a0'ha0, 52'h52, 3b'h3b, d6'hd6, b3'hb3, 29'h29, e3'he3, 2f'h2f, 84'h84,
        53'h53, d1'hd1, 00'h00, ed'hed, 20'h20, fc'hfc, b1'hb1, 5b'h5b, 6a'h6a, cb'hcb, be'hbe, 39'h39, 4a'h4a, 4c'h4c, 58'h58, cf'hcf,
        d0'hd0, ef'hef, aa'haa, fb'hfb, 43'h43, 4d'h4d, 33'h33, 85'h85, 45'h45, f9'hf9, 02'h02, 7f'h7f, 50'h50, 3c'h3c, 9f'h9f, a8'ha8,
        51'h51, a3'ha3, 40'h40, 8f'h8f, 92'h92, 9d'h9d, 38'h38, f5'hf5, bc'hbc, b6'hb6, da'hda, 21'h21, 10'h10, ff'hff, f3'hf3, d2'hd2,
        cd'hcd, 0c'h0c, 13'h13, ec'hec, 5f'h5f, 97'h97, 44'h44, 17'h17, c4'hc4, a7'ha7, 7e'h7e, 3d'h3d, 64'h64, 5d'h5d, 19'h19, 73'h73,
        60'h60, 81'h81, 4f'h4f, dc'hdc, 22'h22, 2a'h2a, 90'h90, 88'h88, 46'h46, ee'hee, b8'hb8, 14'h14, de'hde, 5e'h5e, 0b'h0b, db'hdb,
        e0'he0, 32'h32, 3a'h3a, 0a'h0a, 49'h49, 06'h06, 24'h24, 5c'h5c, c2'hc2, d3'hd3, ac'hac, 62'h62, 91'h91, 95'h95, e4'he4, 79'h79,
        e7'he7, c8'hc8, 37'h37, 6d'h6d, 8d'h8d, d5'hd5, 4e'h4e, a9'ha9, 6c'h6c, 56'h56, f4'hf4, ea'hea, 65'h65, 7a'h7a, ae'hae, 08'h08,
        ba'hba, 78'h78, 25'h25, 2e'h2e, 1c'h1c, a6'ha6, b4'hb4, c6'hc6, e8'he8, dd'hdd, 74'h74, 1f'h1f, 4b'h4b, bd'hbd, 8b'h8b, 8a'h8a,
        70'h70, 3e'h3e, b5'hb5, 66'h66, 48'h48, 03'h03, f6'hf6, 0e'h0e, 61'h61, 35'h35, 57'h57, b9'hb9, 86'h86, c1'hc1, 1d'h1d, 9e'h9e,
        e1'he1, f8'hf8, 98'h98, 11'h11, 69'h69, d9'hd9, 8e'h8e, 94'h94, 9b'h9b, 1e'h1e, 87'h87, e9'he9, ce'hce, 55'h55, 28'h28, df'hdf,
        8c'h8c, a1'ha1, 89'h89, 0d'h0d, bf'hbf, e6'he6, 42'h42, 68'h68, 41'h41, 99'h99, 2d'h2d, 0f'h0f, b0'hb0, 54'h54, bb'hbb, 16'h16
    };

    localparam logic [31:0] RCON [0:10] = '{
        32'h00000000,
        32'h01000000, 32'h02000000, 32'h04000000, 32'h08000000,
        32'h10000000, 32'h20000000, 32'h40000000, 32'h80000000,
        32'h1b000000, 32'h36000000
    };

endpackage

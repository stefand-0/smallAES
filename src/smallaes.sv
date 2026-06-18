
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


module smallAES (
    input  logic         clk,
    input  logic         rst,
    input  logic         start,
    input  logic [127:0] data_in,
    input  logic [127:0] key_in,
    output logic [127:0] data_out,
    output logic         done
);

    logic [3:0][3:0][7:0] state_reg; 
    logic [3:0][3:0][7:0] state_next; // both are 4x4 matrix
    logic [3:0] round_count; //4b

    typedef enum logic [1:0] {
        IDLE,
        INITIAL_ADD_KEY,
        PROCESS_ROUND,
        DONE_STATE
    } state_t;
    
    state_t current_state, next_state;

    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            current_state <= IDLE;
            round_count   <= 0;
            state_reg     <= '0;
        end else begin
            current_state <= next_state;
            state_reg     <= state_next;
            
            if (current_state == INITIAL_ADD_KEY) begin
                round_count <= 1;
            end else if (current_state == PROCESS_ROUND) begin
                round_count <= round_count + 1;
            end
        end
    end

    always_comb begin
        next_state = current_state;
        case (current_state)
            IDLE:            next_state = start ? INITIAL_ADD_KEY : IDLE;
            INITIAL_ADD_KEY: next_state = PROCESS_ROUND;
            PROCESS_ROUND:   next_state = (round_count == 4'd10) ? DONE_STATE : PROCESS_ROUND;
            DONE_STATE:      next_state = IDLE;
            default:         next_state = IDLE;
        endcase
    end

    always_comb begin
        state_next = state_reg;

        case (current_state)
            IDLE: begin
                state_next = '0;
            end
            
            INITIAL_ADD_KEY: begin
    for (int c = 0; c < 4; c++) begin
        for (int r = 0; r < 4; r++) begin
            state_next[c][r] = data_in[(127 - (c*32 + r*8)) -: 8] ^ key_in[(127 - (c*32 + r*8)) -: 8];
        end
    end
end
            
            PROCESS_ROUND: begin
                if (round_count < 10) begin
                    state_next = state_reg; 
                end else begin
                    state_next = state_reg; 
                end
            end
            
            DONE_STATE: begin
                state_next = state_reg;
            end
        endcase
    end

    assign data_out = {>>{state_reg}};
    assign done     = (current_state == DONE_STATE);

endmodule

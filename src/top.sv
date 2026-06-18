module top_aes (
    input  logic clk,
    input  logic rst,
    input  logic load_en,
    input  logic start,
    input  logic data_bit_in,
    input  logic key_bit_in,
    output logic cipher_bit_out,
    output logic done
);

    logic [127:0] data_in_reg;
    logic [127:0] key_in_reg;
    logic [127:0] cipher_out_reg;
    logic [127:0] aes_data_out;
    logic         aes_done;
    logic         aes_start;
    logic [7:0]   bit_count;

    typedef enum logic [1:0] {
        IDLE,
        SHIFT_IN,
        RUN_AES,
        SHIFT_OUT
    } state_t;

    state_t current_state, next_state;

    smallAES uut (
        .clk(clk),
        .rst(rst),
        .start(aes_start),
        .data_in(data_in_reg),
        .key_in(key_in_reg),
        .data_out(aes_data_out),
        .done(aes_done)
    );

    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            current_state  <= IDLE;
            bit_count      <= 0;
            data_in_reg    <= '0;
            key_in_reg     <= '0;
            cipher_out_reg <= '0;
            aes_start      <= 0;
        end else begin
            current_state <= next_state;
            aes_start     <= (current_state == IDLE && start);

            if (current_state == SHIFT_IN) begin
                data_in_reg <= {data_in_reg[126:0], data_bit_in};
                key_in_reg  <= {key_in_reg[126:0], key_bit_in};
                bit_count   <= bit_count + 1;
            end else if (current_state == RUN_AES) begin
                bit_count <= 0;
                if (aes_done) begin
                    cipher_out_reg <= aes_data_out;
                end
            end else if (current_state == SHIFT_OUT) begin
                cipher_out_reg <= {cipher_out_reg[126:0], 1'b0};
                bit_count      <= bit_count + 1;
            end else begin
                bit_count <= 0;
            end
        end
    end

    always_comb begin
        next_state = current_state;
        case (current_state)
            IDLE:      next_state = load_en ? SHIFT_IN : (start ? RUN_AES : IDLE);
            SHIFT_IN:  next_state = (bit_count == 8'd127) ? IDLE : SHIFT_IN;
            RUN_AES:   next_state = aes_done ? SHIFT_OUT : RUN_AES;
            SHIFT_OUT: next_state = (bit_count == 8'd127) ? IDLE : SHIFT_OUT;
            default:   next_state = IDLE;
        endcase
    end

    assign cipher_bit_out = cipher_out_reg[127];
    assign done           = (current_state == SHIFT_OUT && bit_count == 8'd127);

endmodule

module vga_controller ( // 640 x 480 25 MHz
    input wire clk,               // 25 MHz clock // trocar depois para 50 MHz para relogio da FPGA
    input wire [11:0] pixel_data, // Input pixel data (from frame buffer)
    output reg hsync,             // Horizontal sync
    output reg vsync,             // Vertical sync
    output reg [3:0] r, g, b      // RGB outputs
);
    // Horizontal counters
    reg [9:0] h_counter;
    reg [9:0] v_counter;

    // VGA timing constants
    localparam H_ACTIVE = 640, H_FP = 16, H_SYNC = 96, H_BP = 48, H_TOTAL = 800;
    localparam V_ACTIVE = 480, V_FP = 10, V_SYNC = 2, V_BP = 33, V_TOTAL = 525;

    always @(posedge clk) begin
        if (h_counter == H_TOTAL - 1) begin
            h_counter <= 0;
            if (v_counter == V_TOTAL - 1) begin
                v_counter <= 0;
            end else begin
                v_counter <= v_counter + 1;
            end
        end else begin
            h_counter <= h_counter + 1;
        end
    end

    // Generate sync signals
    always @(posedge clk) begin
        hsync <= (h_counter >= (H_ACTIVE + H_FP)) && (h_counter < (H_ACTIVE + H_FP + H_SYNC));
        vsync <= (v_counter >= (V_ACTIVE + V_FP)) && (v_counter < (V_ACTIVE + V_FP + V_SYNC));
    end

    // Output RGB data during active video period
    always @(posedge clk) begin
        if (h_counter < H_ACTIVE && v_counter < V_ACTIVE) begin
            r <= pixel_data[11:8]; // Example: all RGB values set to pixel_data
            g <= pixel_data[7:4];
            b <= pixel_data[3:0];
        end else begin
            r <= 0;
            g <= 0;
            b <= 0;
        end
    end
endmodule

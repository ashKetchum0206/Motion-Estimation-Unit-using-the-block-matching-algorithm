`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 16.11.2022 22:25:18
// Design Name: 
// Module Name: overall
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module overall(clk,reset,transmit,o_TX_Serial,completed);
parameter imageWidth = 96;
parameter imageHeight = 96;
parameter pixelWidth = 23;
parameter blockWidth = 16;
parameter blockHeight = 16;
parameter searchWidth = 16;
parameter searchHeight = 16;
parameter macro_block_num = (imageHeight * imageWidth)/ (blockHeight* blockWidth);
 reg [7:0] data;
//reg [5:0] result[5:0];
input clk; //UART input clock
input reset; // reset signal
input transmit; //btn signal to trigger the UART communication
output o_TX_Serial;
//output reg TxD; // Transmitter serial output. TxD will be held high during reset, or when no transmissions aretaking place. );
output reg completed;
    parameter idle = 3'b000;
    parameter loading = 3'b001;
     parameter processed = 3'b010;
    parameter transmission = 3'b011;
    parameter end_state = 3'b100;
    reg [2:0] state=2'b00;
    reg [5:0]count=0;
    integer iter=0;
reg i_RST_L;
wire o_TX_Done;
wire transmit_start;
wire [((macro_block_num * ($clog2(macro_block_num)))-1):0] result;
reg [((macro_block_num * ($clog2(macro_block_num)))-1):0] result2;

main2 main(clk,reset,result,transmit_start);
transmit10 tr10(.i_Rst_L(i_RST_L),.i_Clock(clk),.i_TX_Byte(data),.o_TX_Serial(o_TX_Serial),.o_TX_Done(o_TX_Done));
always @(posedge clk)
    begin
        case(state)
        idle:begin
            i_RST_L = 1;
            completed = 0;
            if(transmit_start) begin
                    state <= loading;
                    result2<=result;
                    end
                  else                            
                    state <= idle;
              end
              loading:begin
                i_RST_L = 1;
                if(count<36)
                begin
                
                
                for(iter=0;iter<6;iter=iter+1)
                begin
                    data[iter]=result2[0];
                    result2=result2>>1;
                end
                data[7:6]=2'b00;
//                   data[7:0]<=result[20:13];

                count<=count+1;
                
                state<=transmission;
                i_RST_L<=0;
                end
                else
                state<=end_state;
                end
               transmission:begin
               i_RST_L<=1;
               if(!o_TX_Done)
               state<=transmission;
               else
               state<=loading;
               end
               end_state:begin
               completed<=1;
//               state<=end_state;
               end
               endcase
                end
                

endmodule

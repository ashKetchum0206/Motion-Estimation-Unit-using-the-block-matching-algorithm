`timescale 1ns / 1ps

module main2(clk,reset,result,transmit);

input clk,reset;


// image and block parameters
parameter imageWidth = 96;
parameter imageHeight = 96;
parameter pixelWidth = 23;
parameter blockWidth = 16;
parameter blockHeight = 16;
parameter searchWidth = 16;
parameter searchHeight = 16;
parameter imageSize = imageHeight* imageWidth;
parameter blockSize = blockWidth * blockHeight;
parameter address_length = 13;
parameter macro_block_num = (imageHeight * imageWidth)/ (blockHeight* blockWidth);
parameter numRows=imageWidth/blockWidth;
reg [5:0]count_macro_source=0;
reg [5:0]count_macro=0;
reg [4:0] count_row=0;
reg[4:0]count_col=0;
reg[9:0]SADR = 0,SADB = 0,SADG = 0;
reg[17:0]SAD;
reg [17:0] min_SAD=18'b111111111111111111;
reg reset_macro=1;
reg WriteEnable;

reg [address_length:0]addrA=0, addrB=0; //addrA for the 1st image and addrB for the 2nd image
reg [address_length:0] aA=0, aB=0;

reg localSAD;
wire [pixelWidth:0] pixela,pixelb; //source the RGB values for the pixels we are using
reg [$clog2(macro_block_num):0]min_SAD_index,index;

output reg [((macro_block_num * ($clog2(macro_block_num)))-1):0]result;
output reg transmit;
reg [macro_block_num:0]completed;

integer i;
integer k2;
parameter [1:0] IDLE = 0, CALCULATING =1, DONE = 2;


//update
integer o=0,c=numRows-1 ;
integer j;
//update



reg [1:0]state; //state of the FSM
reg [1:0]nextstate;

Image1_wrapper
   Im1(.BRAM_PORTA_0_addr(aA),
    .BRAM_PORTA_0_clk(clk),
    .BRAM_PORTA_0_din(24'b111111111111111111111111),
    .BRAM_PORTA_0_dout(pixela),
    .BRAM_PORTA_0_en(1'b1),
    .BRAM_PORTA_0_we(1'b0));
   
Image3_wrapper
   Im3(.BRAM_PORTA_0_addr(aB),
    .BRAM_PORTA_0_clk(clk),
    .BRAM_PORTA_0_din(24'b111111111111111111111111),
    .BRAM_PORTA_0_dout(pixelb),
    .BRAM_PORTA_0_en(1'b1),
    .BRAM_PORTA_0_we(1'b0));
   
   
always@(posedge clk) begin

    transmit <= (state==DONE);

    case(state)
       
            IDLE:
                begin
               
                if(!reset) begin
               
                        state<=CALCULATING;
                        reset_macro<=1;
                        addrA<=0;
                        addrB<=0;
                       //pixela<=0;
                       //pixelb<=0;
                        SAD<=0;
                        min_SAD<=18'b111111111111111111;
                        count_macro_source<=0;
                        count_macro<=0;
                       
                        result <= 0;
                        aA<=0;
                        aB<=0;
                           
                      end
                     
                 else state<= IDLE;
                     
               end
               
           CALCULATING: begin
           
                if(count_macro_source == macro_block_num)
                   
                    state<=DONE;
                   
                else begin
               
                    if(reset_macro) begin
                   
                      count_row <= 0;
                      count_col <= 0;
                      SAD <= 0;
                      index <= 0;
   
                   
                    begin
                    reset_macro<=0;
                   
                    if(count_macro==0)
                    begin
                        addrB<=0;
                      //  SAD<=0;
                        min_SAD<=18'b111111111111111111;
                        //addrA ka kuch ho sakta
                    end
                    else if(count_macro<macro_block_num)
                    begin
                        if((count_macro+1)%numRows==0)
                        begin
                            addrA<= addrA - imageWidth*(blockHeight-1) - blockWidth +1;
                            addrB<=addrB+1;
                        end
                       
                        else
                            begin
                                addrB <=addrB - imageWidth*(blockHeight-1) +1 ;
                                addrA<= addrA - imageWidth*(blockHeight-1) - blockWidth +1;
                               
                            end
                           
                       if(SAD<min_SAD)
                       begin
                            min_SAD<=SAD;
                            min_SAD_index<=index;
                           //
//                            if(count_macro==macro_block_num) begin
//                                    for(i=o,j=0;i<c;i=i+1,j=j+1)begin
//                                    result[i]<=min_SAD_index[j];
//                                    end
//                                    o=c+1;
//                                    c=c+6;
//                            end
                            //
                           
//                           for (i= ((macro_block_num * ($clog2(macro_block_num)))-1)-(count_macro_source-1)*($clog2(macro_block_num))-($clog2(macro_block_num));i<((macro_block_num * ($clog2(macro_block_num)))-1)-(count_macro_source-1)*($clog2(macro_block_num));i=i+1)
//                            begin
//                            result[i] = min_SAD_index[k2];
//                            k2=k2+1;
//                            end
                           
                           
                       end
                       end
                       else if(count_macro>=macro_block_num)  
                       
                            begin
                       
                                    if(SAD<min_SAD)
                            begin
                                 min_SAD<=SAD;
                                 min_SAD_index<=index;
                           
//                           for (i= ((macro_block_num * ($clog2(macro_block_num)))-1)-(count_macro_source-1)*($clog2(macro_block_num))-($clog2(macro_block_num));i<((macro_block_num * ($clog2(macro_block_num)))-1)-(count_macro_source-1)*($clog2(macro_block_num));i=i+1)
//                                begin
//                                    result[i] = min_SAD_index[k2];
//                                    k2=k2+1;
//                                end
                           
                             
                       end
                       
                            for( i = 0; i< ($clog2(macro_block_num)); i = i+1) begin
                       
                                result[ (count_macro_source * ($clog2(macro_block_num)))+i ] <= min_SAD_index[i];
                                end
                               
                               
                            if(!((count_macro_source+1)%numRows))
                                addrA <= addrA +1;
                           
                            else
                                addrA <=addrA - imageWidth*(blockHeight-1) +1 ;
                           
                            count_macro_source<=count_macro_source+1;
                            completed[min_SAD_index]<= 1;
                            min_SAD<=18'b111111111111111111;
                            count_macro<=0;
                           
                     
                           
                            addrB<=0;
                       end
                         
                    end
                   
               
               
                    end
                   
                    else if(!reset_macro) begin
                   
                         if(reset_macro == 0) begin
                         
                                aA<=addrA;
                                aB<=addrB;
   
   
                                if(count_col < blockWidth) begin  //[23:17] for R, [16:8] for G, [7:0] B
           
           
                                    if(pixela[23:16] > pixelb[23:16])
                                    SADR <= pixela[23:16] - pixelb[23:16];
               
                                     else
                                     SADR <= pixelb[23:16] - pixela[23:16];
           
                                     if(pixela[15:8] > pixelb[15:8])
                                     SADG <= pixela[15:8] - pixelb[15:8];
               
                                     else
                                      SADG <= pixelb[15:8] - pixela[15:8];
           
                                     if(pixela[7:0] > pixelb[7:0])
                                      SADB <= pixela[7:0] - pixelb[7:0];
               
                                      else
                                       SADB <= pixelb[7:0] - pixela[7:0];    
               
                                      count_col <= count_col +1;
                                      SAD <= SAD + SADR + SADB + SADG;
                                      addrA <= addrA + !(count_col== blockWidth-1);
                                      addrB <= addrB + !(count_col== blockWidth-1);
                       
                                       end
               
           
                                     else if(count_col == blockWidth) begin  //if all the pixels in a row are exhausted  
                                     
                                        if(count_row < blockHeight-1) begin
                            //               if(count_row==blockHeight)begin
                                            addrA  <= addrA + imageWidth+1-blockWidth;
                                            addrB <=  addrB + imageWidth+1-blockWidth;
                            //                end
                                            count_col <= 0;
                                            count_row<=count_row+1;
                                           
                                            end
                                           
                                        else if(count_row == blockHeight-1) begin
                                              // becomes 1 when calculation complete for a macroblock
                                            reset_macro <= 1;
                                            index<=count_macro;
                                            count_macro <= count_macro +1;
                       
                                            end
                           
                       
                                         end
             
           
                                end
                   
                       
                        end
               
                   
                end
               
                   
               
           end    
           
               
                   
           DONE: state<=DONE;
           
           
               
           default: state<=IDLE;
   
   
   
   
   
   
    endcase

end
   
   
   

endmodule
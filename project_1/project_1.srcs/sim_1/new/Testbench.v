`timescale 1ns / 1ps



module Testbench;

reg clkt,resett;
parameter blockWidth = 16;
parameter blockHeight = 16;
parameter imageWidth = 96;
parameter imageHeight = 96;
parameter macro_block_num = (imageHeight * imageWidth)/ (blockHeight* blockWidth);


wire [((macro_block_num * ($clog2(macro_block_num)))-1):0]resultt;

main2 test(clkt,resett,resultt);

initial begin

clkt = 0;

#1;

forever begin

clkt = ~clkt;
#1;

end
end

initial begin


#1;

resett = 1;

#10;

resett =0;

#100_000_00;

$finish;

end


endmodule
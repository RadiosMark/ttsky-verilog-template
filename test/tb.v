`default_nettype none
`timescale 1ns / 1ps

/* This testbench just instantiates the module and makes some convenient wires
   that can be driven / tested by the cocotb test.py.
*/
module tb ();

  // Dump the signals to a VCD file. You can view it with gtkwave or surfer.
  initial begin
    $dumpfile("tb.vcd");
    $dumpvars(0, tb);
    #1;
  end

    reg clock;
    reg reset;
    reg [7:0] write_data;
    reg [7:0] address;
    reg mem_write;
    reg mem_read;
    wire [7:0] read_data;

    // Instancia del módulo DM
    DM uut (
        .clock(clock),
        .reset(reset),
        .write_data(write_data),
        .address(address),
        .mem_write(mem_write),
        .mem_read(mem_read),
        .read_data(read_data)
    );

    // Generador de reloj
    initial begin
        clock = 0;
        forever #5 clock = ~clock; // Periodo de 10ns
    end

    initial begin
        // Inicialización
        reset = 1;
        mem_write = 0;
        mem_read = 0;
        write_data = 8'b0;
        address = 8'b0;

        #12; // Espera un ciclo de reloj
        reset = 0;

        // Escritura en la dirección 10
        address = 8'd10;
        write_data = 8'hAA;
        mem_write = 1;
        #10;
        mem_write = 0;

        // Lectura de la dirección 10
        mem_read = 1;
        #10;
        mem_read = 0;

        // Escritura en la dirección 20
        address = 8'd20;
        write_data = 8'h55;
        mem_write = 1;
        #10;
        mem_write = 0;

        // Lectura de la dirección 20
        mem_read = 1;
        #10;
        mem_read = 0;

        // Lectura de la dirección 0 (debería ser 8'b11111111 por el reset)
        address = 8'd0;
        mem_read = 1;
        #10;
        mem_read = 0;

        // Lectura de la dirección 1 (debería ser 8'b00000000 por el reset)
        address = 8'd1;
        mem_read = 1;
        #10;
        mem_read = 0;

        $stop;
    end


endmodule

module delay_1BCK (lrck, bck, lrck_out);

    input lrck;
    input bck;
    output lrck_out;

    reg lrck_out;
    reg lrck_before;

    always @ (posedge bck)
    begin
        lrck_before <= lrck;
    end

    always @ (negedge bck)
    begin
        lrck_out <= lrck_before;
    end

endmodule

module half_freq(bck, lrck_changed, bck_out);
    input bck;
    input lrck_changed;
    output bck_out;

    reg bck_out;

    always @ (negedge bck)
    begin
        if(lrck_changed == 1)
        begin
            bck_out <= 0; 
        end
        else
        begin
            bck_out <= ~bck_out;
        end
    end

endmodule

module make_WCK(bck, lrck, WCK);

    input bck;
    input lrck;
    output WCK;

    reg delayed_lrck = 0;
    reg[7:0] lrck_fifo;

    assign WCK = lrck ~^ delayed_lrck;

    always @ (posedge bck)
    begin
        lrck_fifo <= {lrck_fifo[6:0],lrck};
    end

    always @ (negedge bck)
    begin
        delayed_lrck <= lrck_fifo[7];
    end

endmodule
//I2Sを16LJに変換
module I2S_to_16LJ(bck, data, lrck, bck_out, data_out, lrck_out, lrck2_out);

    input bck;
    input data;
    input lrck;
    output bck_out;
    output data_out;
    output lrck_out;
	 output lrck2_out;

    reg data_out = 0;           
    reg[4:0] data_counter = 0 ; //元のI2Sにおける何bitめのDATAか
    reg[31:0] data_fifo = 0;    //元のI2S DATA (32bit) を 1sample分格納する

    //LRCK を 元々のBCK2周期分遅らせる
    wire lrck_32LJ;
    delay_1BCK I2S_to_32LJ (lrck, bck, lrck_32LJ);
    delay_1BCK delay (lrck_32LJ, bck, lrck_out);  
	 
	 // 2x LRCK
	 make_WCK lrck2x(bck_out, lrck_out, lrck2_out);
	 //assign lrck2_out = 0;

    //BCKを2分周
    //元のBCKに同期して、lrck_changedでリセットをかける
    reg lrck_changed;
    half_freq half_freq_ins (bck, lrck_changed, bck_out);

    //分周したBCKに同期させてDATA出力をする
    reg lrck_before = 0;
    always @ (posedge bck)
    begin
        //lrckの切り替わりを検出、読んでるbitのインデックスを0にする
        if(lrck_before != lrck_32LJ)
        begin
            data_counter <= 0;
            data_fifo[0] <= data;
            lrck_changed <= 1;
        end
        else
        begin
            data_counter <= data_counter + 1;
            data_fifo[data_counter + 1] <= data;
            lrck_changed <= 0;
        end
        lrck_before <= lrck_32LJ;
    end

    always @ (negedge bck_out)
    begin
        data_out <= data_fifo [data_counter / 2];
    end

endmodule
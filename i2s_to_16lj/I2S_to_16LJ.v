//I2S��16LJ�ɕϊ�
module I2S_to_16LJ(bck, data, lrck, bck_out, data_out, lrck_out, lrck2_out);

    input bck;
    input data;
    input lrck;
    output bck_out;
    output data_out;
    output lrck_out;
	 output lrck2_out;

    reg data_out = 0;           
    reg[4:0] data_counter = 0 ; //����I2S�ɂ����鉽bit�߂�DATA��
    reg[31:0] data_fifo = 0;    //����I2S DATA (32bit) �� 1sample���i�[����

    //LRCK �� ���X��BCK2�������x�点��
    wire lrck_32LJ;
    delay_1BCK I2S_to_32LJ (lrck, bck, lrck_32LJ);
    delay_1BCK delay (lrck_32LJ, bck, lrck_out);  
	 
	 // 2x LRCK
	 make_WCK lrck2x(bck_out, lrck_out, lrck2_out);
	 //assign lrck2_out = 0;

    //BCK��2����
    //����BCK�ɓ������āAlrck_changed�Ń��Z�b�g��������
    reg lrck_changed;
    half_freq half_freq_ins (bck, lrck_changed, bck_out);

    //��������BCK�ɓ���������DATA�o�͂�����
    reg lrck_before = 0;
    always @ (posedge bck)
    begin
        //lrck�̐؂�ւ������o�A�ǂ�ł�bit�̃C���f�b�N�X��0�ɂ���
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
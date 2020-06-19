# i2s_to_lj16

* CPLD XC9572XL-VQ44 で動作
* 2xWCK を出力 (`lrck2_out`)

## 配線

3.3Vから5Vへレベル変換推奨ですが、そのまま接続しても動作すると思います。(未確認)

* P5: I2S data in
* P6: I2S BCK in
* P7: I2S LRCK in
* P12: BCK out (CX20017の6,9ピン)
* P13: LRCK out (CX20017の7ピン)
* P14: Data out (CX20017の10ピン)
* P16: 2xLRCK out (CX20017の8,12ピン)


## Acknowledgements

* [I2S→16bit左詰めフォーマット　への変換をFPGAで - Qiita](https://qiita.com/torinomiya/items/701b65c82e598f1d54b0)

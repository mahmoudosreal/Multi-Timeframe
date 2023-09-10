// This source code is subject to the terms of the Mozilla Public License 2.0 at https://mozilla.org/MPL/2.0/
// @mahmoudos / www.mahmoudos.com

//@version=5
indicator("Multi-Timeframe", shorttitle = "Get the trend analysis of (other or same) pairs in multi timeframe")

// mahmoudos: Getting user input
resolution1 = input.timeframe(defval = "240", title="#1 Firts TimeFrame")
resolution2 = input.timeframe(defval = "1D", title="#2 Second TimeFrame")
resolution3 = input.timeframe(defval = "1W", title="#3 Third TimeFrame")
emaLen = input.int(defval = 20, title = "EMA Lengt")
market = input.symbol(defval = "BINANCE:BTCUSDT", title = "Market")

// mahmoudos: To simplify the code define a custom security function with no repainting issue
secFunction(_someMarket, _someResolution, _someExpression) =>
    request.security(_someMarket, _someResolution, _someExpression[barstate.isrealtime ? 1 : 0])[barstate.isrealtime ? 0 : 1]

// mahmoudos: Getting the EMA values
ema = ta.ema(close, emaLen)
emaValue1 = secFunction(market, resolution1, ema)
emaValue2 = secFunction(market, resolution2, ema)
emaValue3 = secFunction(market, resolution3, ema)

// mahmoudos: Getting price values
marketPrice1 = secFunction(market, resolution1, close)
marketPrice2 = secFunction(market, resolution2, close)
marketPrice3 = secFunction(market, resolution3, close)

// mahmoudos: Returning is the market price is above or below the ema value is each resolution
filter1 = marketPrice1 > emaValue1
filter2 = marketPrice2 > emaValue2
filter3 = marketPrice3 > emaValue3

// mahmoudos: changing background color #1
row1 = hline(0, color = color.black)
row2 = hline(1, color = color.black)
fill(row1, row2, filter1 ? color.green : color.red)
label f1lable = na

row3 = hline(1, color = color.black)
row4 = hline(2, color = color.black)
fill(row3, row4, filter2 ? color.green : color.red)
label f2lable = na

row5 = hline(2, color = color.black)
row6 = hline(3, color = color.black)
fill(row5, row6, filter3 ? color.green : color.red)
label f3lable = na

// mahmoudos: plot baby plot
if barstate.islast
    label.delete(f1lable[1])
    f1lable := label.new(bar_index, 0.5, resolution1, tooltip = "EMA = "+ str.tostring(emaValue1, "#.##"), color = color.new(color.black,100), textcolor = color.white, style = label.style_label_left)
    label.delete(f2lable[2])
    f2lable := label.new(bar_index, 1.5, resolution2, tooltip = "EMA = "+ str.tostring(emaValue2, "#.##"), color = color.new(color.black,100), textcolor = color.white, style = label.style_label_left)
    label.delete(f3lable[2])
    f3lable := label.new(bar_index, 2.5, resolution3, tooltip = "EMA = "+ str.tostring(emaValue3, "#.##"), color = color.new(color.black,100), textcolor = color.white, style = label.style_label_left)
    var mahmoudosTable = table.new(position.middle_center, 1, 3)
    mahmoudosTable.cell(0,0, resolution3, text_color=color.white)
    mahmoudosTable.cell(0,1, resolution2, text_color=color.white)
    mahmoudosTable.cell(0,2, resolution1, text_color=color.white)

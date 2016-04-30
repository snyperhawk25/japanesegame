

--------------------------------------------------------------------------------
-- GAME 2 QUESTIONS (questions[] 0 to 9)
--------------------------------------------------------------------------------

require("vocab")

 -- q is the question text.
 -- a1, a2, a3 are the options/different answers to choose from.
 -- ans is which of a1, a2, and a3 are the correct answer.
 -- t1, t2, t3, are just words of what image should appear, using to test
 -- and make sure it works instead of fiddling with image size.
 -- audio is... the audio.
 

--B. After confirming the proper language of the below (detailed in 
-- Number Game Language Review, sent back from Julia), I have added 
-- the ".qj" element to each question array. It contains the string
-- literal of the questions.

--B. I have not updated the vocab in the ".q" elements of each
-- question. Due to time constraints.

question = {}

 -- bag
question[0] = {}

question[0].qj = "かばん　は　どれですか ?"
question[0].q = syl[11][2] .. hiragana["ba"] .. hiragana["n"] .. " " .. hiragana["wa"] .. " " .. hiragana["ha"] .. " " .. hiragana["do"] .. hiragana["re"] .. " " .. hiragana["de"] .. hiragana["su"] .. " " .. hiragana["ka"] .. "?" 
question[0].a1 = "art/Game2/bag.png"
question[0].a2 = "art/Game2/book.png"
question[0].a3 = "art/Game2/door.png"
question[0].t1 = "bag"
question[0].t2 = "book"
question[0].t3 = "door"
question[0].ans = 1
question[0].audio = "audio/kaban.wav"

 -- book
question[1] = {}

question[1].qj = "ほん　は　どれですか？"
question[1].q = hiragana["ho"] .. hiragana["n"] .. " " .. hiragana["wa"] .. " " .. hiragana["ha"] .. " " .. hiragana["do"] .. hiragana["re"] .. " " .. hiragana["de"] .. hiragana["su"] .. " " .. hiragana["ka"] .. "?" 
question[1].a1 = "art/Game2/door.png"
question[1].a2 = "art/Game2/book.png"
question[1].a3 = "art/Game2/bag.png"
question[1].t1 = "door"
question[1].t2 = "book"
question[1].t3 = "bag"
question[1].ans = 2
question[1].audio = "audio/hon.ogg"
 
 -- clock
question[2] = {}

question[2].qj = "とけい　は　どれですか？"
question[2].q = hiragana["to"] .. hiragana["ke"] .. hiragana["i"].. " " .. hiragana["wa"] .. " " .. hiragana["ha"] .. " " ..  hiragana["do"] .. hiragana["re"] .. " " .. hiragana["de"] .. hiragana["su"] .. " " .. hiragana["ka"] .. "?" 
question[2].a1 = "art/Game2/window.png"
question[2].a2 = "art/Game2/clock.png"
question[2].a3 = "art/Game2/book.png"
question[2].t1 = "window"
question[2].t2 = "clock"
question[2].t3 = "book"
question[2].ans = 2
question[2].audio = "audio/tokei.ogg"
 
 -- door
question[3] = {}

question[3].qj = "ドア　は　どれですか？"
question[3].q = hiragana["do"] .. hiragana["a"] .. " " .. hiragana["ha"] .. " " .. hiragana["wa"] .. " " .. hiragana["do"] .. hiragana["re"] .. " " .. hiragana["de"] .. hiragana["su"] .. " " .. hiragana["ka"] .. "?" 
question[3].a1 = "art/Game2/bag.png"
question[3].a2 = "art/Game2/book.png"
question[3].a3 = "art/Game2/door.png"
question[3].t1 = "bag"
question[3].t2 = "book"
question[3].t3 = "door"
question[3].ans = 3
question[3].audio = "audio/doa.wav"
 
 -- hat
question[4] = {}

question[4].qj = "ぼうし　は　どれですか？"
-- question4.q = hiragana["bo"] .. hiragana["us"] .. hiragana["hi"] .. " " .. hiragana["wa"] .. " " .. hiragana["do"] .. hiragana["re"] .. " " .. hiragana["de"] .. hiragana["su"] .. " " .. hiragana["ka"] .. "?" 
question[4].q = "door" .. " " .. hiragana["wa"] .. " " .. hiragana["do"] .. hiragana["re"] .. " " .. hiragana["de"] .. hiragana["su"] .. " " .. hiragana["ka"] .. "?" -- Incorrect Japanese!
question[4].a1 = "art/Game2/umbrella.png"
question[4].a2 = "art/Game2/clock.png"
question[4].a3 = "art/Game2/door.png"
question[4].t1 = "umbrella"
question[4].t2 = "clock"
question[4].t3 = "door"
question[4].ans = 3
question[4].audio = "audio/boushi.wav"
 
 -- letter
question[5] = {}

question[5].qj = "てがみ　は　どれですか ?"
question[5].q = hiragana["te"] .. hiragana["ga"] .. hiragana["mi"] .. " " .. hiragana["wa"] .. " " .. hiragana["do"] .. hiragana["re"] .. " " .. hiragana["de"] .. hiragana["su"] .. " " .. hiragana["ka"] .. "?" 
question[5].a1 = "art/Game2/letter.png"
question[5].a2 = "art/Game2/wallet.png"
question[5].a3 = "art/Game2/umbrella.png"
question[5].t1 = "letter"
question[5].t2 = "wallet"
question[5].t3 = "umbrella"
question[5].ans = 1
question[5].audio = "audio/tegami.wav"

 -- telephone
question[6] = {}

question[6].qj = "でんわ　は　どれですか？"
question[6].q = hiragana["de"] .. hiragana["n"] .. hiragana["wa"] .. " " .. hiragana["wa"] .. " " .. hiragana["do"] .. hiragana["re"] .. " " .. hiragana["de"] .. hiragana["su"] .. " " .. hiragana["ka"] .. "?" 
question[6].a1 = "art/Game2/bag.png"
question[6].a2 = "art/Game2/telephone.png"
question[6].a3 = "art/Game2/window.png"
question[6].t1 = "bag"
question[6].t2 = "telephone"
question[6].t3 = "window"
question[6].ans = 2
question[6].audio = "audio/denwa.wav"
 
 -- umbrella
question[7] = {}

question[7].qj = "かさ　は　どれですか？"
question[7].q = hiragana["ka"] .. hiragana["sa"] .. " " .. hiragana["wa"] .. " " .. hiragana["do"] .. hiragana["re"] .. " " .. hiragana["de"] .. hiragana["su"] .. " " .. hiragana["ka"] .. "?" 
question[7].a1 = "art/Game2/clock.png"
question[7].a2 = "art/Game2/book.png"
question[7].a3 = "art/Game2/umbrella.png"
question[7].t1 = "clock"
question[7].t2 = "book"
question[7].t3 = "umbrella"
question[7].ans = 3
question[7].audio = "audio/kasa.wav"

 -- wallet
question[8] = {}

question[8].qj = "さいふ　は　どれですか？"
question[8].q = hiragana["sa"] .. hiragana["i"] .. " " .. hiragana["wa"] .. " " .. hiragana["do"] .. hiragana["re"] .. " " .. hiragana["de"] .. hiragana["su"] .. " " .. hiragana["ka"] .. "?" 
question[8].a1 = "art/Game2/bag.png"
question[8].a2 = "art/Game2/door.png"
question[8].a3 = "art/Game2/wallet.png"
question[8].t1 = "bag"
question[8].t2 = "door"
question[8].t3 = "wallet"
question[8].ans = 3
question[8].audio = "audio/saifu.wav"
 
 -- window
question[9] = {}

question[9].qj = "まど　は　どれですか？"
question[9].q = hiragana["ma"] .. hiragana["do"] .. " " .. hiragana["wa"] .. " " .. hiragana["do"] .. hiragana["re"] .. " " .. hiragana["de"] .. hiragana["su"] .. " " .. hiragana["ka"] .. "?" 
question[9].a1 = "art/Game2/window.png"
question[9].a2 = "art/Game2/umbrella.png"
question[9].a3 = "art/Game2/bag.png"
question[9].t1 = "window"
question[9].t2 = "umbrella"
question[9].t3 = "bag"
question[9].ans = 1
question[9].audio = "audio/mado.wav"

--------------------------------------------------------------------------------
-- GAME 3 QUESTIONS (questions[] 10 to 20)
--------------------------------------------------------------------------------

 -- bread
question[10] = {}

question[10].qj = "ぱん　を　ください！"
question[10].q = hiragana["pa"] .. hiragana["n"] .. " " .. hiragana["o"] .. " " .. hiragana["ku"] .. hiragana["da"] .. hiragana["sa"] .. hiragana["i"] .. "!" 
question[10].a1 = "art/Game3/bread.png"
question[10].a2 = "art/Game3/coffee.png"
question[10].a3 = "art/Game3/rice.png"
question[10].t1 = "bread"
question[10].t2 = "coffee"
question[10].t3 = "rice"
question[10].ans = 1
question[10].audio = "audio/pan.ogg"

 -- coffee
question[11] = {}

question[11].qj = "コーヒー　を　ください！"
question[11].q = hiragana["ko"] .. hiragana["hi"] .. " " .. hiragana["o"] .. " " .. hiragana["ku"] .. hiragana["da"] .. hiragana["sa"] .. hiragana["i"] .. "!" 
question[11].a1 = "art/Game3/fish.png"
question[11].a2 = "art/Game3/coffee.png"
question[11].a3 = "art/Game3/hamburger.png"
question[11].t1 = "fish"
question[11].t2 = "coffee"
question[11].t3 = "hamburger"
question[11].ans = 2
question[11].audio = "audio/kohi.ogg"
 
 -- fish
question[12] = {}

question[12].qj = "さかな　を　ください！"
question[12].q = hiragana["sa"] .. hiragana["ka"] .. hiragana["na"] .. " " .. hiragana["o"] .. " " .. hiragana["ku"] .. hiragana["da"] .. hiragana["sa"] .. hiragana["i"] .. "!" 
question[12].a1 = "art/Game3/water.png"
question[12].a2 = "art/Game3/coffee.png"
question[12].a3 = "art/Game3/fish.png"
question[12].t1 = "water"
question[12].t2 = "coffee"
question[12].t3 = "fish"
question[12].ans = 3
question[12].audio = "audio/fish.ogg"

 -- hamburger
question[13] = {}

question[13].qj = "ハンバーガー　を　ください！"
question[13].q = hiragana["ha"] .. hiragana["n"] .. hiragana["ba"] .. hiragana["ga"] .." " .. hiragana["o"] .. " " .. hiragana["ku"] .. hiragana["da"] .. hiragana["sa"] .. hiragana["i"] .. "!" 
question[13].a1 = "art/Game3/hamburger.png"
question[13].a2 = "art/Game3/coffee.png"
question[13].a3 = "art/Game3/meat.png"
question[13].t1 = "hamburger"
question[13].t2 = "coffee"
question[13].t3 = "meat"
question[13].ans = 1
question[13].audio = "audio/hanbaga.ogg"

 -- meat
question[14] = {}

question[14].qj = "にく　を　ください！"
question[14].q = hiragana["ni"] .. hiragana["ku"] .. " " .. hiragana["o"] .. " " .. hiragana["ku"] .. hiragana["da"] .. hiragana["sa"] .. hiragana["i"] .. "!" 
question[14].a1 = "art/Game3/coffee.png"
question[14].a2 = "art/Game3/meat.png"
question[14].a3 = "art/Game3/rice.png"
question[14].t1 = "coffee"
question[14].t2 = "meat"
question[14].t3 = "rice"
question[14].ans = 2
question[14].audio = "audio/meat.ogg"

 -- noodles
question[15] = {}

question[15].qj = "ラーメン　を　ください！"
question[15].q = hiragana["ra"] .. hiragana["me"] .. " " .. hiragana["n"] .. " " .. hiragana["ku"] .. hiragana["da"] .. hiragana["sa"] .. hiragana["i"] .. "!" 
question[15].a1 = "art/Game3/noodles.png"
question[15].a2 = "art/Game3/meat.png"
question[15].a3 = "art/Game3/bread.png"
question[15].t1 = "noodles"
question[15].t2 = "meat"
question[15].t3 = "bread"
question[15].ans = 1
question[15].audio = "audio/ramen.ogg"

 -- rice
question[16] = {}

question[16].qj = "ごはん　を　ください！"
question[16].q = hiragana["go"] .. hiragana["ha"] .. hiragana["n"] .. " " .. hiragana["o"] .. " " .. hiragana["ku"] .. hiragana["da"] .. hiragana["sa"] .. hiragana["i"] .. "!" 
question[16].a1 = "art/Game3/water.png"
question[16].a2 = "art/Game3/tea.png"
question[16].a3 = "art/Game3/rice.png"
question[16].t1 = "water"
question[16].t2 = "tea"
question[16].t3 = "rice"
question[16].ans = 3
question[16].audio = "audio/rice.ogg"

 -- salad
question[17] = {}

question[17].qj = "サラダ　を　ください！"
question[17].q = hiragana["sa"] .. hiragana["ra"] .. hiragana["da"] .. " " .. hiragana["o"] .. " " .. hiragana["ku"] .. hiragana["da"] .. hiragana["sa"] .. hiragana["i"] .. "!" 
question[17].a1 = "art/Game3/noodles.png"
question[17].a2 = "art/Game3/salad.png"
question[17].a3 = "art/Game3/coffee.png"
question[17].t1 = "noodles"
question[17].t2 = "salad"
question[17].t3 = "coffee"
question[17].ans = 2
question[17].audio = "audio/ramen.ogg" -- No audio for Sarada was given, currently using Ramen in its place!

 -- tea
question[18] = {}

question[18].qj = "おちゃ　を　ください！"
question[18].q = "" .. " " .. hiragana["o"] .. " " .. hiragana["ku"] .. hiragana["da"] .. hiragana["sa"] .. hiragana["i"] .. "!" -- Needs to be changed to Japanese!
question[18].a1 = "art/Game3/rice.png"
question[18].a2 = "art/Game3/coffee.png"
question[18].a3 = "art/Game3/tea.png"
question[18].t1 = "rice"
question[18].t2 = "coffee"
question[18].t3 = "tea"
question[18].ans = 3
question[18].audio = "audio/ocha.ogg" 

 -- vegetables
question[19] = {}

question[19].qj = "やさい　を　ください！"
question[19].q = hiragana["ya"] .. hiragana["sa"] .. hiragana["i"] .. " " .. hiragana["o"] .. " " .. hiragana["ku"] .. hiragana["da"] .. hiragana["sa"] .. hiragana["i"] .. "!" 
question[19].a1 = "art/Game3/vegetables.png"
question[19].a2 = "art/Game3/water.png"
question[19].a3 = "art/Game3/tea.png"
question[19].t1 = "vegetables"
question[19].t2 = "water"
question[19].t3 = "tea"
question[19].ans = 1
question[19].audio = "audio/yasai.ogg"

 -- water
question[20] = {}

question[20].qj = "みず　を　ください！"
question[20].q = hiragana["mi"] .. hiragana["zu"] .. " " .. hiragana["o"] .. " " .. hiragana["ku"] .. hiragana["da"] .. hiragana["sa"] .. hiragana["i"] .. "!" 
question[20].a1 = "art/Game3/bread.png"
question[20].a2 = "art/Game3/coffee.png"
question[20].a3 = "art/Game3/water.png"
question[20].t1 = "bread"
question[20].t2 = "coffee"
question[20].t3 = "water"
question[20].ans = 3
question[20].audio = "audio/mizu.ogg"

 -- lamian -- I don't know what this is and don't have a translation of it
 --[[
question[10] = {}

question[10].q = hiragana[""] .. hiragana[""] .. " " .. hiragana["o"] .. " " .. hiragana["ku"] .. hiragana["da"] .. hiragana["sa"] .. hiragana["i"] .. "!" 
question[10].a1 = "art/Game3/.png"
question[10].a2 = "art/Game3/.png"
question[10].a3 = "art/Game3/.png"
question[10].t1 = ""
question[10].t2 = ""
question[10].t3 = ""
question[10].ans = 1
question[10].audio = "audio/.ogg" ]]--
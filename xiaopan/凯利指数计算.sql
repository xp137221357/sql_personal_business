-- 计算凯利指数
G3=odd3*avgp3，G1=odd1*avgp1，G0=odd0*avgp0；(odd3:胜赔，odd1:平赔，odd0：负赔，avgp3欧平均胜率，avgp1欧平均平率，avgp0欧平均负率)

平均主胜率avgp3=(p31+p32+….p3n)/n

主胜率P3=r/odd3(r:赔付率)

赔付率（返还率）又是这样求的：r=1/(1/odd3+1/odd1+1/odd0)

-- function return_rate(a,b,c)
return 1/(1/a+1/b+1/c)

-- function win_rate(a,b)
return a/b

-- function kaili_index(a,b)
return a*b




import excel "C:\Users\TAF Lucas\Desktop\Mémoire\BASE FINALE.xlsx", sheet("Feuil2") firstrow

gen Rect_p = log( recettespropre)
gen Trans_i = log( Transfertinvest)
gen FADeC_i = log( FADeCinvest)
gen FADeC_fo = log( FADeCfonct)
gen Rect_nfi = log( recettenonfisc)
gen Rect_fi = log( recettefisc)
gen Deps_fo = log( depensefonct)
gen Deps_i = log( depenseinvst)
gen Pop = log( population)
gen Cap_i = log( capacitéinvest)
gen FADeC_a = log( fadecaffecté )
gen FADeC_na = log( fadecnonaffecté )
pwcorr Rect_p Trans_i FADeC_a FADeC_na Cap_i Deps_i Deps_fo Rect_fi Rect_nfi, sig
xtset Identifiant Année
tab Année, gen( Année)
reg Rect_p L.Rect_p FADeC_a FADeC_na Rect_nfi Rect_fi Deps_fo Deps_i Cap_i Trans_i Année3 Année4 Année5 Année6
estat vif

*model 1
xtabond2 Rect_p L.Rect_p FADeC_a FADeC_na Rect_nfi Rect_fi Deps_fo Deps_i Cap_i Trans_i Année3 Année4 Année5 Année6, two robust small gmm( L.Rect_p, lag(2 .) collapse) gmm( Deps_fo, lag(2 .) collapse) gmm( Rect_fi Rect_nfi Trans_i FADeC_na, lag(1 .) collapse) iv( FADeC_a Cap_i Deps_i Année3 Année4 Année5 Année6)
lincom L.Rect_p - 1

*model 2
xtreg Rect_nfi Trans_i FADeC_a FADeC_na Cap_i Rect_fi Deps_fo Deps_i, fe
est store fe1
xtreg Rect_nfi Trans_i FADeC_a FADeC_na Cap_i Rect_fi Deps_fo Deps_i, re
est store re1
xttest0
xtreg Rect_nfi Trans_i FADeC_a FADeC_na Cap_i Rect_fi Deps_fo Deps_i, re
predict residu2
sktest residu2
xtserial residu2
gen residu2carré = residu2^2
reg residu2carré Trans_i FADeC_a FADeC_na Cap_i Rect_fi Deps_fo Deps_i
hettest
xtgls Rect_nfi Trans_i FADeC_a FADeC_na Cap_i Rect_fi Deps_fo Deps_i, panels(hetero)

*model 3
xtreg Rect_fi Trans_i FADeC_a FADeC_na Cap_i Rect_nfi Deps_fo Deps_i, fe
est store Fe1
xtreg Rect_fi Trans_i FADeC_a FADeC_na Cap_i Rect_nfi Deps_fo Deps_i, re
est store Re1
xttest0
xtreg Rect_fi Trans_i FADeC_a FADeC_na Cap_i Rect_nfi Deps_fo Deps_i, re
predict residu3
sktest residu3
xtserial residu3
gen residu3carré = residu3^2
reg residu3carré Trans_i FADeC_a FADeC_na Cap_i Rect_nfi Deps_fo Deps_i
hettest
xtgls Rect_fi Trans_i FADeC_a FADeC_na Cap_i Rect_nfi Deps_fo Deps_i, panels(hetero)

*model 4
xtreg Deps_fo Trans_i FADeC_a FADeC_na Rect_nfi Rect_fi Deps_i Cap_i, fe
est store fex
xtreg Deps_fo Trans_i FADeC_a FADeC_na Rect_nfi Rect_fi Deps_i Cap_i, re
est store rex
xttest0
xtreg Deps_fo Trans_i FADeC_a FADeC_na Rect_nfi Rect_fi Deps_i Cap_i, re
predict residu4
sktest residu4
xtserial residu4
gen residu4carre = residu4^2
reg residu4carre Trans_i FADeC_a FADeC_na Rect_nfi Rect_fi Deps_i Cap_i
hettest
xtgls Deps_fo Trans_i FADeC_a FADeC_na Rect_nfi Rect_fi Deps_i Cap_i, panels(hetero)

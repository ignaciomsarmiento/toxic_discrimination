/*
Replication files for "Housing Discrimination and the Pollution Exposure Gap in the United States" 
*/


clear all
set matsize 11000

use "../stores/toxic_discrimination_data.dta"


keep if sample==1

************************************************************************************************
* Balance Statistics
************************************************************************************************
gen first=(inquiry_order=="1")
gen second=(inquiry_order=="2")
gen third=(inquiry_order=="3")
gen Mon=(inquiry_weekday==3)
gen Tue=(inquiry_weekday==7)
gen Wed=(inquiry_weekday==8)
gen Thurs=(inquiry_weekday==6)
gen Fri=(inquiry_weekday==2)
gen Male=(gender==2)
gen Female=(gender==1)
gen Low=(education_level==2)
gen Medium=(education_level==3)
gen High=(education_level==1)

************************************************************
* Panel A
************************************************************

est clear
foreach i in first second third {
  eststo: disc_boot `i' Hispanic Black 
  estimates store model`i'

}


************************************************************
* Panel B
************************************************************

foreach i in Mon Tue Wed Thurs Fri {
  eststo: disc_boot `i' Hispanic Black 
  estimates store model`i'

}


************************************************************
* Panel C
************************************************************

foreach i in Male Female Low Medium High {
  eststo: disc_boot `i' Hispanic Black
  estimates store model`i'

}




************************************************************
* estout Panel A
************************************************************



#delimit ; 
esttab modelfirst 
       modelsecond 
       modelthird
       using "../views/tableA5.tex", 
       style(tex) 
       cells(b(star fmt(4)) se(par fmt(4)))
       label 
       noobs
       mlabels(,none)  
       nonumbers 
       collabels(,none) 
       eqlabels(,none)
       varlabels(Black "African American"
                 Hispanic "Hispanic/LatinX") 
       starl(* 0.1 ** 0.05 *** 0.01)   
       keep( Black Hispanic )              
       order( Black Hispanic )
       level(90)     
       prehead( 
                \begin{table}[H]
                \scriptsize \centering
                \begin{threeparttable}
                \captionsetup{justification=centering}
                \caption{Balance Statistics}
                \label{tab:balance}

                \begin{tabular}{@{\extracolsep{5pt}}lccccc}
                \\[-1.8ex]\hline
                \hline \\[-1.8ex]
                 &  (1) & (2) & (3) & (4) & (5) \\
                 \cline{2-6}
                 \multicolumn{6}{c}{\textit{Panel A: {\it  Inquiry Order}}} \\
                 \hline \\[-1.8ex] 
                 & First & Second & Third & & \\
       )
       posthead() 
      prefoot() 
       postfoot(
            \\[-1.8ex]\hline 
      \hline \\[-1.8ex] )
       
       replace;
#delimit cr

************************************************************
* estout Panel B
************************************************************

#delimit ; 
esttab modelMon 
       modelTue 
       modelWed 
       modelThurs 
       modelFri
       using "../views/tableA5.tex", 
       style(tex) 
       level(90)
       cells(b(star fmt(4)) se(par fmt(4)))
       label 
       noobs
       mlabels(,none)
       nonumbers 
       collabels(,none)      
       eqlabels(,none)
       varlabels(Black "African American"
                 Hispanic "Hispanic/LatinX") 
       starl(* 0.1 ** 0.05 *** 0.01)   
       keep( Black Hispanic )              
       order( Black Hispanic )     
       prehead( 
               \multicolumn{6}{c}{\textit{Panel B: Evidence of Differential Choices by Weekday}} \\
               \hline \\[-1.8ex]

              \\[-1.8ex] & Monday & Tuesday & Wednesday & Thursday & Friday \\ 
       )
       posthead() 
       prefoot() 
       postfoot(
            \\[-1.8ex]\hline 
      \hline \\[-1.8ex] )
       
       append;
#delimit cr


************************************************************
* estout Panel C
************************************************************


#delimit ; 
esttab modelMale
       modelFemale
       modelLow 
       modelMedium
       modelHigh
       using "../views/tableA5.tex", 
       style(tex) 
       cells(b(star fmt(4)) se(par fmt(4)))
       label 
       noobs
       mlabels(,none)  
       nonumbers
       collabels(,none) 
       eqlabels(,none)
       varlabels(Black "African American"
                 Hispanic "Hispanic/LatinX") 
       starl(* 0.1 ** 0.05 *** 0.01) 
       stats(obs
             listings
             diff_response, fmt( %9.0gc %9.0gc 2)
             labels("\hline Observations"
                   "Listings"
                   "\% w. diff. response"
                   ))   
       keep( Black Hispanic )              
       order( Black Hispanic )
       level(90)     
       prehead( 
               \multicolumn{6}{c}{\textit{Panel C: Gender and Mother's Education Level}} \\
               \hline \\[-1.8ex]

                &   \multicolumn{2}{c}{Gender} &   \multicolumn{3}{c}{Mother's Education } \\
                & Male & Female & Low  & Medium   & High  \\ 
       )
       posthead() 
      prefoot() 
       postfoot(
            \\[-1.8ex]\hline 
      \hline \\[-1.8ex] 
      \end{tabular} 

      \begin{tablenotes}[scriptsize,flushleft] \scriptsize
      \item Notes: Table reports balance statistics for the experimental data set. It shows the coefficients of logistic regression on different outcomes. In Panel A, the dependent variable takes 1 or 0 depending the order in which the inquiry was sent out, i.e. in Column (1) takes 1 if the inquiry was sent first and 0 otherwise. In Panel B, takes 1 or 0 depending the weekday the inquiry was sent. Panel C, does the same for male and females, and levels of maternal education. Standard errors are clustered at the ZIP code level using a score wild bootstrap proposed \cite{kline2012score} to account for the small number of clusters. *\$P< 10\%$ level, **\$P < 5\%$ level, ***\$P<1\%$ level.
      \end{tablenotes}
      \end{threeparttable}
      \end{table}
      )
       
       append;
#delimit cr



*end 
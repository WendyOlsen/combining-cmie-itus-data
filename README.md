# combining-cmie-itus-data 

Combining CMIE-ITUS Data With Bayesian Estimation


Github address:  https://github.com/WendyOlsen/combining-cmie-itus-data/

This repository holds code and figures as well as appendix material for papers about combining-cmie-itus-data using Bayesian estimation methods. The papers look at time-use of women and men in India during a period 2019-2020 when a tertile (4-month interval) survey, CMIE was used to augment the Indian Time-Use Survey of 2019.  Both used large national samples, which had a multi-stage clustered and stratified selection procedure. The CMIE however did not have lists of village or town residents except insofar as they created such lists.  Therefore, their sampling method was different at the final stage within the final sampled geographic units.  

You must cite the code: 
Code from Wendy Olsen, Manasi Bera, Greg Dropkin, Amaresh Dubey, Jihye Kim, Ioana Macoveciuc, Samantha Watson, and Arkadiusz Wiśniowski (2021), Combining CMIE-ITUS Data With Bayesian Estimation, https://github.com/WendyOlsen/combining-cmie-itus-data/, Creative commons attribution. 

Two Key Publications by this Team on this Project:
*Wendy Olsen, Manasi Bera, Amaresh Dubey, Jihye Kim, Ioana Macoveciuc, Samantha Watson, Arkadiusz Wiśniowski (2021), Methods of Combining Time-use Diary Data with Economic Survey Data: How the COVID-19 Pandemic Affected Gendered Work Patterns in India in 2019-2020 Conference paper International Association for Time Use Research Conference 27-29 October, for submission to SSRN and International Journal of Population Data Science. 

Wendy Olsen, Manasi Bera, Amaresh Dubey, Jihye Kim, Arkadiusz Wiśniowski, Samantha Watson, Linking Data Sets to Trace the COVID-19 Pandemic’s Effects on Women’s Work in India”, Department of Statistics, International Labour Office, Geneva, Switzerland. 

Citing the datasets:
National Sample Survey Office (NSSO 2020a), Time Use in India, Delhi:  Government of India, Ministry of Statistics and Programme Implementation. URL www.mospi.gov.in and http://mospi.nic.in/sites/default/files/publication_reports/Report_TUS_2019_0.pdf, accessed April 2021. Data can be downloaded at URL http://mospi.nic.in/time-use-survey-0, accessed April 2021.
and
National Sample Survey Office (NSSO, 2020a), Note on sample design and estimation procedure of Time Use Survey, Government of India, Ministry of Statistics and Programme Implementation, URL http://mospi.nic.in/sites/default/files/Estimation%20procedure_TUS.pdf, accessed April 2021.
National Sample Survey Office (NSSO, 2020b), Instructions to Field Staff [Schedules], Time Use Survey, Government of India, Ministry of Statistics and Programme Implementation, URL http://mospi.nic.in/sites/default/files/TUS_Schedules.pdf, accessed April 2021.
and
Centre for Monitoring Indian Economic (CMIE) Consumer Pyramids survey (no date), URL https://consumerpyramidsdx.cmie.com/kommon/bin/sr.php?kall=wkb, accessed 2021. 


Key Previous Work Showing Bayesian Poisson Modelling with Data-Combining:
Olsen, Wendy, Manasi Bera, Amaresh Dubey, Jihye Kim, Arkadiusz Wiśniowski, Purva Yadav (2020). Hierarchical Modelling of COVID-19 Death Risk in India in the Early Phase of the Pandemic, December 2020, European Journal of Development Research.

Support for Using R Stan Package
Stan Development Team (2019), Stan User’s Guide, Version 2.25, Creative commons. See also URL https://mc-stan.org/rstan/reference/stanfit-method-loo.html, accessed 2021.

Acknowledgements: We thank the International Labour Office, whose statistics department has helped to fund this #research. We thank the project's Delhi host institution:  Indian Institute for Dalit Studies (IIDS), which hosted the CMIE dataset, and the academics Dr. Bera and Prof. Dubey who were critical to success of this project.    
October 2021

*Abstract
Introduction: India’s female Labour Force Participation rate (FLPR) is extremely low. Its FLPR shows a secular decline 1994-2018. Policy stakeholders are concerned about measurement error so they created a large Indian Time-use Survey (ITUS 2019). The problem is how to utilise the 2019 data for future modelling exercises.
Objectives: This paper shows how combining datasets enables modelling of shocks to the labour-market over time. We analyse shifts from paid to unpaid forms of work over the 2020 period of the Covid pandemic.
Methods: A new, robust methodology uses two survey data sets, India Time Use Survey 2019 and CMIE’s Consumer Pyramid Survey. Data are combined using Bayesian methods. We discuss several possible combined-data modelling approaches:  random+random; random+non-random; and random+administrative. We also carefully manage which work type is perceived as dominant in operationalising a person’s time spent working. An older framework tends to label persons’ labour status, but the recording of each person’s whole mixture of work types – paid and unpaid- offers analysis which at the other extreme is more accurate. Our approach distinguishes uncertainty arising from sample sizes versus measurement errors. 
This paper discusses key definitions first.  Then using the two datasets at once, Bayesian parameter simulation via Markov Chain Monte Carlo methods creates a combined panel estimate for the ‘minutes’ worked using a fractional logit split model. Unemployment is also examined over 2019-2020. 
Results: It was feasible to estimate the fractional logit regressions by writing code in R Stan package; a 5% sample of cases was sufficient for convergence; regression slope coefficients were different with data-combining than without; weak priors led to different credible intervals than using strong priors based on the ITUS data.
Conclusions: Overall, we explain how a methodological advancement can apply Bayesian estimation to time-use data in the context of rapid change and economic shocks in the COVID-19 pandemic period.




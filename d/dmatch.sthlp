{smcl}
{* *! version 1.0.0  22Nov2019}{...}
{cmd:help dmatch}
{hline}


{title:Title}

{p2colset 5 16 17 2}{...}
{p2col :{cmd:dmatch} {hline 1}} Match two datasets using a nonparametric method. Before using the command, users should append the source data to the target data so that the new dataset is in the long format. {p_end}
{p2colreset}{...}

{title:Syntax}

{p 8 17 2}{opt dmatch}   {matchvar} [{predictvars}] {ifin} {cmd:,} 
uniqid(varlist) todata(varlist) [{it:options}]

{synoptset 36 tabbed}{...}
{synoptline}
{synopthdr}
{synoptline}
{syntab:{title:Required}}

{synopt:{opt {matchvar}}} A variable to rank distribution and to do the distributional match. It must be a common variable in both datasets. {p_end}
{synopt:{opt {predictvars}}} A varlist that users would like to predict for the target data, or the varlist that is missing in the target data. {p_end}
{synopt:{opt uniqid(varlist)}} A varlist that can uniquely identify observations in the new data; used to ensure replicability. {p_end}
{synopt:{opt todata(varlist max=1)}} A binary variable indicating whether the observation is from the source or target data; equal to 1 if the respondent is from the target data and 0 otherwise. {p_end}

{syntab:{title:Optional}}


{synopt:{opt seed(integer)}}  Used to ensure replicability. The default is 12345. {p_end}
{synopt:{opt strata(varlist max=1)}} A variable that identifies strata, such as region.  If strata() is specified,
       the distribution match is done by strata. The definition of strata should be consistent in the source and target data.{p_end}
{synopt:{opt trimvar(varlist max=1 numeric)}} A variable used for trimming the source dataset to exclude outliers. The default trimvar is matchvar. This option should be used with trimup and/or trimdown option. {p_end}
{synopt:{opt trimup(numlist integer >=90  & <=99)}} An integer between 90 and 99 to indicate the removal of values above that percentile. This option is used to drop outliers in the upper tail. {p_end}
{synopt:{opt trimlow(numlist integer >0 & <=10)}} An integer between 1 and 10 to indicate the removal of values below that percentile. This option is used to drop outliers in the lower tail. {p_end}

{title:Description}
{p 4 4 2}
This command matches two datasets using a nonparametric method, and it is often used to match expenditure survey with labor force survey. It first draws a random sample with replacement from the source data, keeping the number of observations the same as that of the target data. Then it conducts a 1:1 pairing of observations between the target data and the random sample by matching the distributions of a specified variable in the two datasets (matchvar). This method can bring over all interested vectors simultaneously which save significant amount of computation time. Before using the command, users should append the source to the target data so that the new dataset is in the long format. {p_end}

{title:Example}
{p 4 8 2}
    Setup {break}
	.sysuse auto, clear 

    Prepare the source and target data: randomly select some observations and treat them as target data; the remaining are considered as source data
	.set seed 12345 
	.gen random = runiformint(1,74)  	
	
    Generate a variable {it:target} indicating whether it is source or target data
	.gen target	= 1 if random < 11  
	.replace target	= 0 if random >= 11  
	
    Generate missing values in the target data so that we can predict them using dmatch command later
	.replace weight = . if random < 11  
	.replace trunk 	= . if random < 11   
	 
    Generate id that can uniquely identify observations in this new data	
	.gen id = _n  

    Conduct the matching 
	.dmatch length weight trunk, uniqid(id) todata(target) strata(foreign) trimvar(length)  trimlow(1) trimup(95)



{title:Authors:}

{pstd}
Paul Corral{break}
The World Bank - Poverty and Equity Global Practice {break}
Washington, DC{break}
Corresponding author{break} 
pcorralrodas@worldbank.org{p_end}

{pstd}
Jia Gao{break}
The World Bank - Poverty and Equity Global Practice {break}
Washington, DC{break}
Corresponding author{break} 
jgao4@worldbank.org{p_end}


{title:Disclaimer}

{pstd}
Any error or omission is the authors' responsibility alone.




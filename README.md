#  R Shiny Labor Force Statistics

## [Interactive Project Link][]

This is a data analysis writeup  for the R [Shiny][] application - **Labor Force Statistics**, built to
visualize labor statistics trends over a number of variables e.g. races and genders.

------

## Contents
-   [Summary](#summary)
-   [Labor Force Trends](#labor-force-trends)
-   [Employment by Occupation](#employment-by-occupation)
    -   [A quick overview](#a-quick-overview)
    -   [Men-dominated Industries](#men-dominated-industries)
    -   [Education and Health Sector](#education-and-health-sector)
    -   [Public Administration Sector](#public-administration-sector)
    -   [Business and Finance Sector](#business-and-finance-sector)
-   [Employment by
    Education](#employment-by-education)
    -   [By gender](#by-gender)
    -   [By race](#by-race)
-   [Conclusion](#conclusion)
-   [Data](#data)
    -   [Data Source](#data-source)
    -   [Data Scraping](#data-scraping)
    -   [Data Munging](#data-munging)
    -   [Data Recap](#data-recap)
-   [Resources](#resources)

------

## Summary
In this visualization application, we want to draw conclusions and trends about labor statistics in the US, by 
comparing employment and unemployment rates across races, genders, occupations, and education levels.

The original datasets are derived from the Current Population Survey ([CPS][]) released by the Bureau of Labor 
Statistics.  The native HTML table presentation of the data makes it difficult to *visualize and derive trends*.

Take a look at this:

![image-cps-02][]

as opposed to this:

![image-trend-unemployed-rate][]

We will delve into details on some interesting topics revolved around:

-   Labor Force Trends ([cps-02][])
-   Employment by Occupation ([cps-14][])
-   Employment by Education ([cps-07][])

The writeup will go into detailed analysis on some of the more interesting findings in the visualization sections.

At any time, feel free to experiment and draw your own conclusions with the interactive web application and refer to
the `.R` files found on the [Github][] project site if you need details on code implementation.

<sub>(back to [contents](#contents))</sub>

------

## Labor Force Trends

### What does the US population look like?

![image-trend-population][]

It appears that the US population is still *growing*.  In addition, note that the population of women is *higher* than
men.

### So who is NOT working in the labor force?

![image-trend-non-labor-force][]

We see that a proportionately larger number of women are still not in the labor force, despite a slightly larger 
women population.

The next bar chart provides another view on the labor force by gender, by looking at employment *rates* instead of 
raw population headcount as displayed in the previous graph. 

![image-trend-employed-rate][]

We observe that there has been an increase in women being employed in the labor force over time (from 47.7% in 1980 
to 53.2% in 2013).  This is a good sign and hopefully things continue to trend towards gender equality.

### Should gender equality apply to all industries?
Let's take a quick look at the *agriculture* industry sector, where we intuitively identify manual labor being 
employed more readily in men than women.

![image-trend-agricultural-labor-force][]

Whoa! This makes intuitive sense, but there are some other interesting questions that can be gathered from this 
visualization:

1.   *Why is there a slight jump in women agriculture labor force from 1994-1999?*
2.   *Why is there a sudden decrease in agriculture labor force recent years after 2000?*

These are questions that require research outside of the dataset, but I thought a few resources that I read online 
are potentially interesting explanations for some of the questions raised out of curiosity:

1.  I have not found a possible answer for this, but I'll leave it for the audience to dig into why there is a slight 
    jump in women agriculture labor force involvement from 1994-1999.
2.  This maybe due to the fact that farm decline stabilized around 1997, as detailed in this
    [USDA article][usda farm decline], as total land for farms remained the same after a decline in overall farms
    (i.e. farms stabilized into larger farms, which probably consolidated equipment and labor requirements over time)

### How about the unemployed?

![image-trend-unemployed-rate][]

From this bar chart, we see that both men and women suffer through economic recessions.

For some interesting facts, here are some details on major [recessions] that occurred in the US.  I'm not an expert 
in labor statistics, but it seems that unemployment rates straggle a few more years after the recession periods 
before recovery.  And we seem to be experiencing some kind of recession every 10 years, although this is more of 
an observation and not a conclusive statement with the small dataset we are working with

-   [Early 1980s Recession][] (1981 - 1982)
-   [Early 1990s Recession][] (1990 - 1991)
-   [The Great Recession][] (2007 - 2009)

This wraps up some of the visualizations that I found interesting.  Feel free to play with the webapp to discover 
more findings!  In the next section, we will study in more detail how each race and gender group perform in various 
occupations and industries at certain age groups.

<sub>(back to [contents](#contents))</sub>

------

## Employment by Occupation

### A quick overview
The next facet plot visualization helps us get a quick overview on relative percentages of employed people across 
genders and races in various occupations and industries, sliced by age groups.

![image-occupation-all][]

Some quick observations and comments:

-   We will use percentages to convey the data instead of raw head counts, which will skew the visualization towards
    the **White** demographic.
-   All percentages within a race (column) sums up to 100% in a given age group, this helps us determine the 
    relative gender and racial distribution for each age group across occupations and industries.
-   We observe that for age group 1 (16-19 years), most younger people in the labor force are engaged in 
    **Wholesale/Retail** as well as **Leisure Services** occupations, and for age group 4 (55 years and older), most
    older people are engaging in **Education/Health Services**.  This seems to make intuitive sense: younger people 
    engage in industries that require higher energy and attention while older people fit better in less energetic 
    industries.
-   Men-dominated industries include **Transportation/Utilities**, **Mining/Extraction**, **Manufacturing**, and 
    **Construction**, while women-dominated industries include **Education/Health Services**.  The rest of the 
    industry seem to have relatively equal gender distributions across all races.

### Men-Dominated Industries

Knowing that men are better suited at labor-intensive roles, we can take a closer look at the primary industry 
sector comprised of **Transportation/Utilities**, **Mining/Extraction**, **Manufacturing**, and **Construction**.

![image-occupation-male-dominated][]

A few interesting things stand out:

-   Most of the primary industry sector labor force is in the age group 2 and 3 (20-24 years and 25-54 years).
-   We see a general trend of lower **Mining/Extraction** and **Construction** jobs in favor of 
    **Transportation/Utilities** and **Manufacturing** jobs for the higher age groups, which makes intuitive sense 
    as manual labor-intensive jobs are better suited for the younger population.
-   There is another observation that Hispanic males are disproportionately involved in the **Construction** 
    industry sector (as circled in red above, e.g. 19.9% Hispanics vs 13.6% White for age group 3)

By highlighting a specific age group (e.g. 20-24 years), and focusing on the blue columns which represent men labor 
force, we can see some variations among the races in the occupations they engage in.

![image-occupation-male-dominated-age-group-2]

For age group 2 (20-24 years):

-   Asians are engaged more in **Manufacturing**.
-   Blacks are engaged more in **Transportation/Utilities**.
-   Hispanics are engaged more in **Construction**
-   Whites are engaged slightly more evenly in **Manufacturing** and **Construction**.

In the next sections, we will take a close look at some specific industries across the dimensions of race, gender 
and age groups.

### Education and Health Sector

First up, we have the **Education/Health** sector, where we can obviously identify it as a women-dominated sector.

![image-occupation-education-health][]

Here is a summary of the distribution across age groups in **Education/Health**:

-   Asians have roughly equivalent distribution across age groups.
-   All the other races seem to have growing distribution towards working in the **Education/Health** sector as the 
    labor force gets older.

### Public Administration Sector

There is a clear increase of older labor force participating in the **Public Administration** industry sector, with 
roughly equal gender distributions.

![image-occupation-public-administration][]

### Business and Finance Sector

A quick look at the visualization suggests that younger people (age groups 1 and 2) are more engaged in 
**Wholesale/Retail**, while the older people (age groups 3 and 4) are engaged in **Professional/Business Services** 
and **Finance Services**.

Gender distributions across these service sector look roughly equivalent.

![image-occupation-sales-business-finance][]

This wraps up some detailed facet plot visualizations of multi-dimensional analysis of labor force statistics across
industry, occupations, gender, races and age groups.

<sub>(back to [contents](#contents))</sub>

------

## Employment by Education

We all hear the saying that getting a Bachelor's degree is *necessary* to finding jobs.  We will take a deeper look 
into the dataset provided by CPS.

### By gender

Here are some quick numbers of the labor force by education level attainment.

![image-education-labor-force-by-gender][]

Most people in the US seem to have attained Bachelor degrees, or attended college with some associate or no degree.

When we zone in on the unemployment rates, we find an inverse correlation with educational level and unemployment 
rate.  People holding bachelor degrees or attended college earning an associate degree have much lower unemployment 
rates than individuals who have not attended college or earned any degree.

Judging by the numbers, it is recommended that you should try to earn at least an associate degree in college, since
the unemployment rates of graduating high school and attending college earning no degree are roughly the same.

![image-education-unemployment-by-gender][]

The next section filters the results by race instead of gender.

### By race

![image-education-labor-force-by-race][]

The unemployment rate trend is essentially the same as we observed in the gender overview i.e. a higher education 
degree confers better chances of getting a job.

![image-education-unemployment-by-race][]

However something stands out.

We see that the Black and Hispanic populations have higher unemployment rates than the other races at each education
level attainment.  This may or may not be due to racial discrimination, but if we made the assumption that education
has delivered equal opportunities to individuals developing skills for work, then this is an area of improvement we 
can work on if racial discrimination exists.

<sub>(back to [contents](#contents))</sub>

------

## Conclusion
>   Despite the focus on expressing gender and racial equality statistics on labor force, I strongly believe that
>   the topic of labor statistics should revolve around **ability equality** and not around gender and racial equality.

As seen in the example of agricultural jobs, women lack the natural ability to perform in this industry, and this 
should not be interpreted as discrimination when we evaluate people's ability to do certain work.

We need to be careful about over-emphasizing the obsession in optimizing "gender/racial-equal" numbers, which in my 
opinion, is another form of discrimination by overly stressing the concepts of genders and races, when our ultimate 
goal is to hopefully not create concepts of races and genders when we are engaging in professional evaluations of 
people.

Our solutions in education and government policies should be geared towards empowering individuals with *equal 
opportunities* to pursue what they want to achieve in their careers, and it is very important that pre-employment 
education is provided for every individual fairly, so that the true test of employment can be judged on a merit 
basis, instead on trying to optimize "gender/racial-equal" metrics.

In the future, it is my hope that all `gender` and `race` data in these visualizations contained can be collapsed, 
providing us with a simple analysis on our labor force statistics (as shown in the bar chart below without grouping 
by gender and race), one that is evaluated from all human individuals, as opposed to one evaluated based on races 
and genders.

![image-trend-all][]

<sub>(back to [contents](#contents))</sub>


------

## Data Resources
-   CPS data: [cps-02][], [cps-14][], [cps-07][]

<sub>(back to [contents](#contents))</sub>

------


<!-- external links -->
[interactive project link]: https://ahmedtadde.shinyapps.io/laborviz/
[Shiny]: http://shiny.rstudio.com/
[github]: https://github.com/ahmedtadde/laborViz
[CPS]: http://www.bls.gov/cps/
[cps-02]: http://www.bls.gov/cps/cpsaat02.htm
[cps-14]: http://www.bls.gov/cps/cpsaat14.htm
[cps-07]: http://www.bls.gov/cps/cpsaat07.htm
[dplyr]: http://cran.rstudio.com/web/packages/dplyr/vignettes/introduction.html
[usda farm decline]: http://www.usda.gov/factbook/chapter3.htm
[recessions]: http://en.wikipedia.org/wiki/List_of_recessions_in_the_United_States
[Early 1980s Recession]: http://en.wikipedia.org/wiki/Early_1980s_recession
[Early 1990s Recession]: http://en.wikipedia.org/wiki/Early_1990s_recession
[The Great Recession]: http://en.wikipedia.org/wiki/Great_Recession

<!-- images link -->
[image-cps-02]: ./www/image-cps-02.png
[image-cps-14]: ./www/image-cps-14.png
[image-cps-07]: ./www/image-cps-07.png
[image-long-wide-df]: ./www/image-long-wide-df.png


[image-trend-all]: ./www/image-trend-all.png
[image-trend-population]: ./www/image-trend-population.png
[image-trend-non-labor-force]: ./www/image-trend-non-labor-force.png
[image-trend-employed-rate]: ./www/image-trend-employed-rate.png
[image-trend-unemployed-rate]: ./www/image-trend-unemployed-rate.png
[image-trend-agricultural-labor-force]: ./www/image-trend-agricultural-labor-force.png


[image-occupation-all]: ./www/image-occupation-all.png
[image-occupation-male-dominated]: ./www/image-occupation-male-dominated.png
[image-occupation-male-dominated-age-group-2]: ./www/image-occupation-male-dominated-age-group-2.png
[image-occupation-education-health]: ./www/image-occupation-education-health.png
[image-occupation-public-administration]:./www/image-occupation-public-administration.png
[image-occupation-sales-business-finance]: ./www/image-occupation-sales-business-finance.png


[image-education-labor-force-by-gender]: ./www/image-education-labor-force-by-gender.png
[image-education-unemployment-by-gender]:./www/image-education-unemployment-by-gender.png
[image-education-labor-force-by-race]:./www/image-education-labor-force-by-race.png
[image-education-unemployment-by-race]: ./www/image-education-unemployment-by-race.png

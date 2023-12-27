# VIII Tidy Evaluation: rlang

## Assignment
Create R script for each exercise. In this assignment we will create some basic functions with rlang and other libraries from
tidyverse!

### Exercise 1
* Create a function "count freq" that:
	* takes a data frame
	* creates frequency counts
	* before counting is applied the function does the grouping (only one grouping variable is used in the function call!)
	* at the end function renames variables in the output table
	* grouping variable is called 'x'
	* frequencies variable is called 'freq'

## Exercise 2
* Create a function "draw bar plot" that:
	* takes the output of function "count freq" (from Exercise 1)
	* draws a bar plot
	* where variable "x" is used on x axis
	* variable "freq" is used on y axis
	* you can use geom col instead or geom bar (your choice)

## Exercise 3
* Create a function "prepare diamonds data" that:
	* takes diamonds data frame
	* randomly selects n diamonds
	* creates variable called "volume"
	* where: volume = x × y × z


## Exercise 4
* Create a function "explore diamonds" that:
	* takes the output of function "prepare diamonds data" (from Exercise 3)
	* draws scatter plot
	* where variable "carat" is used on x axis
	* variable "price" is used on y axis
	* variable "volume" is used for point size geom bar (your choice)
	* variable "color" is used for point color
	* add plot title and axis titles as function arguments
	* add custom plot theme inside the function

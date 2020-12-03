# Assignment07: Functions 
**Name:** EUtama
**Date:** 12/02/2020
**Class:** Foundations of Databases
**Assignment:** 07
**Github link:** https://github.com/utamae92/DBFoundations-Module7

## Functions
### Introduction
For module 7, I learned about different types of functions. This topic is an extension to what we learned last module about functions. The assignment for this module contained multiple parts. In the first part, I created SQL code with functions and user defined functions (UDF) to extract and manipulate the data. In this paper, I will talk about the purpose of the UDF and the differences between scalar, inline, and multi-statement functions.

### Explain when you would use a SQL UDF?
A SQL UDF is a custom function. UDF’s are similar to views, in that they are used to retrieve information from the database. However, there are certain processes that functions can be built with that you cannot with views. An example would be parameters. Within the functions statement, you can type in a parameter that can be used when getting the results. In the other part of the assignment, I created a function with parameters to look at KPI’s (Figure 1). Another example would be scalar functions which are used to return a single (scalar) value as an expression.

![Results of Figure 1](https://github.com/utamae92/DBFoundations-Module7/blob/main/Screenshot%202020-12-02%20at%2021.45.47.png "Figure 1: A simple SQL query containing a function with a parameter") 
#### *Figure 1: A simple SQL query containing a function with a parameter*

### Explain the differences between Scalar, Inline, and Multi-Statement Functions
The differences between a scalar, inline, and multi-statement function comes from the way the statements are coded. A scalar function returns a single scalar value. An inline function returns a single set of values. There is a single statement that is used for the function that is defined after the BEGIN statement. A multi-statement function (MSTVF) returns a table of data after additional processing. In the MSTVF, there a section of the code after a BEGIN statement where you add in multiple statements to create the rows which will populate the table. 

### Summary
It was interesting to learn more about functions in module 7. I found it very fascinating to see the different ways to create functions, especially the multi-statement functions. It gives me a better sense in how to extract for the parameters I need for future database projects.

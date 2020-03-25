# RecipeRationalizer

An interactive application for scaling recipes. Anyone can input the ingredient list for a recipe and scale it up or down.
Implemented in Elm (tentative).

## How It Works
* Input an ingredient and its quantity as a string
* Add/remove/rearrange inputs
* Parse input strings in the amount, unit, and the rest (ingredient)
* Determine if an input is scalable (by unit)
* Input number of servings (floating points) and display in-place the scaled quantities with appropriate units

# RecipeRationalizer

An interactive application for scaling recipes. Anyone can input the ingredient list for a recipe and scale it up or down.
Implemented in Elm (tentative).

## How It Works
* Input a list of ingredients, each with quantity, as strings separated by new line
* Show on the side as rearrangeable list
* Remove button to move from the list
* Parse input strings in the amount, unit, and the rest (ingredient)
* Determine if an input is scalable (by unit)
* Input number of servings (floating points) and display in-place the scaled quantities with appropriate units

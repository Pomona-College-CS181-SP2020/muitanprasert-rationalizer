# RecipeRationalizer

An interactive application for scaling recipes. Anyone can input the ingredient list for a recipe and scale it up or down.
Implemented in Elm (tentative).

## How It Works
* Input a list of ingredients, each with quantity, as strings separated by new line
* Show on the side as rearrangeable list
* Double click to remove from the list
* Parse input strings in the amount, unit, and the rest (ingredient)
* Determine if an input is scalable (by unit)
* Input number of servings (floating points) and display in-place the scaled quantities with appropriate units

## Notes
* Travis CI building with version 0.19.0
* Next steps:
    * Pluralize/singularize: how to handle abbreviations?
    * Unscalable ingredients: round up things without units
    * Fraction and number words...
module Test.Generated.Main2789889808 exposing (main)

import Example

import Test.Reporter.Reporter exposing (Report(..))
import Console.Text exposing (UseColor(..))
import Test.Runner.Node
import Test

main : Test.Runner.Node.TestProgram
main =
    [     Test.describe "Example" [Example.suite] ]
        |> Test.concat
        |> Test.Runner.Node.run { runs = Nothing, report = (ConsoleReport UseColor), seed = 67303748346791, processes = 4, paths = ["C:\\Users\\t_abc\\OneDrive - Pomona College\\RecipeRationalizer\\tests\\Example.elm"]}
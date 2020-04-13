module Test.Generated.Main4138394449 exposing (main)

import Example

import Test.Reporter.Reporter exposing (Report(..))
import Console.Text exposing (UseColor(..))
import Test.Runner.Node
import Test

main : Test.Runner.Node.TestProgram
main =
    [     Test.describe "Example" [Example.floating,
    Example.full,
    Example.no_number,
    Example.no_space,
    Example.no_trailing,
    Example.no_unit] ]
        |> Test.concat
        |> Test.Runner.Node.run { runs = Nothing, report = (ConsoleReport UseColor), seed = 175154853472370, processes = 4, paths = ["C:\\Users\\t_abc\\OneDrive - Pomona College\\muitanprasert-rationalizer\\tests\\Example.elm"]}
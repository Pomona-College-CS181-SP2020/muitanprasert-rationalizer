module Test.Generated.Main3757306416 exposing (main)

import Example

import Test.Reporter.Reporter exposing (Report(..))
import Console.Text exposing (UseColor(..))
import Test.Runner.Node
import Test

main : Test.Runner.Node.TestProgram
main =
    [     Test.describe "Example" [Example.bad_number_1,
    Example.bad_number_2,
    Example.floating,
    Example.frac,
    Example.full,
    Example.no_number,
    Example.no_space,
    Example.no_trailing,
    Example.no_unit] ]
        |> Test.concat
        |> Test.Runner.Node.run { runs = Nothing, report = (ConsoleReport UseColor), seed = 296007180130105, processes = 4, paths = ["C:\\Users\\t_abc\\OneDrive - Pomona College\\muitanprasert-rationalizer\\tests\\Example.elm"]}
module Test.Generated.Main823709210 exposing (main)

import ParserTest

import Test.Reporter.Reporter exposing (Report(..))
import Console.Text exposing (UseColor(..))
import Test.Runner.Node
import Test

main : Test.Runner.Node.TestProgram
main =
    [     Test.describe "ParserTest" [ParserTest.bad_number_1,
    ParserTest.bad_number_2,
    ParserTest.floating,
    ParserTest.frac,
    ParserTest.full,
    ParserTest.mixedfrac,
    ParserTest.no_number,
    ParserTest.no_space,
    ParserTest.no_trailing,
    ParserTest.no_unit,
    ParserTest.numWord_1,
    ParserTest.numWord_2,
    ParserTest.numWord_3,
    ParserTest.word] ]
        |> Test.concat
        |> Test.Runner.Node.run { runs = Nothing, report = (ConsoleReport UseColor), seed = 238625597562170, processes = 4, paths = ["C:\\Users\\t_abc\\OneDrive - Pomona College\\muitanprasert-rationalizer\\tests\\ParserTest.elm"]}
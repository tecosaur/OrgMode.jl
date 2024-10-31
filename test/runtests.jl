using Org
using Test
import Org: Object, Paragraph, Section, TextPlain, TextMarkup

@testset "Parsing tests" begin
    # wraps obj in a single paragraph doc
    para(x::Object) = OrgDoc([Section([Paragraph([x])])])
    testcases = [
        org"plain-text" => para(TextPlain("plain-text")),
        # single TextMarkup
        org"*bold-text*" => para(TextMarkup(:bold, "bold-text")),
        org"/it-text/" => para(TextMarkup(:italic, "it-text")),
        org"+striked-text+" => para(TextMarkup(:strikethrough, "striked-text")),
        org"_underlined-text_" => para(TextMarkup(:underline, "underlined-text")),
        org"=verbatim-text=" => para(TextMarkup(:verbatim, "verbatim-text")),
        org"~code-text~" => para(TextMarkup(:code, "code-text")),
        # nested TextMarkup (~ and = must preserve contents as-is)
        org"*/bold-it/*" => para(TextMarkup(:bold, Object[TextMarkup(:italic, "bold-it")])),
        org"/*it-bold*/" => para(TextMarkup(:italic, Object[TextMarkup(:bold, "it-bold")])),
        org"~*bold-code*~" => para(TextMarkup(:code, "*bold-code*")),
        org"=*bold-verbatim*=" => para(TextMarkup(:verbatim, "*bold-verbatim*"))
    ]
    for (actual, expected) in testcases
        @test actual == expected
    end
end

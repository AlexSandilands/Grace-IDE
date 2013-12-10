var text_color := "Forest Green"
var operators_etc := "Blue Violet"
var declarations_etc := "Chocolate"
var comments := "Dark Sea Green"
var numbers := "Magenta"

method get_color (arg : String) -> String is public {

    if(arg.match("method")) then {
        return declarations_etc
    }
    if(arg.match("def")) then {
        return declarations_etc
    }
    if(arg.match("var")) then {
        return declarations_etc
    }
    if(arg.match(":=")) then {
        return declarations_etc
    }
    if(arg.match("=")) then {
        return declarations_etc
    }
    if(arg.match(":")) then {
        return declarations_etc
    }
    if(arg.match("->")) then {
        return declarations_etc
    }
    if(arg.match("import")) then {
        return declarations_etc
    }
    if(arg.match("is")) then {
        return declarations_etc
    }
    if(arg.match("return")) then {
        return declarations_etc
    }
    if(arg.match("object")) then {
        return declarations_etc
    }
    if(arg.match("class")) then {
        return declarations_etc
    }


    if(arg.match("public")) then {
        return operators_etc
    }
    if(arg.match("readable")) then {
        return operators_etc
    }
    if(arg.match("platform")) then {
        return operators_etc
    }
    if(arg.match("String")) then {
        return operators_etc
    }
    if(arg.match("Number")) then {
        return operators_etc
    }
    if(arg.match("if")) then {
        return operators_etc
    }
    if(arg.match("then")) then {
        return operators_etc
    }
    if(arg.match("else")) then {
        return operators_etc
    }
    if(arg.match("while")) then {
        return operators_etc
    }
    if(arg.match("for")) then {
        return operators_etc
    }
    if(arg.match("do")) then {
        return operators_etc
    }
    if(arg.match("match")) then {
        return operators_etc
    }
    if(arg.match("print")) then {
        return operators_etc
    }
    if(arg.match("+")) then {
        return operators_etc
    }
    if(arg.match("++")) then {
        return operators_etc
    }
    if(arg.match("-")) then {
        return operators_etc
    }
    if(arg.match(">")) then {
        return operators_etc
    }
    if(arg.match(">=")) then {
        return operators_etc
    }
    if(arg.match("<")) then {
        return operators_etc
    }
    if(arg.match("<=")) then {
        return operators_etc
    }
    if(arg.match("=")) then {
        return operators_etc
    }
    if(arg.match("==")) then {
        return operators_etc
    }
    if(arg.match("!")) then {
        return operators_etc
    }
    if(arg.match("!=")) then {
        return operators_etc
    }
    if(arg.match("!<")) then {
        return operators_etc
    }
    if(arg.match("!>")) then {
        return operators_etc
    }
    if(arg.match("$")) then {
        return operators_etc
    }
    if(arg.match("%")) then {
        return operators_etc
    }
    if(arg.match("&")) then {
        return operators_etc
    }
    if(arg.match("&&")) then {
        return operators_etc
    }
    if(arg.match("*")) then {
        return operators_etc
    }



    if(arg.asNumber.asString == arg) then {
        return numbers
    }
    if(arg.match("true")) then {
        return numbers
    }
    if(arg.match("false")) then {
        return numbers
    }


    if(arg.at(1).match("\"")) then {
        return text_color
    }



    if(arg.match("//")) then {
        return comments
    }


    return "Black"
}
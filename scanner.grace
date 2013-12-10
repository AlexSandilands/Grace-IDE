import "io" as io
import "mgcollections" as collections

class Scanner.new(text : String) {
// Public Methods
// -------------------

    // Return the next token in the text
    method next -> String is public {
        if(listChanged) then {
            constructDelimiters(delimiter)
            listChanged := false
        }
        return scan
    }

    // Return the next line in the text
    method nextLine -> String is public {
        delimiter_list := collections.list.new("\n")
        listChanged := true

        return scan
    }

    // Returns true if there is another token left in the text that hasn't been
    // read yet.
    method hasNext -> Boolean is public {
        var tPointer := pointer + 0

        while{tPointer <= text.size} do {
            if(checkDelimiter(text.at(tPointer))) then {
                tPointer := tPointer + 1
            } else {
                return true
            }
        }

        return false
    }
    
    // Sets the delimiter for the scanner to use.
    // if arg = abc\"(hey)\( then the delimiters are:
    // a, b, c, ", hey, ( 
    method useDelimiter(arg : String) is public {
        delimiter := arg
        listChanged := true
    }

    // Scans along the text until it finds the next delimiter. Returns the 
    // place in the text that the quotation mark was found.
    method find_next_quotation(start) -> Number is public {
        var loop := true
        var end := start + 0
        while {loop} do {
            end := end + 1

            if(text.at(end).match("\"")) then {
                loop := false
            }
            if((end + 1) > text.size) then {
                loop := false
            }
        }

        pointer := end + 1
        skipDelimiators
        return end
    }

    // Returns where the pointer was after it just found a token, before
    // skipping delimiters and whitespace etc
    method get_end_of_last -> Number is public {
        last_pointer := pointer - 1

        while {checkDelimiter(text.at(last_pointer))} do {
            last_pointer := last_pointer - 1
        }

        return last_pointer
    }

    // Sets where the scanner is pointing. This sort of breaks the 
    // scanner, but it is necessary for the syntax highighter 
    method set_pointer(num : Number) is public {
        pointer := num
    }
// -------------------

    var pointer := 1
    var last_pointer := 1
    var delimiter := " \n"  // Default delimiter
    var delimiter_list := collections.list.new(" ", "\n")
    var listChanged := false

    // Pulls the next character from the text and returns it. Increments 
    // the pointer
    method pull -> String {
        def ret = text.at(pointer)
        pointer := pointer + 1
        return ret
    }

    // Returns the character that is arg places ahead of the current pointer
    method lookAhead(arg : Number) -> String {
        return text.at(pointer + arg)
    }

    // Creates the delimiter list
    method constructDelimiters(del : String) {
        var delPointer := 1
        var curDel := ""
        delimiter_list := collections.list.new()

        while {delPointer <= del.size} do {
            curDel := del.at(delPointer)
            var get_next := true

            // If a \ character is found, then the next character
            // must be a delimiter. ie \" -> " is a delimiter
            if(curDel.match("\\")) then {
                delPointer := delPointer + 1
                curDel := del.at(delPointer)
                delimiter_list.push(curDel)
                delPointer := delPointer + 1
                get_next := false
            }

            // If an open parenthesis if found then match until the next
            // closed parenthesis is found. Inbetween will be the delimiter  
            if(curDel.match("(") && get_next) then {
                delPointer := delPointer + 1
                curDel := ""
                while {!del.at(delPointer).match(")")} do {
                    curDel := curDel ++ del.at(delPointer)
                    delPointer := delPointer + 1
                }
                delimiter_list.push(curDel)
                delPointer := delPointer + 1
                get_next := false
            } 

            if(get_next) then {
                delimiter_list.push(curDel)
                delPointer := delPointer + 1
            }
        }
    }

    // Returns the next token. Checks against the current delimiter.
    // The delimiter will be changed if .nextLine is called, but then 
    // changed back when .next is called. This is why a separate scan 
    // method is necessary
    method scan -> String {
        var ret := ""
        var loop := true

        while {hasNext() && loop} do {
            def char = pull()

            if(checkDelimiter(char)) then {
                loop := false
            } else {
                ret := ret ++ char
            }
        }
        skipDelimiators()

        return ret
    }

    // Like a skip whitespace method, skips all delimiters that
    // come directly after the token just found
    method skipDelimiators {
        var loop := true
        var num := 0

        // Don't skip multiple new line characters
        if(lookAhead(0).match("\n")) then {
            loop := false
        }

        while {loop} do {
            var char := lookAhead(num)

            if(checkDelimiter(char)) then {
                num := num + 1
                if(num > text.size) then {
                    loop := false
                }
                if(char.match("\n")) then {
                    loop := false
                }
            } else {
                loop := false
            }
        }


        pointer := pointer + num
    }

    // Returns true if char is contained in the list of delimiters
    method checkDelimiter(char : String) -> Boolean {
        var listPointer := 1

        if(delimiter_list.size == 0) then {
            return true
        }

        while {listPointer <= delimiter_list.size} do {
            var curDel := delimiter_list.at(listPointer)

            // Match any the next char in the delimiter list to the input
            if(char.match(curDel)) then {
                return true
            } else {
                listPointer := listPointer + 1
            }
        }
        return false
    }

}

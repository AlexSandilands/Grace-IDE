import "gtk" as gtk

class Auto_Completer.new(window, notebook, editor_map) {
    // Initialise text iterators
    def sIter = gtk.text_iter
    def eIter = gtk.text_iter

    var indent := ""

    def accelgroup = gtk.accel_group
    
    // Connect the key presses
    accelgroup.accel_connect(platform.gdk.GDK_KEY_Tab, { cursor_insert("    ") })
    accelgroup.accel_connect(platform.gdk.GDK_KEY_Return, { do_enter() })
    accelgroup.accel_connect(platform.gdk.GDK_KEY_braceleft, { 
        cursor_insert("\{\}")
        move_cursor_to(get_cursor - 1)
    })
    accelgroup.accel_connect(platform.gdk.GDK_KEY_parenleft, { 
        cursor_insert("\(\)")
        move_cursor_to(get_cursor - 1)
    })
    accelgroup.accel_connect(platform.gdk.GDK_KEY_quotedbl, { 
        cursor_insert("\"\"")
        move_cursor_to(get_cursor - 1)
    })


    // Utility Methods
    // -------------

    method cursor_insert(text : String) {
        def cur_page = editor_map.get(notebook.current_page)

        cur_page.buffer.insert_at_cursor(text, text.size)
    }

    method insert_at(offset, text) {
        def cur_page = editor_map.get(notebook.current_page)

        cur_page.buffer.get_iter_at_offset(sIter, offset)
        cur_page.buffer.insert(sIter, text, text.size)   
    }

    // Returns the offset of the cursor in the current page
    method get_cursor -> Number {
        def cur_page = editor_map.get(notebook.current_page)

        // Get the text mark from the buffer where the cursor is currently pointing
        def mark = cur_page.buffer.insert

        // Set an iter to the position of the mark
        cur_page.buffer.get_iter_at_mark(sIter, mark)

        // Return the position
        return sIter.offset
    }

    // Moves the cursor to the offset given
    method move_cursor_to(pos : Number) {
        def cur_page = editor_map.get(notebook.current_page)
        
        cur_page.buffer.get_iter_at_offset(sIter, pos)
        cur_page.buffer.place_cursor(sIter)
    }


    // -------------



    // Method that deals with what happens when the enter key is pressed
    method do_enter {
        def cur_page = editor_map.get(notebook.current_page)
        
        // Set one at the beggining and one at the end of the text
        cur_page.buffer.get_iter_at_offset(sIter, 0)
        cur_page.buffer.get_iter_at_offset(eIter, -1)

        // Get the text between the text iterators
        def text = cur_page.buffer.get_text(sIter, eIter, true)

        // Get the position
        var cursor_pos := get_cursor()
        var loop := true

        // Search back for the previous character, skipping spaces
        while {loop} do {
            if(text.at(cursor_pos).match(" ")) then {
                cursor_pos := cursor_pos - 1
            } else {
                loop := false
            }
        }

        // If the character was a brace, insert a tab and a new line character
        def char = text.at(cursor_pos)
        if(char.match("\{")) then {
            cursor_insert("\n        \n")
            move_cursor_to(get_cursor - 1)
            indent := indent ++ "        "

        } else {    // Otherwise, just do a new line character
            cursor_insert("\n")
            // cursor_insert(indent)
        }

    }


    window.add_accel_group(accelgroup)
}
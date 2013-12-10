import "gtk" as gtk
import "scanner" as scanner
import "syntax_colors" as colors

class Syntax_Highlighter.new(notebook, editor_map) {
    var text := ""
    var tag_count := 0

    // Initialise text iterators
    def sIter = gtk.text_iter
    def eIter = gtk.text_iter

    // Does a scan through the entire text of the current page and
    // updates the highlighting. This can be slow if the page has > 30 lines
    method highlightAll is public {
        def cur_page = editor_map.get(notebook.current_page)

        // Set one at the beggining and one at the end of the text
        cur_page.buffer.get_iter_at_offset(sIter, 0)
        cur_page.buffer.get_iter_at_offset(eIter, -1)

        // Get the text between the text iterators
        text := cur_page.buffer.get_text(sIter, eIter, true)

        highlightText(text, 0)
    }

    // Highlights just the line that the cursor is on (more efficient)
    method highlightLine is public {
        def cur_page = editor_map.get(notebook.current_page)

        // Set one at the beggining and one at the end of the text
        cur_page.buffer.get_iter_at_offset(sIter, 0)
        cur_page.buffer.get_iter_at_offset(eIter, -1)

        // Get the text between the text iterators
        text := cur_page.buffer.get_text(sIter, eIter, true)

        // Get the text mark from the buffer where the cursor is currently pointing
        def mark = cur_page.buffer.get_mark("insert")

        // Set an iter to the position of the mark
        cur_page.buffer.get_iter_at_mark(sIter, mark)

        // Get the position
        def cursor_pos = sIter.offset

        var pointer := cursor_pos + 0
        var loop := true

        // Scan back, setting the pointer either to the previous \n char or the start of the text
        while {loop} do {
            if(text.at(pointer).match("\n")) then {
                loop := false
            }
            if(pointer == 0) then {
                loop := false
            }

            if(loop) then {
                pointer := pointer - 1
            }
        }

        def start_line = pointer + 0

        pointer := cursor_pos + 0
        loop := true

        while {loop} do {
            if(text.at(pointer).match("\n")) then {
                loop := false
            }
            if(pointer == text.size) then {
                loop := false
            }

            if(loop) then {
                pointer := pointer + 1
            }
        }

        def end_line = pointer + 0

        cur_page.buffer.get_iter_at_offset(sIter, start_line)
        cur_page.buffer.get_iter_at_offset(eIter, end_line)

        def line = cur_page.buffer.get_text(sIter, eIter, true)

        highlightText(line, start_line)
    }

    // Scans through the input text, highlighting keywords
    method highlightText(arg : String, offset : Number) {
        def cur_page = editor_map.get(notebook.current_page)

        def scan = scanner.Scanner.new(arg)
        scan.useDelimiter(", \n\\(\\).")

        while {scan.hasNext} do {
            var token := scan.next
            var did_special_case := false

            // If the token starts with a "//" then scan to the end of the line
            // and highlight the whole line as a comment.
            if(token.substringFrom(0)to(1).match("//")) then {
                var last_pointer := scan.get_end_of_last
                var start_line := last_pointer - token.size
                scan.set_pointer(start_line + 1)

                token := scan.nextLine

                var col := colors.get_color("//")
                var tag := cur_page.buffer.create_tag("tag" ++ tag_count, "foreground", col)
                tag_count := tag_count + 1

                cur_page.buffer.get_iter_at_offset(sIter, start_line + offset)
                cur_page.buffer.get_iter_at_offset(eIter, start_line + token.size + offset)

                cur_page.buffer.apply_tag(tag, sIter, eIter)

                did_special_case := true
            }

            // If the token starts with a " then scan until you find the next quotation mark
            // and highlight everything in between
            if(token.at(1).match("\"")) then {
                var last_pointer := scan.get_end_of_last

                var start_quotes := last_pointer - token.size
                var end_quotes := scan.find_next_quotation(start_quotes + 1)

                var col := colors.get_color(token)
                var tag := cur_page.buffer.create_tag("tag" ++ tag_count, "foreground", col)
                tag_count := tag_count + 1

                cur_page.buffer.get_iter_at_offset(sIter, start_quotes + offset)
                cur_page.buffer.get_iter_at_offset(eIter, end_quotes + offset)

                cur_page.buffer.apply_tag(tag, sIter, eIter)

                did_special_case := true
            }

            // If a comment or a quotation wasn't done, highlight the singular keyword
            // if it needs it
            if(!did_special_case) then {
                var col := colors.get_color(token)

                var tag := cur_page.buffer.create_tag("tag" ++ tag_count, "foreground", col)
                tag_count := tag_count + 1

                var pointer := scan.get_end_of_last

                var start := pointer - token.size
                var end := pointer
                cur_page.buffer.get_iter_at_offset(sIter, start + offset)
                cur_page.buffer.get_iter_at_offset(eIter, end + offset)

                cur_page.buffer.apply_tag(tag, sIter, eIter)
            }
        }
    }
}
import "gtk" as gtk
import "io" as io
import "syntax_highlighter" as highlighter

// A dialog that lets the user create a new file to edit
class new.new(notebook, editor_map, scrolled_map, lighter) {
    def new_window = gtk.window(gtk.GTK_WINDOW_TOPLEVEL)
    def main_box = gtk.box(gtk.GTK_ORIENTATION_VERTICAL, 2)
    def south_box = gtk.box(gtk.GTK_ORIENTATION_HORIZONTAL, 2)

    def enter_label = gtk.label("Enter the name of the file")
    def accept_button = gtk.button
    def new_entry = gtk.entry

    new_window.set_size_request(300, 100)
    enter_label.set_size_request(300, 70)
    accept_button.label := "Accept"
    accept_button.set_size_request(70, 25)
    new_entry.set_size_request(220, 10)

    main_box.add(enter_label)
    south_box.add(new_entry)
    south_box.add(accept_button)
    main_box.add(south_box)

    new_window.add(main_box)
    new_window.move(500, 300)

    new_entry.connect("activate", {
        var new_name := "{new_entry.text}"
        if(new_name.size > 0) then {
            def extension_test = new_name.substringFrom(new_name.size - 5)to(new_name.size)

            if(extension_test != ".grace") then {
                new_name := new_name ++ ".grace"
            }

            def new_tEdit = gtk.text_view
            new_tEdit.set_size_request(700, 400)

            def new_scrolled = gtk.scrolled_window
            new_scrolled.set_size_request(700, 400)
            new_scrolled.add(new_tEdit)

            notebook.add(new_scrolled)
            notebook.set_tab_label_text(new_scrolled, new_name)
            new_tEdit.buffer.on "changed" do {
                lighter.highlightLine
            }

            notebook.show_all

            def num_pages = notebook.n_pages
            notebook.current_page := num_pages - 1
            editor_map.put(num_pages - 1, new_tEdit)
            scrolled_map.put(num_pages - 1, new_scrolled)

            notebook.show_all

            new_window.destroy
        } else {
            new_window.destroy
        }
    })

    accept_button.on "clicked" do {
        var new_name := "{new_entry.text}"
        if(new_name.size > 0) then {
            def extension_test = new_name.substringFrom(new_name.size - 5)to(new_name.size)

            if(extension_test != ".grace") then {
                new_name := new_name ++ ".grace"
            }

            def new_tEdit = gtk.text_view
            new_tEdit.set_size_request(700, 400)

            def new_scrolled = gtk.scrolled_window
            new_scrolled.set_size_request(700, 400)
            new_scrolled.add(new_tEdit)

            notebook.add(new_scrolled)
            notebook.set_tab_label_text(new_scrolled, new_name)
            new_tEdit.buffer.on "changed" do {
                lighter.highlightLine
            }

            notebook.show_all

            def num_pages = notebook.n_pages
            notebook.current_page := num_pages - 1
            editor_map.put(num_pages - 1, new_tEdit)
            scrolled_map.put(num_pages - 1, new_scrolled)

            notebook.show_all

            new_window.destroy
        } else {
            new_window.destroy
        }
    }

    method window is public {
        return new_window
    }
}

// A dialog that lets the user open an existing file to edit
class open.new(notebook, editor_map, scrolled_map, lighter) {

    def open_window = gtk.window(gtk.GTK_WINDOW_TOPLEVEL)
    def main_box = gtk.box(gtk.GTK_ORIENTATION_VERTICAL, 2)
    def south_box = gtk.box(gtk.GTK_ORIENTATION_HORIZONTAL, 2)

    def enter_label = gtk.label("Enter the name of the file to open")
    def accept_button = gtk.button
    def open_entry = gtk.entry

    open_window.set_size_request(300, 100)
    enter_label.set_size_request(300, 70)
    accept_button.label := "Accept"
    accept_button.set_size_request(70, 25)
    open_entry.set_size_request(220, 10)

    main_box.add(enter_label)
    south_box.add(open_entry)
    south_box.add(accept_button)
    main_box.add(south_box)

    open_window.add(main_box)
    open_window.move(500, 300)

    open_entry.connect("activate", {
        var open_name := "{open_entry.text}"
        def extension_test = open_name.substringFrom(open_name.size - 5)to(open_name.size)

        if(extension_test != ".grace") then {
            open_name := open_name ++ ".grace"
        }

        def new_tEdit = gtk.text_view
        new_tEdit.set_size_request(700, 400)

        def new_scrolled = gtk.scrolled_window
        new_scrolled.set_size_request(700, 400)
        new_scrolled.add(new_tEdit)


        def opened_file = io.open("files/" ++ open_name, "r")
        def opened_text = opened_file.read

        new_tEdit.buffer.set_text(opened_text, -1)
        new_tEdit.buffer.on "changed" do {
            lighter.highlightLine
        } 

        notebook.add(new_scrolled)
        notebook.set_tab_label_text(new_scrolled, open_name)

        notebook.show_all

        def num_pages = notebook.n_pages
        notebook.current_page := num_pages - 1
        editor_map.put(num_pages - 1, new_tEdit)
        scrolled_map.put(num_pages - 1, new_scrolled)

        lighter.highlightAll
        notebook.show_all

        open_window.destroy
    })

    accept_button.on "clicked" do {
        var open_name := "{open_entry.text}"
        def extension_test = open_name.substringFrom(open_name.size - 5)to(open_name.size)

        if(extension_test != ".grace") then {
            open_name := open_name ++ ".grace"
        }

        def new_tEdit = gtk.text_view
        new_tEdit.set_size_request(700, 400)

        def new_scrolled = gtk.scrolled_window
        new_scrolled.set_size_request(700, 400)
        new_scrolled.add(new_tEdit)


        def opened_file = io.open("files/" ++ open_name, "r")
        def opened_text = opened_file.read

        new_tEdit.buffer.set_text(opened_text, -1)
        new_tEdit.buffer.on "changed" do {
            lighter.highlightLine
        } 

        notebook.add(new_scrolled)
        notebook.set_tab_label_text(new_scrolled, open_name)

        notebook.show_all

        def num_pages = notebook.n_pages
        notebook.current_page := num_pages - 1
        editor_map.put(num_pages - 1, new_tEdit)
        scrolled_map.put(num_pages - 1, new_scrolled)

        notebook.show_all

        open_window.destroy
        lighter.highlightAll
    }

    method window is public {
        return open_window
    }
}

// A dialog that lets the user save the current file being edited
class save.new(notebook, editor_map, scrolled_map, overwrite) {
    def save_window = gtk.window(gtk.GTK_WINDOW_TOPLEVEL)
    def main_box = gtk.box(gtk.GTK_ORIENTATION_VERTICAL, 2)
    def south_box = gtk.box(gtk.GTK_ORIENTATION_HORIZONTAL, 2)

    def enter_label = gtk.label("Enter the name you want to save the file as")
    def accept_button = gtk.button
    def overwrite_button = gtk.button
    def save_entry = gtk.entry

    save_window.set_size_request(300, 100)
    enter_label.set_size_request(300, 70)
    accept_button.label := "Accept"
    accept_button.set_size_request(70, 25)
    overwrite_button.label := "Overwrite"
    overwrite_button.set_size_request(70, 25)
    save_entry.set_size_request(220, 10)

    main_box.add(enter_label)
    south_box.add(save_entry)
    south_box.add(accept_button)
    if(!overwrite) then {
        south_box.add(overwrite_button)
    }
    main_box.add(south_box)

    save_window.add(main_box)
    save_window.move(500, 300)


    save_entry.connect("activate", {
        var save_name := "{save_entry.text}"
        def extension_test = save_name.substringFrom(save_name.size - 5)to(save_name.size)

        if(extension_test != ".grace") then {
            save_name := save_name ++ ".grace"
        }
        
        def cur_page_num = notebook.current_page
        def cur_page = editor_map.get(cur_page_num)
        def cur_scrolled = scrolled_map.get(cur_page_num)
        
        // Initialise text iterators
        def sIter = gtk.text_iter
        def eIter = gtk.text_iter

        // Set one at the beggining and one at the end of the text
        cur_page.buffer.get_iter_at_offset(sIter, 0)
        cur_page.buffer.get_iter_at_offset(eIter, -1)

        // Get the text between the text iterators
        def text = cur_page.buffer.get_text(sIter, eIter, true)

        def file = io.open("files/" ++ save_name, "w")
        file.write(text)
        file.close

        // If wanting to overwrite, delete the old file
        if(overwrite) then {
            notebook.set_tab_label_text(cur_scrolled, save_name)
            notebook.show_all
            io.system("rm -f files/Untitled.* files/Untitled")
        }

        save_window.destroy
    })

    accept_button.on "clicked" do {
        var save_name := "{save_entry.text}"
        def extension_test = save_name.substringFrom(save_name.size - 5)to(save_name.size)

        if(extension_test != ".grace") then {
            save_name := save_name ++ ".grace"
        }
        
        def cur_page_num = notebook.current_page
        def cur_page = editor_map.get(cur_page_num)
        def cur_scrolled = scrolled_map.get(cur_page_num)
        
        // Initialise text iterators
        def sIter = gtk.text_iter
        def eIter = gtk.text_iter

        // Set one at the beggining and one at the end of the text
        cur_page.buffer.get_iter_at_offset(sIter, 0)
        cur_page.buffer.get_iter_at_offset(eIter, -1)

        // Get the text between the text iterators
        def text = cur_page.buffer.get_text(sIter, eIter, true)

        def file = io.open("files/" ++ save_name, "w")
        file.write(text)
        file.close

        // If wanting to overwrite, delete the old file
        if(overwrite) then {
            notebook.set_tab_label_text(cur_scrolled, save_name)
            notebook.show_all
            io.system("rm -f files/Untitled.* files/Untitled")
        }

        save_window.destroy
    }

    // This does the same as usual except overwrites the old file
    overwrite_button.on "clicked" do {
        var save_name := "{save_entry.text}"
        def extension_test = save_name.substringFrom(save_name.size - 5)to(save_name.size)

        if(extension_test != ".grace") then {
            save_name := save_name ++ ".grace"
        }
        
        def cur_page_num = notebook.current_page
        def cur_page = editor_map.get(cur_page_num)
        def cur_scrolled = scrolled_map.get(cur_page_num)
        var cur_page_label := notebook.get_tab_label_text(cur_scrolled)
        cur_page_label := cur_page_label.substringFrom(0)to(cur_page_label.size - 7) //Removes .grace extension
        
        // Initialise text iterators
        def sIter = gtk.text_iter
        def eIter = gtk.text_iter

        // Set one at the beggining and one at the end of the text
        cur_page.buffer.get_iter_at_offset(sIter, 0)
        cur_page.buffer.get_iter_at_offset(eIter, -1)

        // Get the text between the text iterators
        def text = cur_page.buffer.get_text(sIter, eIter, true)

        def file = io.open("files/" ++ save_name, "w")
        file.write(text)
        file.close

        notebook.set_tab_label_text(cur_scrolled, save_name)
        notebook.show_all
        // Delete all old files
        io.system("rm -f files/" ++ cur_page_label ++ ".* " ++ cur_page_label)
        
        save_window.destroy
    }

    method window is public {
        return save_window
    }
}
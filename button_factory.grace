import "gtk" as gtk

def runButton = gtk.button
def consoleClear = gtk.button
def consoleOut = gtk.button
def consoleError = gtk.button
def consolePop = gtk.button
def newButton = gtk.button
def openButton = gtk.button
def saveButton = gtk.button
def saveAsButton = gtk.button
def closeButton = gtk.button

// Returns a different type of button, depending on the argument
method make(arg : String) is public {
    if (arg == "run") then {
        return run()
    }
    if (arg == "clear") then {   
        return clear()
    }
    if(arg == "out") then {
        return out()
    }
    if(arg == "error") then {
        return error()
    }
    if(arg == "pop") then {
        return pop()
    }
    if (arg == "new") then {
        return new()
    }
    if (arg == "open") then {
        return open()
    }
    if (arg == "save") then {
        return save()
    }
    if(arg == "saveAs") then {
        return saveAs()
    }
    if(arg == "close") then {
        return close()
    }
}

method run {
    runButton.label := "Run"
    runButton.tooltip_text := "Runs the program"
    runButton.set_size_request(100, 50)

    return runButton
}

method clear {
    consoleClear.label := "Clear"
    consoleClear.tooltip_text := "Clears the Console"
    consoleClear.set_size_request(25, 15)

    return consoleClear
}

method out {
    consoleOut.label := "Output"
    consoleOut.tooltip_text := "Shows any output the program might create"
    consoleOut.set_size_request(25, 15)

    return consoleOut
}

method error {
    consoleError.label := "Errors"
    consoleError.tooltip_text := "Displays any errors there may be"
    consoleError.set_size_request(25, 15)

    return consoleError
}

method pop {
    consolePop.label := "Pop Out"
    consolePop.tooltip_text := "Will pop the console out into a new window"
    consolePop.set_size_request(25, 15)

    return consolePop
}

method new {
    newButton.label := "New"
    newButton.tooltip_text := "Creates a new file"
    newButton.set_size_request(25, 15)

    return newButton
}

method open {
    openButton.label := "Open"
    openButton.tooltip_text := "Opens a file"
    openButton.set_size_request(25, 15)

    return openButton
}

method save {
    saveButton.label := "Save"
    saveButton.tooltip_text := "Saves the file"
    saveButton.set_size_request(25, 15)

    return saveButton
}

method saveAs {
    saveAsButton.label := "Save As"
    saveAsButton.tooltip_text := "Saves the text into a new file"
    saveAsButton.set_size_request(25, 15)

    return saveAsButton
}

method close {
    closeButton.label := "Close Tab"
    closeButton.tooltip_text := "Closes the current tab"
    closeButton.set_size_request(50, 25)

    return closeButton
}
#!/usr/local/bin/macruby

require "omni_focus_to_dos"

 
@tasks = OmniFocusToDos.new("LSRC")
@tasks.save_todos



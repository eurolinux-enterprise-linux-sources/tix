# man2html-fixindex.tcl
#
#       Updates the index file generated by tix-man2html.tcl
#       in a format more suitable for Tix
#
#       This program is dependent on the specific HTML format
#       generated by ./tix-man2html.tcl.
#
# $Id: man2html-fixindex.tcl,v 1.1 2001/01/22 08:18:35 ioilam Exp $

set root [lindex $argv 0]
set file [file join $root contents.htm]
set fd [open $file RDONLY]
set data [read $fd]
close $fd

#
# Remove the link about Tix Commands
#
regsub "<DT><A HREF=\"TixCmd\[^\n\]*\n" $data "" data

set std {
    tixGrid 
    tixHList 
    tixInputOnly 
    tixNBFrame 
    tixTList 
}
set mega {
    tixBalloon 
    tixButtonBox 
    tixCheckList 
    tixComboBox 
    tixControl 
    tixDirList 
    tixDirSelectDialog 
    tixDirTree 
    tixExFileSelectBox 
    tixExFileSelectDialog 
    tixFileEntry 
    tixFileSelectBox 
    tixFileSelectDialog 
    tixLabelEntry 
    tixLabelFrame 
    tixListNoteBook 
    tixMeter 
    tixNoteBook 
    tixOptionMenu 
    tixPanedWindow 
    tixPopupMenu 
    tixScrolledHList 
    tixScrolledListBox 
    tixScrolledText 
    tixScrolledWindow 
    tixSelect 
    tixStdButtonBox 
    tixTree
}
set img {
    compound 
    pixmap 
}
set other {
    tixDestroy 
    tixDisplayStyle 
    tixForm 
    tixMwm 
    tix 
    tixGetBoolean 
    tixGetInt 
    tixUtils
}
set progs  {
    tixwish
}

#
# returns the links to the list of man pages in an HTML table.
#
proc section {name dir list} {
    set tab_width 4

    append html <b>$name</b>\n
    append html <blockquote>\n
    append html {<TABLE>}

    set tab_height [expr ([llength $list] + $tab_width - 1) / $tab_width]
    for {set i 0} {$i < $tab_height} {incr i} {
        append html {<TR>}
        for {set j 0} {$j < $tab_width} {incr j} {
            set idx [expr ($j * $tab_height) + $i]
            append html <TD>
            if {$idx < [llength $list]} {
                set page [lindex $list $idx]
                append html "<A HREF=$dir/$page.htm>$page</A>"
            } else {
                append html ""
            }
            append html </TD>
        }
        append html </TR>
    }

    append html </TABLE>
    append html </blockquote>\n
    append html \n
    return $html
}

#
# Add Tix commands to the page with better categorization.
#

append tixdata {
    <blockquote>
    
    <b><a href=TixCmd/TixIntro.htm#M3>
    Introduction to the Tix Library</a></b>

    </blockquote>
}
append tixdata [section {Tix Standard Widgets} TixCmd $std]
append tixdata [section {Tix Mega Widgets} TixCmd $mega]
append tixdata [section {Tix Image Types} TixCmd $img]
append tixdata [section {Tix Core Commands} TixCmd $other]
append tixdata [section {Tix User Programs} UserCmd $progs]

regsub </H3> $data </H3>$tixdata data

set fd [open $file {WRONLY TRUNC CREAT}]
puts -nonewline $fd $data
close $fd


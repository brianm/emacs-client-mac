on run
	runclient("")
end run

on open argv
	set filename to quoted form of POSIX path of item 1 of argv
	runclient(filename)
end open

on runclient(filename)
	tell application "Terminal"
		try
			set frameVisible to do shell script "/Applications/Emacs.app/Contents/MacOS/bin/emacsclient -e '(<= 2 (length (visible-frame-list)))'"
			if frameVisible is not "t" then
				-- there is a not a visible frame, launch one
				do shell script "/Applications/Emacs.app/Contents/MacOS/bin/emacsclient -c -n  " & filename
			end if
		on error
			-- daemon is not running, start the daemon and open a frame		
			do shell script "/Applications/Emacs.app/Contents/MacOS/Emacs --daemon"
			do shell script "/Applications/Emacs.app/Contents/MacOS/bin/emacsclient -c -n " & filename
		end try
	end tell
	
	-- bring the visible frame to the front
	tell application "Emacs" to activate
	
	-- close terminal
	tell application "Terminal" to quit
end runclient
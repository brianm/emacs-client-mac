on run
	runclient("")
end run

on open argv
	set filename to quoted form of POSIX path of item 1 of argv
	runclient(filename)
end open

on runclient(filename)
	tell application "System Events" to set isRunning to (name of processes) contains "Terminal"
	
	tell application "Terminal"
		try
			set frameVisible to do shell script "/Applications/Emacs.app/Contents/MacOS/bin/emacsclient -e '(<= 2 (length (visible-frame-list)))'"
			if frameVisible is not "t" then
				-- there is a not a visible frame, launch one
				do shell script "/Applications/Emacs.app/Contents/MacOS/bin/emacsclient -c -n  " & filename
			else if filename is not "" then
				-- there is a viible frame, just open a file in exiting one
				do shell script "/Applications/Emacs.app/Contents/MacOS/bin/emacsclient -n  " & filename
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
	if not isRunning then
		tell application "Terminal" to quit
	end if
end runclient
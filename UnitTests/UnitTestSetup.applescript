#!/usr/bin/osascript 
tell application "Xcode"
	tell project of active project document
		
		# A little defensive scripting.  Don't muck with the Xcode project unless it is our BSJSONAdditions project.
		
		try
			if name is not "BSJSONAdditions" then error
		on error
			activate
			display dialog "This script is only applicable to the BSJSONAdditions Xcode project."
			return
		end try
		
		# If necessary, create a new executable pointing to /Developer/Tools/otest
		
		set shouldCreateExecutable to true
		repeat with myExecutable in executables
			if (name of myExecutable is "otest") then
				set shouldCreateExecutable to false
			end if
		end repeat
		
		if (shouldCreateExecutable) then
			make new executable with properties {name:"otest", path:"/Developer/Tools/otest"}
		end if
		
		# Configure the BSJSONAdditions project to use the UnitTests target against the otest executable.
		# Developer can run or debug the UnitTests bundle as they would a regular piece of code.
		
		tell executable named "otest"
			# get properties of launch arguments
			# count of launch arguments
			delete (every launch argument)
			make new launch argument with properties {name:"-SenTest All", active:true}
			make new launch argument with properties {name:"${BUILT_PRODUCTS_DIR}/UnitTests.octest", active:true}
		end tell
		
		set active executable to executable named "otest"
		set active target to target named "UnitTests"
		
	end tell
	
end tell
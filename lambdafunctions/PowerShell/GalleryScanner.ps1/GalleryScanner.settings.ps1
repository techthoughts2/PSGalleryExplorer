<#
    .SYNOPSIS
    Use this for custom modifications to the build process if needed.
#>

###############################################################################
# Before/After Hooks for the Core Task: Clean
###############################################################################

# Synopsis: Executes before the Clean task.
#task BeforeClean -Before Clean {}

# Synopsis: Executes after the Clean task.
#task AfterClean -After Clean {}

###############################################################################
# Before/After Hooks for the Core Task: Analyze
###############################################################################

# Synopsis: Executes before the Analyze task.
#task BeforeAnalyze -Before Analyze {}

# Synopsis: Executes after the Analyze task.
#task AfterAnalyze -After Analyze {}

###############################################################################
# Before/After Hooks for the Core Task: Archive
###############################################################################

# Synopsis: Executes before the Archive task.
#task BeforeArchive -Before Archive {}

# Synopsis: Executes after the Archive task.
#task AfterArchive -After Archive {}

###############################################################################
# Before/After Hooks for the Core Task: Build
###############################################################################

# Synopsis: Executes before the Build task.
#task BeforeBuild -Before Build {}

# Synopsis: Executes after the Build task.
#task AfterBuild -After Build {}

###############################################################################
# Before/After Hooks for the Core Task: Test
###############################################################################

# Synopsis: Executes before the Test Task.
#task BeforeTest -Before Test {}

# Synopsis: Executes after the Test Task.
#task AfterTest -After Test {}

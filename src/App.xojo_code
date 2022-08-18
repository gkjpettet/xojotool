#tag Class
Protected Class App
Inherits ConsoleApplication
	#tag Event
		Function Run(args() as String) As Integer
		  // Register the MBS plugins.
		  // If you have cloned this repository, you will need a module named `RegisterPlugins` containing
		  // a method (`MBS`) that registers your MBS plugins.
		  #If Not DebugBuild
		    RegisterPlugins.MBS
		  #EndIf
		  
		  App.SemanticVersion = New SemanticVersion(App.MajorVersion, App.MinorVersion, App.BugVersion)
		  
		  Var xojotool As String = ConsoleKit.CLIFormatted("xojotool", True, False, False, ConsoleKit.Colors.Green)
		  
		  Parser = New ConsoleKit.OptionParser(xojotool, _
		  "A tool for displaying information about Xojo projects.")
		  
		  AddOptions
		  
		  #Pragma BreakOnExceptions False
		  Try
		    Parser.Parse(args)
		  Catch e As ConsoleKit.OptionException
		    Error(e.Message, True)
		  End Try
		  #Pragma BreakOnExceptions Default
		  
		  If parser.HelpRequested Then
		    Print("")
		    parser.ShowHelp
		    Quit(0)
		  End If
		  
		  If parser.BooleanValue("version") Then
		    PrintVersion
		    Quit(0)
		  End If
		  
		  AssertProjectFileOK
		  
		  ParseProjectFile
		  
		  If parser.BooleanValue("sloc") Then
		    Print(Project.CodeLineCount.ToString + " lines of code (excluding comments).")
		    
		  ElseIf parser.BooleanValue("tloc") Then
		    Print(Project.TotalLineCount.ToString + " lines of code (including comments).")
		    
		  ElseIf parser.BooleanValue("cloc") Then
		    Print(Project.CommentCount.ToString + " comment lines.")
		    
		  ElseIf parser.BooleanValue("summary") Then
		    PrintSummary
		    
		  ElseIf parser.BooleanValue("csv") Then
		    DumpToCSV
		    
		  ElseIf parser.BooleanValue("detail") Then
		    PrintDetails
		    
		  End If
		  
		End Function
	#tag EndEvent

	#tag Event
		Function UnhandledException(error As RuntimeException) As Boolean
		  Print(ConsoleKit.CLIFormatted("Unhandled exception", True, False, False, ConsoleKit.Colors.Red))
		  
		  Print(ConsoleKit.CLIBold("Error message:"))
		  Print(error.Message)
		  
		  Quit(-1)
		End Function
	#tag EndEvent


	#tag Method, Flags = &h0
		Sub AddOptions()
		  /// Adds the options the tool accepts.
		  
		  Parser.AddOption(_
		  New ConsoleKit.Option("v", "version", "Displays the current version.", ConsoleKit.OptionTypes.Boolean))
		  
		  Parser.AddOption(_
		  New ConsoleKit.Option("p", "project", "The Xojo project to work with.", ConsoleKit.OptionTypes.File))
		  
		  Parser.AddOption(_
		  New ConsoleKit.Option("s", "summary", "Prints a summary of the contents of the project (required).", _
		  ConsoleKit.OptionTypes.Boolean))
		  
		  Parser.AddOption(_
		  New ConsoleKit.Option("", "tloc", "Prints the total lines of code including comments.", _
		  ConsoleKit.OptionTypes.Boolean))
		  
		  Parser.AddOption(_
		  New ConsoleKit.Option("", "sloc", "Prints the total number of code line (excluding comments).", _
		  ConsoleKit.OptionTypes.Boolean))
		  
		  Parser.AddOption(_
		  New ConsoleKit.Option("", "cloc", "Prints the number of comment lines.", ConsoleKit.OptionTypes.Boolean))
		  
		  Parser.AddOption(_
		  New ConsoleKit.Option("", "csv", "Dumps the data to a CSV file", ConsoleKit.OptionTypes.Boolean))
		  
		  Parser.AddOption(_
		  New ConsoleKit.Option("d", "detail", _
		  "Prints a detailed breakdown of the project's composition.", ConsoleKit.OptionTypes.Boolean))
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 41737365727473207468617420612070726F6A6563742066696C6520686173206265656E2070617373656420746F2074686520746F6F6C2E
		Sub AssertProjectFileOK()
		  /// Asserts that a project file has been passed to the tool.
		  
		  ProjectFile = parser.FileValue("project")
		  
		  // Was any file passed?
		  If ProjectFile = Nil Then
		    Var message As String = "You must provide a Xojo project with the "
		    message = message + ConsoleKit.CLIBold("-p")
		    message = message + " or "
		    message = message + ConsoleKit.CLIBold("--project")
		    message = message + " options."
		    Error(message)
		  End If
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub DumpToCSV(Optional includeHeaders As Boolean = True)
		  Var f As FolderItem = SpecialFolder.Desktop.Child(System.Ticks.ToString + ".csv")
		  Var firstLine As Boolean = True
		  Var tout As TextOutputStream = TextOutputStream.Create(f)
		  
		  For Each item As XojoKit.XKItem In Project.Items
		    
		    If item.Type = XojoKit.ItemTypes.Folder Then
		      Continue
		    End If
		    
		    Var col() As String
		    
		    If firstLine and includeHeaders Then
		      col.Add("Item")
		      col.Add("Type")
		      col.Add("Members")
		      col.Add("SLOC")
		      col.Add("CLOC")
		      tout.WriteLine(String.FromArray(col, ","))
		      col.ResizeTo(-1)
		    End If
		    
		    col.Add(item.FQN)
		    col.Add(item.Type.ToString)
		    col.Add(item.MemberCount.ToString)
		    col.Add(item.CodeLineCount.ToString)
		    col.Add(item.CommentCount.ToString)
		    
		    tout.WriteLine(String.FromArray(col, ","))
		    firstLine = False
		  Next item
		  
		  tout.Close
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 5072696E747320616E206572726F72206D65737361676520616E64207175697473207769746820606572726F72436F6465602E
		Sub Error(message As String, showHelp As Boolean = True, errorCode As Integer = -1)
		  /// Prints an error message and quits with `errorCode`.
		  
		  Var s As String = ConsoleKit.CLIFormatted("Error", True, False, False, ConsoleKit.Colors.Red)
		  s = s + ": "
		  s = s + message
		  
		  Print(s)
		  
		  If showHelp Then
		    Print("")
		    Parser.ShowHelp
		  End If
		  
		  Quit(errorCode)
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 417474656D70747320746F207061727365207468652070726F6A6563742066696C652E
		Sub ParseProjectFile()
		  /// Attempts to parse the project file.
		  ///
		  /// Assumes ProjectFile is a valid file.
		  
		  #Pragma BreakOnExceptions False
		  
		  Project = New XojoKit.XKProject(ProjectFile)
		  
		  Project.Options.ExcludePrivate = False
		  
		  Try
		    
		    Project.Parse
		    
		  Catch e As XojoKit.XKException
		    
		    Error(e.Message)
		    
		  Catch e As RuntimeException
		    
		    Error("An unexpected internal error occured (" + e.Message + ").")
		    
		  End Try
		  
		  // Project successfully parsed.
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 5072696E747320612064657461696C656420627265616B646F776E206F66207468652070726F6A656374277320636F6D706F736974696F6E2E
		Sub PrintDetails()
		  /// Prints a detailed breakdown of the project's composition.
		  
		  Print("")
		  
		  // ===================
		  // BREAKDOWN
		  // ===================
		  Var breakdown As String = "Breakdown of "
		  breakdown = breakdown + ConsoleKit.CLIBold(Project.Name) + ":"
		  Print(breakdown)
		  Print("")
		  
		  // ===================
		  // IDE VERSION
		  // ===================
		  Print("Saved with Xojo " + ConsoleKit.CLIBold(Project.RBProjectVersion))
		  
		  // ===================
		  // LINE COUNTS
		  // ===================
		  Print(Project.CodeLineCount.ToString + " single lines of code")
		  Print(Project.CommentCount.ToString + " comment lines")
		  Print("")
		  
		  // ===================
		  // HEADER
		  // ===================
		  // Find the longest item FQN, member count and SLOC to format the header.
		  Var longestFQN As Integer = 4 // "Item" length.
		  Var longestType As Integer = 9
		  Var longestMembers As Integer = 7 //" Members" length.
		  Var longestSLOC As Integer = 4 // "SLOC" length.
		  Var LongestTLOC As Integer = 4 // "TLOC" length
		  Var LongestCLOC As Integer = 4 // "CLOC" length
		  For Each item As XojoKit.XKItem In Project.Items
		    If item.Type = XojoKit.ItemTypes.Folder Then Continue
		    
		    longestFQN = Max(longestFQN, item.fqn.Length)
		    longestMembers = Max(longestMembers, item.MemberCount.ToString.Length)
		    longestSLOC = Max(longestSLOC, item.CodeLineCount.ToString.Length)
		    Var itLocCount As Integer =  item.CodeLineCount + item.CommentCount
		    longestTLOC = Max(LongestTLOC, itLocCount.ToString.Length)
		    LongestCLOC = Max(LongestCLOC, item.CommentCount.ToString.Length)
		  Next item
		  
		  // Add in title spacing.
		  longestFQN = longestFQN + 3
		  longestType = longestType + 3
		  longestMembers = longestMembers + 3
		  longestSLOC = longestSLOC + 3
		  LongestTLOC = LongestTLOC + 3
		  LongestCLOC = LongestCLOC + 3
		  
		  Var itemTitle As String = "Item"
		  itemTitle = itemTitle.JustifyLeft(longestFQN)
		  
		  Var typeTitle As String = "Type"
		  typeTitle = typeTitle.JustifyLeft(longestType)
		  
		  Var membersTitle As String = "Members"
		  membersTitle = membersTitle.JustifyLeft(longestMembers)
		  
		  Var tlocTitle As String = "TLOC"
		  tlocTitle = tlocTitle.JustifyLeft(longestTLOC)
		  
		  Var slocTitle As String = "SLOC"
		  slocTitle = slocTitle.JustifyLeft(longestSLOC)
		  
		  Var clocTitle As String = "CLOC"
		  clocTitle = clocTitle.JustifyLeft(longestCLOC)
		  
		  Var rawHeader As String = itemTitle + typeTitle + membersTitle + tlocTitle + slocTitle + clocTitle
		  Var header As String = ConsoleKit.CLIFormatted(rawHeader, _
		  True, False, False, ConsoleKit.Colors.Blue)
		  
		  Var headerLine As String = RepeatString("-", rawHeader.Length - 3)
		  Print(headerLine)
		  Print(header)
		  Print(headerLine)
		  
		  // ===================
		  // ITEM DETAILS
		  // ===================
		  For Each item As XojoKit.XKItem In Project.Items
		    If item.Type = XojoKit.ItemTypes.Folder Then Continue
		    
		    Var type As String = item.Type.ToString.JustifyLeft(longestType)
		    Var fqn As String = item.FQN.JustifyLeft(longestFQN)
		    Var memberCount As String = item.MemberCount.ToString.JustifyLeft(longestMembers)
		    Var itLocCount As Integer =  item.CodeLineCount + item.CommentCount
		    Var tlocCount As String = itLocCount.ToString.JustifyLeft(LongestTLOC)
		    Var slocCount As String = item.CodeLineCount.ToString.JustifyLeft(longestSLOC)
		    Var clocCount As String = item.CommentCount.ToString.JustifyLeft(longestCLOC)
		    Print(fqn + type + memberCount + tlocCount + slocCount + clocCount)
		  Next item
		  
		  Print("")
		  
		  // ===================
		  // CAVEAT
		  // ===================
		  Print("NB: Currently " + _
		  ConsoleKit.CLIFormatted("xojotool", True, False, False, ConsoleKit.Colors.Green) + _
		  " only parses the contents of classes, interfaces, modules, containers and windows.")
		  Print("Code contained in Workers, etc is not counted.")
		  Print("")
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 5072696E747320612073756D6D617279206F6620746865207061727365642070726F6A6563742E
		Sub PrintSummary()
		  /// Prints a summary of the parsed project.
		  
		  Print("")
		  
		  // ===================
		  // SUMMARY
		  // ===================
		  Var summary As String = "Summary of "
		  summary = summary + ConsoleKit.CLIBold(Project.Name) + ":"
		  Print(summary)
		  Print("")
		  
		  // ===================
		  // HEADER
		  // ===================
		  Var header As String = _
		  ConsoleKit.CLIFormatted("Classes   Interfaces   Modules   Windows   Containers", _
		  True, False, False, ConsoleKit.Colors.Blue)
		  
		  Print("-----------------------------------------------------")
		  Print(header)
		  Print("-----------------------------------------------------")
		  
		  // ===================
		  // ITEM COUNTS
		  // ===================
		  Var modString, classString, interfaceString, windowString, containerString As String
		  classString = Project.ClassCount.ToString.JustifyLeft(10)
		  interfaceString = Project.InterfaceCount.ToString.JustifyLeft(13)
		  modString = Project.ModuleCount.ToString.JustifyLeft(10)
		  windowString = Project.WindowCount.ToString.JustifyLeft(10)
		  containerString = Project.ContainerCount.ToString
		  Print(classString + interfaceString + modString + windowString + containerString)
		  Print("")
		  
		  // ===================
		  // IDE VERSION
		  // ===================
		  Print("Saved with Xojo " + ConsoleKit.CLIBold(Project.RBProjectVersion))
		  
		  // ===================
		  // LINE COUNTS
		  // ===================
		  Print(Project.CodeLineCount.ToString + " single lines of code")
		  Print(Project.CommentCount.ToString + " comment lines")
		  Print("")
		  
		  // ===================
		  // CAVEAT
		  // ===================
		  Print("NB: Currently " + _
		  ConsoleKit.CLIFormatted("xojotool", True, False, False, ConsoleKit.Colors.Green) + _
		  " only parses the contents of classes, interfaces, modules, containers and windows.")
		  Print("Code contained in Workers, etc is not counted.")
		  Print("")
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 5072696E7473207468652063757272656E742076657273696F6E2064657461696C73206F662074686520746F6F6C2E
		Sub PrintVersion()
		  /// Prints the current version details of the tool.
		  ///
		  /// major.minor.bug (build BUILD_COUNT.RUN_COUNT)
		  
		  Var xojotool As String = ConsoleKit.CLIFormatted("xojotool", True, False, False, ConsoleKit.Colors.Green)
		  
		  Print(xojotool + " " + App.SemanticVersion.ToString)
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 52657475726E73206120737472696E6720637265736174656420627920726570656174696E67206073602060636F756E74602074696D65732E
		Function RepeatString(s As String, count As Integer) As String
		  /// Returns a string cresated by repeating `s` `count` times.
		  
		  Var tmp() As String
		  For i As Integer = 1 To count
		    tmp.Add(s)
		  Next i
		  
		  Return String.FromArray(tmp, "")
		  
		End Function
	#tag EndMethod


	#tag Property, Flags = &h0
		Parser As ConsoleKit.OptionParser
	#tag EndProperty

	#tag Property, Flags = &h0, Description = 5468652070617273656420586F6A6F2070726F6A6563742E
		Project As XojoKit.XKProject
	#tag EndProperty

	#tag Property, Flags = &h0, Description = 54686520586F6A6F2070726F6A6563742066696C6520746F20776F726B20776974682E
		ProjectFile As FolderItem
	#tag EndProperty

	#tag Property, Flags = &h0, Description = 54686973206170706C69636174696F6E27732073656D616E7469632076657273696F6E2E
		SemanticVersion As SemanticVersion
	#tag EndProperty


	#tag ViewBehavior
	#tag EndViewBehavior
End Class
#tag EndClass

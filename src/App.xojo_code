#tag Class
Protected Class App
Inherits ConsoleApplication
	#tag Event
		Function Run(args() as String) As Integer
		  App.SemanticVersion = New SemanticVersion(App.MajorVersion, App.MinorVersion, App.BugVersion)
		  
		  Var xojotool As String = ConsoleKit.CLIFormatted("xojotool", True, False, False, ConsoleKit.Colors.Green)
		  
		  Parser = New ConsoleKit.OptionParser(xojotool, _
		  "A tool for displaying information about Xojo projects.")
		  
		  AddOptions
		  
		  Parser.Parse(args)
		  
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
		    
		  End If
		  
		End Function
	#tag EndEvent


	#tag Method, Flags = &h0
		Sub AddOptions()
		  /// Adds the options the tool accepts.
		  
		  Parser.AddOption(_
		  New ConsoleKit.Option("", "version", "Displays the current version.", ConsoleKit.OptionTypes.Boolean))
		  
		  Parser.AddOption(_
		  New ConsoleKit.Option("", "project", "The Xojo project to work with.", ConsoleKit.OptionTypes.File))
		  
		  Parser.AddOption(_
		  New ConsoleKit.Option("", "summary", "Prints a summary of the contents of the project (required).", _
		  ConsoleKit.OptionTypes.Boolean))
		  
		  Parser.AddOption(_
		  New ConsoleKit.Option("", "tloc", "Prints the total lines of code including comments.", _
		  ConsoleKit.OptionTypes.Boolean))
		  
		  Parser.AddOption(_
		  New ConsoleKit.Option("", "sloc", "Prints the total number of code line (excluding comments).", _
		  ConsoleKit.OptionTypes.Boolean))
		  
		  Parser.AddOption(_
		  New ConsoleKit.Option("", "cloc", "Prints the number of comment lines.", ConsoleKit.OptionTypes.Boolean))
		  
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

	#tag Method, Flags = &h0, Description = 5072696E747320616E206572726F72206D65737361676520616E64207175697473207769746820606572726F72436F6465602E
		Sub Error(message As String, errorCode As Integer = -1)
		  /// Prints an error message and quits with `errorCode`.
		  
		  Var s As String = ConsoleKit.CLIFormatted("Error", True, False, False, ConsoleKit.Colors.Red)
		  s = s + ": "
		  s = s + message
		  
		  Print(s)
		  
		  Quit(errorCode)
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 417474656D70747320746F207061727365207468652070726F6A6563742066696C652E
		Sub ParseProjectFile()
		  /// Attempts to parse the project file.
		  ///
		  /// Assumes ProjectFile is a valid file.
		  
		  #Pragma BreakOnExceptions False
		  
		  Project = New XKProject(ProjectFile)
		  
		  Try
		    
		    Project.Parse
		    
		  Catch e As XKException
		    
		    Error(e.Message)
		    
		  Catch e As RuntimeException
		    
		    Error("An unexpected internal error occured (" + e.Message + ").")
		    
		  End Try
		  
		  // Project successfully parsed.
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 5072696E747320612073756D6D617279206F6620746865207061727365642070726F6A6563742E
		Sub PrintSummary()
		  /// Prints a summary of the parsed project.
		  
		  Print("")
		  
		  Var summary As String = "Summary of "
		  summary = summary + ConsoleKit.CLIBold(Project.Name) + ":"
		  Print(summary)
		  
		  Print("")
		  
		  Var header As String = _
		  ConsoleKit.CLIFormatted("Classes   Interfaces   Modules", True, False, False, ConsoleKit.Colors.Blue)
		  
		  Print("------------------------------")
		  Print(header)
		  Print("------------------------------")
		  
		  Var modCount, classCount, interfaceCount As Integer
		  Var modString, classString, interfaceString As String
		  For Each item As XKItem In Project.Items
		    Select Case item.Type
		    Case XojoKit.ItemTypes.Class_
		      classCount = classCount + 1
		      
		    Case XojoKit.ItemTypes.Interface_
		      interfaceCount = interfaceCount + 1
		      
		    Case XojoKit.ItemTypes.Module_
		      modCount = modCount + 1
		    End Select
		  Next item
		  
		  classString = classCount.ToString.JustifyLeft(10)
		  interfaceString = interfaceCount.ToString.JustifyLeft(13)
		  modString = modCount.ToString.JustifyLeft(10)
		  
		  Print(classString + interfaceString + modString)
		  
		  Print("")
		  
		  Print(Project.CodeLineCount.ToString + " single lines of code.")
		  Print(Project.CommentCount.ToString + " comment lines.")
		  
		  Print("")
		  
		  Print("NB: Currently " + _
		  ConsoleKit.CLIFormatted("xojotool", True, False, False, ConsoleKit.Colors.Green) + _
		  " only parses the contents of classes, interfaces and modules.")
		  Print("Code contained in Windows, Workers, etc is not counted.")
		  
		  Print("")
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 5072696E7473207468652063757272656E742076657273696F6E2064657461696C73206F662074686520746F6F6C2E
		Sub PrintVersion()
		  /// Prints the current version details of the tool.
		  ///
		  /// major.minor.bug (build BUILD_COUNT.RUN_COUNT)
		  
		  Var xojotool As String = ConsoleKit.CLIFormatted("xojotool", True, False, False, ConsoleKit.Colors.Green)
		  
		  Print(xojotool + " " + App.SemanticVersion.ToString + _
		  " (build " + App.NonReleaseVersion.ToString + "." + App.RunCount.ToString + ")")
		  
		End Sub
	#tag EndMethod


	#tag Property, Flags = &h0
		Parser As ConsoleKit.OptionParser
	#tag EndProperty

	#tag Property, Flags = &h0, Description = 5468652070617273656420586F6A6F2070726F6A6563742E
		Project As XKProject
	#tag EndProperty

	#tag Property, Flags = &h0, Description = 54686520586F6A6F2070726F6A6563742066696C6520746F20776F726B20776974682E
		ProjectFile As FolderItem
	#tag EndProperty

	#tag Property, Flags = &h0, Description = 54686973206170706C69636174696F6E27732073656D616E7469632076657273696F6E2E
		SemanticVersion As SemanticVersion
	#tag EndProperty


	#tag Constant, Name = RunCount, Type = Double, Dynamic = False, Default = \"46", Scope = Public, Description = 496E6372656D656E746564206279207468652060496E6372656D656E7441707052756E436F756E7460207363726970742065766572792074696D6520746865206170702069732072756E2E
	#tag EndConstant


	#tag ViewBehavior
	#tag EndViewBehavior
End Class
#tag EndClass

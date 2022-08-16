#tag Module
Protected Module XojoKit
	#tag Method, Flags = &h1, Description = 52657475726E73205472756520696620606C696E6560206973206120586F6A6F20636F6D6D656E74206C696E652E
		Protected Function IsCommentLine(line As String) As Boolean
		  /// Returns True if `line` is a Xojo comment line.
		  
		  line = line.Trim
		  
		  If line.IsEmpty Then Return False
		  
		  If line.BeginsWith("'") Or line.BeginsWith("//") Or line.BeginsWith("rem") Then
		    Return True
		  Else
		    Return False
		  End If
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1, Description = 52657475726E732060736020617320616E206974656D20747970652E2049662060736020697320696E76616C6964207468656E20616E2060584B457863657074696F6E60206973207261697365642E204361736520696E73656E7369746976652E
		Protected Function ItemTypeFromString(s As String) As XojoKit.ItemTypes
		  /// Returns `s` as an item type. If `s` is invalid then an `XKException` is raised. Case insensitive.
		  
		  Select Case s
		  Case "class"
		    Return XojoKit.ItemTypes.Class_
		    
		  Case "fileType"
		    Return XojoKit.ItemTypes.FileType_
		    
		  Case "folder"
		    Return XojoKit.ItemTypes.Folder
		    
		  Case "imageSet"
		    Return XojoKit.ItemTypes.ImageSet_
		    
		  Case "interface"
		    Return XojoKit.ItemTypes.Interface_
		    
		  Case "menuBar"
		    Return XojoKit.ItemTypes.MenuBar_
		    
		  Case "module"
		    Return XojoKit.ItemTypes.Module_
		    
		  Case "root"
		    Return XojoKit.ItemTypes.Root
		    
		  Case "toolBar"
		    Return XojoKit.ItemTypes.ToolBar_
		    
		  Case "window"
		    Return XojoKit.ItemTypes.Window_
		    
		  Else
		    Raise New XKException("Unknown item type: " + s)
		  End Select
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1, Description = 52657475726E73206073602061732061206D656D62657220747970652E2049662060736020697320696E76616C6964207468656E20616E2060584B457863657074696F6E60206973207261697365642E204361736520696E73656E7369746976652E
		Protected Function MemberTypeFromString(s As String) As XojoKit.MemberTypes
		  /// Returns `s` as a member type. If `s` is invalid then an `XKException` is raised. Case insensitive.
		  
		  Select Case s
		  Case "computedProperty"
		    Return XojoKit.MemberTypes.ComputedProperty_
		    
		  Case "constant"
		    Return XojoKit.MemberTypes.Constant_
		    
		  Case "delegate"
		    Return XojoKit.MemberTypes.Delegate_
		    
		  Case "enum"
		    Return XojoKit.MemberTypes.Enum_
		    
		  Case "event"
		    Return XojoKit.MemberTypes.Event_
		    
		  Case "eventDefinition"
		    Return XojoKit.MemberTypes.EventDefinition_
		    
		  Case "method"
		    Return XojoKit.MemberTypes.Method_
		    
		  Case "note"
		    Return XojoKit.MemberTypes.Note_
		    
		  Case "property"
		    Return XojoKit.MemberTypes.Property_
		    
		  Case "structure"
		    Return XojoKit.MemberTypes.Structure_
		    
		  Else
		    Raise New XKException("Unknown member type: " + s)
		  End Select
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1, Description = 52657475726E732060736020617320612073636F70652E2049662060736020697320696E76616C6964207468656E20605075626C6963602073636F70652069732072657475726E65642E
		Protected Function ScopeFromString(s As String) As Scopes
		  /// Returns `s` as a scope. If `s` is invalid then `Public` scope is returned.
		  
		  Select Case s
		  Case "Public"
		    Return Scopes.Public_
		    
		  Case "Protected"
		    Return Scopes.Protected_
		    
		  Case "Private"
		    Return Scopes.Private_
		    
		  Case "Global"
		    Return Scopes.Global_
		    
		  Else
		    Return Scopes.Public_
		  End Select
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 52657475726E73206120737472696E6720726570726573656E746174696F6E206F66206074797065602E
		Function ToString(Extends type As XojoKit.ItemTypes) As String
		  /// Returns a string representation of `type`.
		  
		  Select Case type
		  Case XojoKit.ItemTypes.Class_
		    Return "class"
		    
		  Case XojoKit.ItemTypes.FileType_
		    Return "fileType"
		    
		  Case XojoKit.ItemTypes.Folder
		    Return "folder"
		    
		  Case XojoKit.ItemTypes.ImageSet_
		    Return "imageSet"
		    
		  Case XojoKit.ItemTypes.Interface_
		    Return "interface"
		    
		  Case XojoKit.ItemTypes.MenuBar_
		    Return "menuBar"
		    
		  Case XojoKit.ItemTypes.Module_
		    Return "module"
		    
		  Case XojoKit.ItemTypes.Root
		    Return "root"
		    
		  Case XojoKit.ItemTypes.ToolBar_
		    Return "toolBar"
		    
		  Case XojoKit.ItemTypes.Unknown
		    Return "unknown"
		    
		  Case XojoKit.ItemTypes.Window_
		    Return "window"
		    
		  Else
		    Raise New InvalidArgumentException("Unknown item type.")
		  End Select
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 52657475726E73206120737472696E6720726570726573656E746174696F6E206F66206074797065602E
		Function ToString(Extends type As XojoKit.MemberTypes) As String
		  /// Returns a string representation of `type`.
		  
		  Select Case type
		  Case XojoKit.MemberTypes.ComputedProperty_
		    Return "computedProperty"
		    
		  Case XojoKit.MemberTypes.Constant_
		    Return "constant"
		    
		  Case XojoKit.MemberTypes.Delegate_
		    Return "delegate"
		    
		  Case XojoKit.MemberTypes.Enum_
		    Return "enum"
		    
		  Case XojoKit.MemberTypes.Event_
		    Return "event"
		    
		  Case XojoKit.MemberTypes.EventDefinition_
		    Return "eventDefinition"
		    
		  Case XojoKit.MemberTypes.Method_
		    Return "method"
		    
		  Case XojoKit.MemberTypes.Note_
		    Return "note"
		    
		  Case XojoKit.MemberTypes.Property_
		    Return "property"
		    
		  Case XojoKit.MemberTypes.Structure_
		    Return "structure"
		    
		  Else
		    Raise New XKException("Unknown member type.")
		  End Select
		End Function
	#tag EndMethod


	#tag ComputedProperty, Flags = &h1, Description = 5468652076657273696F6E20696E2074686520666F726D617420224D616A6F722E4D696E6F722E506174636822
		#tag Getter
			Get
			  Return VERSION_MAJOR.ToString + "." + _
			  VERSION_MINOR.ToString + "." + VERSION_PATCH.ToString
			  
			End Get
		#tag EndGetter
		Protected Version As String
	#tag EndComputedProperty


	#tag Constant, Name = VERSION_MAJOR, Type = Double, Dynamic = False, Default = \"1", Scope = Private
	#tag EndConstant

	#tag Constant, Name = VERSION_MINOR, Type = Double, Dynamic = False, Default = \"0", Scope = Private
	#tag EndConstant

	#tag Constant, Name = VERSION_PATCH, Type = Double, Dynamic = False, Default = \"1", Scope = Private
	#tag EndConstant


	#tag Enum, Name = FileFormats, Type = Integer, Flags = &h1
		Project
		  Unknown
		  XML
		Window
	#tag EndEnum

	#tag Enum, Name = ItemTypes, Flags = &h1, Description = 54686520737570706F72746564206F626A6563742074797065732E
		Class_
		  Interface_
		  Module_
		  Folder
		  Root
		  Window_
		  MenuBar_
		  ToolBar_
		  FileType_
		  ImageSet_
		Unknown
	#tag EndEnum

	#tag Enum, Name = MemberTypes, Type = Integer, Flags = &h1
		Constant_
		  Property_
		  Method_
		  Enum_
		  Event_
		  EventDefinition_
		  Delegate_
		  ComputedProperty_
		  Structure_
		  Note_
		Unknown
	#tag EndEnum

	#tag Enum, Name = Scopes, Type = Integer, Flags = &h1
		Public_
		  Private_
		  Protected_
		Global_
	#tag EndEnum


	#tag ViewBehavior
		#tag ViewProperty
			Name="Name"
			Visible=true
			Group="ID"
			InitialValue=""
			Type="String"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Index"
			Visible=true
			Group="ID"
			InitialValue="-2147483648"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Super"
			Visible=true
			Group="ID"
			InitialValue=""
			Type="String"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Left"
			Visible=true
			Group="Position"
			InitialValue="0"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Top"
			Visible=true
			Group="Position"
			InitialValue="0"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
	#tag EndViewBehavior
End Module
#tag EndModule

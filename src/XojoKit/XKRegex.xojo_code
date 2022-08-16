#tag Class
Protected Class XKRegex
	#tag Method, Flags = &h0
		Sub Constructor(pattern As String, caseSensitive As Boolean = False)
		  mPattern = pattern
		  mRegex = New RegExMBS
		  SetDefaults
		  mRegex.CompileOptionCaseLess = Not caseSensitive
		  
		  If Not mRegex.Compile(mPattern) Then
		    Raise New InvalidArgumentException("Unable to compile `pattern`.")
		  End If
		  
		  // Populate the named groups dictionary with any named groups in the pattern.
		  NamedGroups = New Dictionary
		  If mRegex.InfoNameCount > 0 Then
		    For i As Integer = 1 To mRegex.InfoNameCount
		      NamedGroups.Value(mRegex.InfoNameEntry(i)) = ""
		    Next i
		  End If
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 536561726368657320607360207573696E6720746865207265676578207061747465726E20646566696E656420617420696E7374616E74696174696F6E2072657475726E696E67205472756520696620746865726527732061207375636365737366756C206D617463682E
		Function Match(s As String) As Boolean
		  /// Searches `s` using the regex pattern defined at instantiation returning True if there's a successful match.
		  
		  // Clear out the existing named group values.
		  Var keys() As Variant = NamedGroups.Keys
		  For Each key As String In keys
		    NamedGroups.Value(key) = ""
		  Next key
		  
		  Var result As Boolean = mRegex.Match(s)
		  
		  Call mRegex.Execute(s)
		  
		  // Update the named groups.
		  For Each key As String In keys
		    NamedGroups.Value(key) = mRegex.Substring(key)
		  Next key
		  
		  Return result
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21, Description = 5365747320736F6D652073656E7369626C652064656661756C747320666F722074686520636C6173732E
		Private Sub SetDefaults()
		  /// Sets some sensible defaults for the class.
		  
		  mRegex.CompileOptionCaseLess = True
		  mRegex.CompileOptionDotAll = False
		  mRegex.CompileOptionUngreedy = False
		  mRegex.CompileOptionNewLineAnyCRLF = True
		  mRegex.ExecuteOptionNewLineAnyCRLF = true
		  mRegex.ExecuteOptionNotEmpty = False
		End Sub
	#tag EndMethod


	#tag Note, Name = About
		This is a wrapper class for easily running simple regex queries against a line of text. Assumes that the 
		regex pattern used at instantiation contains NAMED capture groups.
		
	#tag EndNote


	#tag Property, Flags = &h21
		Private mPattern As String
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mRegex As RegExMBS
	#tag EndProperty

	#tag Property, Flags = &h0, Description = 412064696374696F6E61727920636F6E7461696E696E6720616E79206E616D65642067726F75707320696E2074686520636F6D70696C6564207061747465726E732E20416674657220604D61746368282960207468652076616C7565732061726520706F70756C617465642E204B6579203D2047726F7570204E616D652C2056616C7565203D2047726F75702056616C75652E
		NamedGroups As Dictionary
	#tag EndProperty


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
End Class
#tag EndClass

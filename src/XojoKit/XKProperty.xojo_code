#tag Class
Protected Class XKProperty
Inherits XKMember
	#tag Method, Flags = &h0
		Sub Constructor(memberType As XojoKit.MemberTypes)
		  Self.MemberType = memberType
		  Self.IsComputed = memberType = XojoKit.MemberTypes.ComputedProperty_
		  
		End Sub
	#tag EndMethod


	#tag ComputedProperty, Flags = &h0, Description = 54686520746F74616C206E756D626572206F6620757365722D7772697474656E206C696E6573206F6620636F646520696E207468697320636F6D70757465642070726F70657274792E20436F6D70757465642E
		#tag Getter
			Get
			  Var count As Integer = 0
			  
			  // Getter.
			  For Each line As String In GetterLines
			    If Not line.Trim.IsEmpty And Not XojoKit.IsCommentLine(line) Then
			      count = count + 1
			    End If
			  Next line
			  
			  // Setter.
			  For Each line As String In GetterLines
			    If Not line.Trim.IsEmpty And Not XojoKit.IsCommentLine(line) Then
			      count = count + 1
			    End If
			  Next line
			  
			  Return count
			  
			End Get
		#tag EndGetter
		CodeLineCount As Integer
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0, Description = 54686520746F74616C206E756D62657220636F6D6D656E74206C696E657320696E207468697320636F6D70757465642070726F70657274792E20436F6D70757465642E
		#tag Getter
			Get
			  Var count As Integer = 0
			  
			  // Getter.
			  For Each line As String In GetterLines
			    If XojoKit.IsCommentLine(line) Then
			      count = count + 1
			    End If
			  Next line
			  
			  // Setter.
			  For Each line As String In GetterLines
			    If XojoKit.IsCommentLine(line) Then
			      count = count + 1
			    End If
			  Next line
			  
			  Return count
			  
			End Get
		#tag EndGetter
		CommentCount As Integer
	#tag EndComputedProperty

	#tag Property, Flags = &h0, Description = 546865206F7074696F6E616C2064656661756C742076616C75652E
		DefaultValue As String
	#tag EndProperty

	#tag Property, Flags = &h0, Description = 546865206C696E6573206F6620636F646520696E207468697320636F6D70757465642070726F70657274792773206765747465722E204D617920626520656D7074792E
		GetterLines() As String
	#tag EndProperty

	#tag Property, Flags = &h0, Description = 5472756520696620746869732070726F706572747920697320616E2061727261792E
		IsArray As Boolean = False
	#tag EndProperty

	#tag Property, Flags = &h0, Description = 547275652069662074686973206973206120636F6D70757465642070726F70657274792E
		IsComputed As Boolean = False
	#tag EndProperty

	#tag ComputedProperty, Flags = &h0, Description = 5472756520696620746869732069732061207265616461626C652070726F70657274792E204F6E6C79207265616C6C792072656C6576616E7420666F7220636F6D70757465642070726F706572746965732E2049676E6F7265732073636F70652E
		#tag Getter
			Get
			  If Self.IsComputed Then
			    Return GetterLines.Count > 0
			  Else
			    // Regular properties are always readable.
			    Return True
			  End If
			  
			End Get
		#tag EndGetter
		IsReadable As Boolean
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0, Description = 547275652069662074686973206973206120777269746561626C652070726F70657274792E204F6E6C79207265616C6C792072656C6576616E7420666F7220636F6D70757465642070726F706572746965732E2049676E6F7265732073636F70652E
		#tag Getter
			Get
			  If Self.IsComputed Then
			    Return SetterLines.Count > 0
			  Else
			    // Regular properties are always writeable.
			    Return True
			  End If
			  
			End Get
		#tag EndGetter
		IsWriteable As Boolean
	#tag EndComputedProperty

	#tag Property, Flags = &h0, Description = 546865206C696E6573206F66207465787420636F6D70726973696E6720746869732070726F70657274792773206E6F74652E204D617920626520656D7074792E
		NoteLines() As String
	#tag EndProperty

	#tag Property, Flags = &h0, Description = 546865206C696E6573206F6620636F646520696E207468697320636F6D70757465642070726F70657274792773207365747465722E204D617920626520656D7074792E
		SetterLines() As String
	#tag EndProperty

	#tag Property, Flags = &h0, Description = 546869732070726F7065727479277320747970652E
		Type As String
	#tag EndProperty


	#tag ViewBehavior
		#tag ViewProperty
			Name="Type"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="IsComputed"
			Visible=false
			Group="Behavior"
			InitialValue="False"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="IsReadable"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="IsWriteable"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
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
		#tag ViewProperty
			Name="Name"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="String"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="DefaultValue"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="IsArray"
			Visible=false
			Group="Behavior"
			InitialValue="False"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="CodeLineCount"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="CommentCount"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass

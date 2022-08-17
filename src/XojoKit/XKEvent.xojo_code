#tag Class
Protected Class XKEvent
Inherits XKMember
	#tag Method, Flags = &h0
		Sub Constructor()
		  Self.MemberType = XojoKit.MemberTypes.Event_
		  Self.Scope = XojoKit.Scopes.Private_
		End Sub
	#tag EndMethod


	#tag Note, Name = About
		Represents an event in a class.
		
	#tag EndNote


	#tag ComputedProperty, Flags = &h0, Description = 54686520746F74616C206E756D626572206F6620757365722D7772697474656E206C696E6573206F6620636F646520696E2074686973206576656E742E20436F6D70757465642E
		#tag Getter
			Get
			  Var count As Integer = 0
			  
			  For Each line As String In Lines
			    If Not line.Trim.IsEmpty And Not XojoKit.IsCommentLine(line) Then
			      count = count + 1
			    End If
			  Next line
			  
			  Return count
			  
			End Get
		#tag EndGetter
		CodeLineCount As Integer
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0, Description = 54686520746F74616C206E756D62657220636F6D6D656E74206C696E657320696E2074686973206576656E742E20436F6D70757465642E
		#tag Getter
			Get
			  Var count As Integer = 0
			  
			  For Each line As String In Lines
			    If XojoKit.IsCommentLine(line) Then
			      count = count + 1
			    End If
			  Next line
			  
			  Return count
			  
			End Get
		#tag EndGetter
		CommentCount As Integer
	#tag EndComputedProperty

	#tag Property, Flags = &h0, Description = 546865206C696E6573206F6620636F64652074686174206D616B652075702074686520626F6479206F662074686973206D6574686F642E
		Lines() As String
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
		#tag ViewProperty
			Name="Name"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="String"
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

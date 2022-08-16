#tag Class
Protected Class XKMethod
Inherits XKMember
	#tag Method, Flags = &h0
		Sub Constructor()
		  Self.MemberType = XojoKit.MemberTypes.Method_
		End Sub
	#tag EndMethod


	#tag Note, Name = About
		Represents a single method in a class, interface or module.
		
	#tag EndNote


	#tag ComputedProperty, Flags = &h0, Description = 54686520746F74616C206E756D626572206F6620757365722D7772697474656E206C696E6573206F6620636F646520696E2074686973206D6574686F642E20436F6D70757465642E
		#tag Getter
			Get
			  Var count As Integer = 0
			  
			  For Each line As String In Lines
			    If Not line.IsEmpty And Not XojoKit.IsCommentLine(line) Then
			      count = count + 1
			    End If
			  Next line
			  
			  Return count
			  
			End Get
		#tag EndGetter
		CodeLineCount As Integer
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0, Description = 54686520746F74616C206E756D62657220636F6D6D656E74206C696E657320696E2074686973206D6574686F642E20436F6D70757465642E
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
			Name="IsShared"
			Visible=false
			Group="Behavior"
			InitialValue="False"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Description"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="MemberType"
			Visible=false
			Group="Behavior"
			InitialValue="XojoKit.MemberTypes.Unknown"
			Type="XojoKit.MemberTypes"
			EditorType="Enum"
			#tag EnumValues
				"0 - Constant_"
				"1 - Property_"
				"2 - Method_"
				"3 - Enum_"
				"4 - Event_"
				"5 - EventDefinition_"
				"6 - Delegate_"
				"7 - ComputedProperty_"
				"8 - Structure_"
				"9 - Note_"
				"10 - Unknown"
			#tag EndEnumValues
		#tag EndViewProperty
		#tag ViewProperty
			Name="Scope"
			Visible=false
			Group="Behavior"
			InitialValue="XojoKit.Scopes.Public_"
			Type="XojoKit.Scopes"
			EditorType="Enum"
			#tag EnumValues
				"0 - Public_"
				"1 - Private_"
				"2 - Protected_"
				"3 - Global_"
			#tag EndEnumValues
		#tag EndViewProperty
		#tag ViewProperty
			Name="Signature"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="IsExcluded"
			Visible=false
			Group="Behavior"
			InitialValue="False"
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
			Name="ReturnType"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="String"
			EditorType="MultiLineEditor"
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
		#tag ViewProperty
			Name="ParameterString"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass

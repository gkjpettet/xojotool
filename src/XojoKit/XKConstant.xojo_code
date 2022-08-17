#tag Class
Protected Class XKConstant
Inherits XKMember
	#tag Method, Flags = &h0
		Sub Constructor()
		  Self.MemberType = XojoKit.MemberTypes.Constant_
		End Sub
	#tag EndMethod


	#tag Property, Flags = &h0, Description = 5468697320636F6E7374616E7427732064656661756C742076616C75652E204E6F6E2D6C6F63616C697365642C206E6F6E2D706C6174666F726D207370656369666320636F6E7374616E74732075736520746869732070726F706572747920746F2073746F72652074686569722076616C75652E
		DefaultValue As String
	#tag EndProperty

	#tag Property, Flags = &h0, Description = 49662054727565207468656E207468697320636F6E7374616E74206973202264796E616D6963222028692E652E20224C6F63616C697A65642220696E2074686520586F6A6F20494445292E
		IsDynamic As Boolean = False
	#tag EndProperty

	#tag Property, Flags = &h0, Description = 5468697320636F6E7374616E74277320747970652E
		Type As String
	#tag EndProperty

	#tag Property, Flags = &h0, Description = 5468697320636F6E7374616E74277320706C6174666F726D2F6C616E67756167652076617269616E74732E204D617920626520656D7470792E
		Variants() As XojoKit.XKConstantVariant
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
			Name="Type"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="IsDynamic"
			Visible=false
			Group="Behavior"
			InitialValue="False"
			Type="Boolean"
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
	#tag EndViewBehavior
End Class
#tag EndClass

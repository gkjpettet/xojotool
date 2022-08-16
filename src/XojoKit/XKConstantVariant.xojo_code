#tag Class
Protected Class XKConstantVariant
	#tag Note, Name = About
		Constants can have platform and language-specific variants. This class represents one of these variants.
		
	#tag EndNote


	#tag Property, Flags = &h0, Description = 546865206C616E677561676520746869732076617269616E74206170706C69657320746F2E2057696C6C206265202244656661756C7422206F72206120636F756E74727920636F64652E
		Language As String = "Default"
	#tag EndProperty

	#tag Property, Flags = &h0, Description = 54686520706C6174666F726D20746869732076617269616E74206170706C69657320746F2E
		Platform As String = "Any"
	#tag EndProperty

	#tag Property, Flags = &h0, Description = 5468652076616C7565206F66207468697320636F6E7374616E742076617269616E742E
		Value As String
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
			Name="Platform"
			Visible=false
			Group="Behavior"
			InitialValue="Any"
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Language"
			Visible=false
			Group="Behavior"
			InitialValue="Default"
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Value"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass

#tag Class
Protected Class XKStructure
Inherits XKMember
	#tag Method, Flags = &h0
		Sub Constructor()
		  Self.MemberType = XojoKit.MemberTypes.Structure_
		End Sub
	#tag EndMethod


	#tag Note, Name = About
		Represents a structure declaration.
		
	#tag EndNote


	#tag Property, Flags = &h0, Description = 54686973207374727563747572652773206669656C64732E
		Fields() As XojoKit.XKStructureField
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

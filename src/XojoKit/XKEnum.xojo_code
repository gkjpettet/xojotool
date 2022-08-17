#tag Class
Protected Class XKEnum
Inherits XKMember
	#tag Method, Flags = &h0
		Sub Constructor()
		  Self.MemberType = XojoKit.MemberTypes.Enum_
		End Sub
	#tag EndMethod


	#tag Property, Flags = &h0, Description = 54727565206966207468697320697320612062696E61727920656E756D65726174696F6E2E
		IsBinary As Boolean = False
	#tag EndProperty

	#tag Property, Flags = &h0, Description = 5468697320656E756D65726174696F6E2773206D656D62657273206173205061697220696E7374616E6365732E204C656674203D204D656D626572206E616D652C205269676874203D2056616C75652028496E7465676572292E205269676874204D6179206265204E696C206966206974277320746F2062652061737369676E6564206175746F6D61746963616C6C792062792074686520586F6A6F20636F6D70696C65722E
		Members() As Pair
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
			Name="IsBinary"
			Visible=false
			Group="Behavior"
			InitialValue="False"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass

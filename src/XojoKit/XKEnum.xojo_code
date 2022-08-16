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
			Name="ParameterString"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="String"
			EditorType="MultiLineEditor"
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

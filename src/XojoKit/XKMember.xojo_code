#tag Class
Protected Class XKMember
	#tag Property, Flags = &h0, Description = 54686973206D656D6265722773206F7074696F6E616C2061747472696275746573206173206B65792F76616C75652070616972732E204C656674203D204B65792028537472696E67292C205269676874203D2056616C75652028537472696E67292E
		Attributes_() As Pair
	#tag EndProperty

	#tag Property, Flags = &h0, Description = 4172626974726172792064617461206173736F636961746564207769746820746865206D656D6265722E
		Data As Variant
	#tag EndProperty

	#tag Property, Flags = &h0, Description = 546865206F7074696F6E616C20494445206465736372697074696F6E206F662074686973206D656D6265722E
		Description As String
	#tag EndProperty

	#tag Property, Flags = &h0, Description = 547275652069662074686973206D656D6265722073686F756C64206265206578636C75646564207768656E2067656E65726174696E672074686520646F63756D656E746174696F6E2E
		IsExcluded As Boolean = False
	#tag EndProperty

	#tag Property, Flags = &h0, Description = 49662054727565207468656E2074686973206D656D626572206973207368617265642E
		IsShared As Boolean = False
	#tag EndProperty

	#tag Property, Flags = &h0, Description = 54686973206D656D626572277320747970652E
		MemberType As XojoKit.MemberTypes = XojoKit.MemberTypes.Unknown
	#tag EndProperty

	#tag Property, Flags = &h0, Description = 54686973206D656D6265722773206E616D652E
		Name As String
	#tag EndProperty

	#tag Property, Flags = &h0, Description = 54686973206D656D6265722773206F7074696F6E616C20706172616D65746572732E
		Parameters() As XojoKit.XKParameter
	#tag EndProperty

	#tag Property, Flags = &h0, Description = 54686973206D656D6265722773206F7074696F6E616C20706172616D6574657273206173206120636F6E636174656E6174656420737472696E672028652E672E20227320417320537472696E672C206920417320496E746567657222292E
		ParameterString As String
	#tag EndProperty

	#tag Property, Flags = &h0, Description = 546865206D656D6265722773206F7074696F6E616C2072657475726E20747970652E
		ReturnType As String
	#tag EndProperty

	#tag Property, Flags = &h0, Description = 54686973206D656D62657227732073636F7065202F207669736962696C6974792E
		Scope As XojoKit.Scopes = XojoKit.Scopes.Public_
	#tag EndProperty

	#tag Property, Flags = &h0, Description = 54686973206D656D62657227732073696D706C6966696564207369676E617475726520666F7220757365722D666163696E6720646973706C61792E20466F7220736F6D65206D656D626572732C20746869732077696C6C206A75737420626520746865206D656D6265722773206E616D652E
		Signature As String
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
			Name="IsExcluded"
			Visible=false
			Group="Behavior"
			InitialValue="False"
			Type="Boolean"
			EditorType=""
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
			Name="Description"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
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
	#tag EndViewBehavior
End Class
#tag EndClass

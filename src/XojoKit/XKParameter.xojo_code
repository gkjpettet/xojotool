#tag Class
Protected Class XKParameter
	#tag Method, Flags = &h0
		Sub Constructor()
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor(name As String, type As String, isArray As Boolean = False, isParamArray As Boolean = False, defaultValue As String = "")
		  Self.Name = name
		  Self.Type = type
		  Self.IsArray = isArray
		  Self.IsParamArray = isParamArray
		  Self.DefaultValue = defaultValue
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 4120737472696E6720726570726573656E746174696F6E206F66207468697320706172616D657465722E
		Function ToString() As String
		  /// A string representation of this parameter.
		  
		  Var s As String
		  
		  If Self.IsParamArray Then
		    s = s + "ParamArray "
		  ElseIf Self.IsAssigns Then
		    s = s + "Assigns "
		  End If
		  
		  s = s + Self.Name + " As "
		  
		  s = s + Self.Type
		  
		  Return s
		  
		End Function
	#tag EndMethod


	#tag Note, Name = About
		Represents a parameter in a method.
		
	#tag EndNote


	#tag Property, Flags = &h0, Description = 546865206F7074696F6E616C2064656661756C742076616C75652E
		DefaultValue As String
	#tag EndProperty

	#tag Property, Flags = &h0, Description = 54727565206966207468697320706172616D6574657220697320616E2061727261792E
		IsArray As Boolean = False
	#tag EndProperty

	#tag Property, Flags = &h0, Description = 54727565206966207468697320697320616E2061737369676E6D656E7420706172616D657465722028692E652E206465636C61726564207769746820746865206041737369676E7360206B6579776F7264292E
		IsAssigns As Boolean = False
	#tag EndProperty

	#tag Property, Flags = &h0, Description = 547275652069662074686973206973206120706172616D20617272617920706172616D657465722E
		IsParamArray As Boolean = False
	#tag EndProperty

	#tag Property, Flags = &h0, Description = 546865206E616D65206F662074686520706172616D657465722E
		Name As String
	#tag EndProperty

	#tag Property, Flags = &h0, Description = 54686520706172616D657465722773206461746120747970652028652E672E20496E74656765722C20426F6F6C65616E2C20437573746F6D436C617373292E
		Type As String
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
			Name="DefaultValue"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="String"
			EditorType="MultiLineEditor"
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
			Name="IsArray"
			Visible=false
			Group="Behavior"
			InitialValue="False"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="IsParamArray"
			Visible=false
			Group="Behavior"
			InitialValue="False"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="IsAssigns"
			Visible=false
			Group="Behavior"
			InitialValue="False"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass

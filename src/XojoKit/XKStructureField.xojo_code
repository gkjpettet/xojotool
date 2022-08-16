#tag Class
Protected Class XKStructureField
	#tag Method, Flags = &h0
		Sub Constructor(index As Integer, name As String, type As String)
		  Self.Index = index
		  Self.Name = name
		  Self.Type = type
		End Sub
	#tag EndMethod


	#tag Note, Name = About
		The IDE doesn't seem to save the offset or size of a structure's fields. I think it must dynamically
		compute the values. This means the order they occur in the project item is important, hence the need 
		for each field to have a `Index` property. This is the order that they occur in their owning Structure.
		
	#tag EndNote


	#tag Property, Flags = &h0, Description = 54686520696E64657820746865206669656C64206170706561727320696E207468652049444527732053747275637475726520656469746F722E2054686520666972737420696E646578206973206030602E
		Index As Integer = 0
	#tag EndProperty

	#tag Property, Flags = &h0, Description = 546865206E616D65206F662074686973206669656C642E
		Name As String
	#tag EndProperty

	#tag Property, Flags = &h0, Description = 54686973206669656C64277320747970652E
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
			Name="Type"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Index"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass

#tag Interface
Protected Interface XKItemParser
	#tag Method, Flags = &h0, Description = 5061727365732074686520636F6E74656E7473206F6620616E206974656D2028636C6173732C206D6F64756C65206F7220696E746572666163652920696E746F2069747320636F6E7374697475656E74206D6574686F64732C2070726F706572746965732C206576656E747320616E64206E6F7465732E
		Sub Parse(ByRef item As XojoKit.XKItem, options As XojoKit.XKOptions)
		  
		End Sub
	#tag EndMethod


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
End Interface
#tag EndInterface

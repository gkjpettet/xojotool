#tag Class
Protected Class XKOptions
	#tag Method, Flags = &h0, Description = 52657475726E73206120636C6F6E65206F662074686973206F626A6563742E
		Function Clone() As XKOptions
		  /// Returns a clone of this object.
		  
		  Var options As New XKOptions
		  
		  options.ExcludeAppObject = Self.ExcludeAppObject
		  
		  For Each fqn As String In Self.ExcludedFQNs
		    options.ExcludedFQNs.Add(fqn)
		  Next fqn
		  
		  For Each type As XojoKit.ItemTypes In Self.ExcludedItemTypes
		    options.ExcludedItemTypes.Add(type)
		  Next type
		  
		  For Each type As XojoKit.MemberTypes In Self.ExcludedMemberTypes
		    options.ExcludedMemberTypes.Add(type)
		  Next type
		  
		  For Each path As String In Self.ExcludedPaths
		    options.ExcludedPaths.Add(path)
		  Next path
		  
		  options.ExcludePrivate = Self.ExcludePrivate
		  
		  Return options
		  
		End Function
	#tag EndMethod


	#tag Property, Flags = &h0, Description = 49662054727565207468656E20746865206170706C69636174696F6E206F626A6563742073686F756C64206265206578636C756465642E
		ExcludeAppObject As Boolean = False
	#tag EndProperty

	#tag Property, Flags = &h0, Description = 416E206172726179206F662066756C6C79207175616C6966696564206E616D657320746F206578636C7564652E
		ExcludedFQNs() As String
	#tag EndProperty

	#tag Property, Flags = &h0, Description = 4F7074696F6E616C206974656D2074797065732028652E672E2057696E646F77732C204D656E75426172732C206574632920746F206578636C7564652066726F6D207468652070726F6A6563742E
		ExcludedItemTypes() As XojoKit.ItemTypes
	#tag EndProperty

	#tag Property, Flags = &h0, Description = 4F7074696F6E616C206D656D6265722074797065732028652E672E20636F6E7374616E74732C2064656C65676174652C206574632920746F206578636C7564652066726F6D206974656D732E
		ExcludedMemberTypes() As XojoKit.MemberTypes
	#tag EndProperty

	#tag Property, Flags = &h0, Description = 416E206172726179206F66206F626A65637420706174687320286E6F742066696C652070617468732920746F206578636C7564652E2054686573652063616E206265207061727469616C2070617468732028652E672E2022466F6C646572312220776F756C64206578636C7564652022466F6C646572313E466F6C6465723222292E
		ExcludedPaths() As String
	#tag EndProperty

	#tag Property, Flags = &h0, Description = 49662054727565207468656E2070726976617465206F626A656374732C2070726F7065727469657320616E64206D6574686F64732077696C6C206265206578636C75646564207768656E2067656E65726174696E672074686520646F63756D656E746174696F6E2E2044656661756C7420697320547275652E
		ExcludePrivate As Boolean = True
	#tag EndProperty

	#tag Property, Flags = &h0, Description = 49662054727565207468656E206974656D73206D61726B6564206173206578636C756465642077696C6C20626520636F6D706C6574656C792072656D6F7665642066726F6D207468652070726F6A6563742E
		RemoveExcludedItems As Boolean = True
	#tag EndProperty

	#tag Property, Flags = &h0, Description = 49662054727565207468656E206974656D206D656D62657273206D61726B6564206173206578636C756465642077696C6C20626520636F6D706C6574656C792072656D6F7665642066726F6D20746865697220636F6E7461696E696E67206974656D2E
		RemoveExcludedMembers As Boolean = True
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
			Name="ExcludePrivate"
			Visible=false
			Group="Behavior"
			InitialValue="True"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="ExcludeAppObject"
			Visible=false
			Group="Behavior"
			InitialValue="False"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="RemoveExcludedItems"
			Visible=false
			Group="Behavior"
			InitialValue="True"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="RemoveExcludedMembers"
			Visible=false
			Group="Behavior"
			InitialValue="True"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass

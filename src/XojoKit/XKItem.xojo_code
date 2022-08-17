#tag Class
Protected Class XKItem
	#tag Method, Flags = &h21, Description = 436F6D70757465732074686520746F74616C206E756D626572206F6620757365722D7772697474656E206C696E6573206F6620636F646520616E6420636F6D6D656E74732E
		Private Sub ComputeLineAndCommentCounts()
		  /// Computes the total number of user-written lines of code and comments.
		  
		  // Computed properties.
		  For Each p As XKProperty In Self.Properties
		    If p.IsComputed Then
		      mCodeLineCount = mCodeLineCount + p.CodeLineCount
		      mCommentCount = mCommentCount + p.CommentCount
		    End If
		  Next p
		  
		  // Events.
		  For Each e As XKEvent In Self.Events
		    mCodeLineCount = mCodeLineCount + e.CodeLineCount
		    mCommentCount = mCommentCount + e.CommentCount
		  Next e
		  
		  // Methods.
		  For Each m As XKMethod In Self.Methods
		    mCodeLineCount = mCodeLineCount + m.CodeLineCount
		    mCommentCount = mCommentCount + m.CommentCount
		  Next m
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor(owner As XKProject)
		  Self.Owner = owner
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 52657475726E7320616E206172726179206F6620616E79206D656D6265727320696E2074686973206974656D207468617420636F756C6420686176652061206465736372697074696F6E2062757420617265206D697373696E67206F6E652E205468697320697320616E20657870656E73697665206F7065726174696F6E2E
		Function MembersMissingDescription(excludeConstructors As Boolean = False) As Variant()
		  /// Returns an array of any members in this item that could have a description but are missing one.
		  /// This is an expensive operation.
		  ///
		  /// We provide the option to exclude constructors because there is little point adding a description to
		  /// them for many developers as the IDE does not show their descriptions in the IDE.
		  
		  Var missing() As Variant
		  
		  // Constants.
		  For Each con As XKConstant In Self.Constants
		    If con.Description.IsEmpty Then missing.Add(con)
		  Next con
		  
		  // Delegates.
		  For Each d As XKDelegate In Self.Delegates
		    If d.Description.IsEmpty Then missing.Add(d)
		  Next d
		  
		  // Enums.
		  For Each en As XKEnum In Self.Enums
		    If en.Description.IsEmpty Then missing.Add(en)
		  Next en
		  
		  // Event definitions.
		  For Each ed As XKEventDefinition In Self.EventDefinitions
		    If ed.Description.IsEmpty Then missing.Add(ed)
		  Next ed
		  
		  // Methods.
		  For Each m As XKMethod In Self.Methods
		    If m.Description.IsEmpty Then
		      If excludeConstructors And m.Name = "Constructor" Then Continue
		      missing.Add(m)
		    End If
		  Next m
		  
		  // Properties.
		  For Each prop As XKProperty In Self.Properties
		    If prop.Description.IsEmpty Then missing.Add(prop)
		  Next prop
		  
		  // Structures.
		  For Each s As XKStructure In Self.Structures
		    If s.Description.IsEmpty Then missing.Add(s)
		  Next s
		  
		  Return missing
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 5061727365732074686520636F6E74656E7473206F6620746869732066696C6520696E746F2069747320636F6E7374697475656E74206D6574686F64732C2070726F706572746965732C206576656E747320616E64206E6F7465732E204D617920726169736520612060586F646F63457863657074696F6E602E
		Sub Parse(options As XKOptions)
		  /// Parses the contents of this item into its constituent methods, properties, events and notes.
		  /// May raise a `XKException`.
		  
		  Var parser As XKItemParser
		  
		  Select Case Self.FileFormat
		  Case XojoKit.FileFormats.Project, XojoKit.FileFormats.Window
		    parser = New XKProjectItemParser
		    
		  Case XojoKit.FileFormats.XML
		    parser = New XKXMLItemParser
		    
		  Else
		    Raise New XKException("Unable to parse file. Unknown file type.")
		  End Select
		  
		  parser.Parse(Self, options)
		  
		  ComputeLineAndCommentCounts
		  
		End Sub
	#tag EndMethod


	#tag Property, Flags = &h0, Description = 4F7074696F6E616C2061747472696275746573207468697320636C6173732C206D6F64756C65206F7220696E74657266616365206D617920686176652E204C656674203D20417474726962757465206E616D652028537472696E67292C205269676874203D204174747269627574652056616C75652028537472696E67292E
		Attributes_() As Pair
	#tag EndProperty

	#tag Property, Flags = &h0
		Children() As XojoKit.XKItem
	#tag EndProperty

	#tag Property, Flags = &h0, Description = 496620746869732069732061206D6F64756C652C2074686573652061726520616E7920636C617373657320636F6E7461696E65642077697468696E2069742E
		Classes() As XojoKit.XKItem
	#tag EndProperty

	#tag ComputedProperty, Flags = &h0, Description = 52657475726E732074686520746F74616C206E756D626572206F6620757365722D7772697474656E206C696E6573206F6620636F646520696E2074686973206974656D206578636C7564696E6720636F6D6D656E74732E20436F6D7075746564206F6E636520616674657220746865206974656D2069732070617273656420736F20696E657870656E7369766520746F2063616C6C2E
		#tag Getter
			Get
			  Return mCodeLineCount
			  
			End Get
		#tag EndGetter
		CodeLineCount As Integer
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0, Description = 52657475726E732074686520746F74616C206E756D626572206F6620636F6D6D656E747320696E2074686973206974656D2E20436F6D7075746564206F6E636520616674657220746865206974656D2069732070617273656420736F20696E657870656E7369766520746F2063616C6C2E
		#tag Getter
			Get
			  Return mCommentCount
			  
			End Get
		#tag EndGetter
		CommentCount As Integer
	#tag EndComputedProperty

	#tag Property, Flags = &h0, Description = 54686973206974656D277320636F6E7374616E74732E204D617920626520656D7074792E204F6E6C7920636C617373657320616E6420616E64206D6F64756C6573206861766520636F6E7374616E74732E
		Constants() As XojoKit.XKConstant
	#tag EndProperty

	#tag Property, Flags = &h0, Description = 4172626974726172792064617461206173736F63696174656420776974682074686973206974656D2E
		Data As Variant
	#tag EndProperty

	#tag Property, Flags = &h0, Description = 54686973206974656D27732064656C6567617465732E
		Delegates() As XojoKit.XKDelegate
	#tag EndProperty

	#tag Property, Flags = &h0, Description = 4F7074696F6E616C20656E756D65726174696F6E732E204D617920626520656D7074792E204F6E6C7920636C617373657320616E64206D6F64756C65732063616E206861766520656E756D65726174696F6E732E
		Enums() As XojoKit.XKEnum
	#tag EndProperty

	#tag Property, Flags = &h0, Description = 546865206974656D2773206576656E7420646566696E6974696F6E732E204F6E6C7920636C61737365732068617665206576656E7420646566696E6974696F6E732E
		EventDefinitions() As XojoKit.XKEventDefinition
	#tag EndProperty

	#tag Property, Flags = &h0, Description = 54686973206974656D2773206576656E74732E204F6E6C7920636C6173736573206D61792068617665206576656E74732E
		Events() As XojoKit.XKEvent
	#tag EndProperty

	#tag Property, Flags = &h0, Description = 5468652061637475616C2066696C65206F6E206469736B20636F6E7461696E696E672074686973206F626A656374277320586F6A6F20636F64652E204973204E696C20666F72206974656D732077697468696E20616E20584D4C2070726F6A65637420746861742061726520696E7465726E616C2E
		File As FolderItem
	#tag EndProperty

	#tag Property, Flags = &h0, Description = 54686520666F726D617420746861742074686973206F626A65637420697320656E636F6465642061732E
		FileFormat As XojoKit.FileFormats = XojoKit.FileFormats.Project
	#tag EndProperty

	#tag Property, Flags = &h0, Description = 5468652066756C6C79207175616C6966696564206E616D65202846514E2C20646F74206E6F746174696F6E29206F6620746865206F626A65637420726570726573656E74656420627920746869732066696C652E
		FQN As String
	#tag EndProperty

	#tag Property, Flags = &h0, Description = 54686520756E69717565204944206F662074686973206F626A65637420696E207468652070726F6A656374206D616E69666573742E
		ID As Integer
	#tag EndProperty

	#tag Property, Flags = &h0, Description = 5468652046514E73206F6620616E79206F7074696F6E616C20696E7465726661636573207468697320636C617373206F7220696E7465726661636520696D706C656D656E74732E
		ImplementedInterfaces() As String
	#tag EndProperty

	#tag Property, Flags = &h0, Description = 496620746869732069732061206D6F64756C652C207468697320697320616E7920696E74657266616365732074686174206D617920626520646566696E65642077697468696E2069742E
		Interfaces() As XojoKit.XKItem
	#tag EndProperty

	#tag Property, Flags = &h0, Description = 547275652069662074686973206974656D206973207468652070726F6A6563742773206170706C69636174696F6E206F626A6563742E
		IsApplicationObject As Boolean = False
	#tag EndProperty

	#tag Property, Flags = &h0, Description = 547275652069662074686973206974656D2073686F756C64206265206578636C75646564207768656E2067656E65726174696E6720646F63756D656E746174696F6E2E
		IsExcluded As Boolean = False
	#tag EndProperty

	#tag Property, Flags = &h0, Description = 54727565206966207468697320697320616E2065787465726E616C2070726F6A656374206974656D2E
		IsExternal As Boolean = False
	#tag EndProperty

	#tag Property, Flags = &h21, Description = 4261636B732060436F64654C696E65436F756E74602E2054686520746F74616C206E756D626572206F6620757365722D7772697474656E206C696E6573206F6620636F646520696E2074686973206974656D206578636C7564696E6720636F6D6D656E74732E20436F6D707574656420616674657220746865206974656D206973207061727365642E
		Private mCodeLineCount As Integer = 0
	#tag EndProperty

	#tag Property, Flags = &h21, Description = 54686520746F74616C206E756D626572206F6620636F6D6D656E747320696E2074686973206974656D2E
		Private mCommentCount As Integer = 0
	#tag EndProperty

	#tag ComputedProperty, Flags = &h0, Description = 54686520746F74616C206E756D626572206F66206D656D6265727320286578636C7564657320636C61737365732C20696E746572666163657320616E64207375626D6F64756C657320636F6E7461696E65642062792074686973206974656D292E
		#tag Getter
			Get
			  Return _
			  Constants.Count + _
			  Delegates.Count + _
			  Enums.Count + _
			  EventDefinitions.Count + _
			  Events.Count + _
			  Methods.Count + _
			  Notes.Count + _
			  Properties.Count + _
			  Structures.Count
			End Get
		#tag EndGetter
		MemberCount As Integer
	#tag EndComputedProperty

	#tag Property, Flags = &h0, Description = 54686973206974656D2773206D6574686F64732E204D617920636F6E7461696E2061206D697874757265206F662073686172656420616E6420696E7374616E6365206D6574686F64732E
		Methods() As XojoKit.XKMethod
	#tag EndProperty

	#tag Property, Flags = &h0, Description = 496620746869732069732061206D6F64756C652C2074686573652061726520616E79207375626D6F64756C657320636F6E7461696E65642077697468696E2069742E
		Modules() As XojoKit.XKItem
	#tag EndProperty

	#tag Property, Flags = &h21, Description = 41207765616B207265666572656E636520746F20746F207468652070726F6A6563742074686174206F776E732074686973206974656D2E
		Private mOwner As WeakRef
	#tag EndProperty

	#tag Property, Flags = &h0, Description = 546865206E616D65206F662074686520586F6A6F206F626A65637420726570726573656E74656420627920746869732066696C652E
		Name As String
	#tag EndProperty

	#tag Property, Flags = &h0, Description = 54686973206974656D2773206F7074696F6E616C206E6F7465732E
		Notes() As XojoKit.XKNote
	#tag EndProperty

	#tag ComputedProperty, Flags = &h0, Description = 41207765616B207265666572656E636520746F207468652070726F6A6563742074686174206F776E732074686973206974656D2E
		#tag Getter
			Get
			  If mOwner = Nil Or mOwner.Value = Nil Then
			    Return Nil
			  Else
			    Return XKProject(mOwner.Value)
			  End If
			  
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  If value = Nil Then
			    mOwner = Nil
			  Else
			    mOwner = New WeakRef(value)
			  End If
			  
			End Set
		#tag EndSetter
		Owner As XojoKit.XKProject
	#tag EndComputedProperty

	#tag Property, Flags = &h0, Description = 546865204944206F662074686520706172656E74206F662074686973206F626A6563742E6030602069732074686520746F702D6C6576656C206F66207468652070726F6A6563742E
		ParentID As Integer
	#tag EndProperty

	#tag Property, Flags = &h0, Description = 54686520686965726172636879207061746820746F2074686973206F626A6563742028692E652E2074686520636F6E7461696E696E67206D6F64756C657320616E6420666F6C64657273292E2057696C6C20626520656D70747920696620746865206F626A6563742069732061742074686520726F6F74206F66207468652070726F6A6563742E
		Path As String
	#tag EndProperty

	#tag Property, Flags = &h0, Description = 54686973206974656D27732070726F706572746965732E204D617920626520656D7074792E204F6E6C7920636C617373657320616E64206D6F64756C65732063616E20686176652070726F706572746965732E
		Properties() As XojoKit.XKProperty
	#tag EndProperty

	#tag Property, Flags = &h0, Description = 5468652073636F7065206F6620746865206F626A6563742028636C6173732C206D6F64756C652C20696E74657266616365292073657269616C697365642077697468696E20746869732066696C652E
		Scope As XojoKit.Scopes = XojoKit.Scopes.Public_
	#tag EndProperty

	#tag Property, Flags = &h0, Description = 54686973206974656D2773206F7074696F6E616C20737472756374757265732E204F6E6C7920636C617373657320616E64206D6F64756C6573206D617920636F6E7461696E20737472756374757265732E
		Structures() As XojoKit.XKStructure
	#tag EndProperty

	#tag Property, Flags = &h0, Description = 496620746869732066696C6520726570726573656E7473206120636C6173732C207468697320697320746865206F7074696F6E616C207375706572636C6173732E
		Superclass As String
	#tag EndProperty

	#tag Property, Flags = &h0, Description = 5468652074797065206F6620586F6A6F206F626A65637420746869732066696C6520726570726573656E74732E
		Type As XojoKit.ItemTypes = XojoKit.ItemTypes.Unknown
	#tag EndProperty

	#tag Property, Flags = &h0, Description = 4966207468697320697320616E20696E7465726E616C206974656D2077697468696E20616E20584D4C2070726F6A656374207468656E20746869732070726F706572747920636F6E7461696E732074686520584D4C206E6F646520726570726573656E74696E6720746865206974656D2C2065787472616374656420647572696E67206D616E69666573742070617273696E672E
		XML As XmlNode
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
			Name="ID"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="ParentID"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="FQN"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Path"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Superclass"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="IsExternal"
			Visible=false
			Group="Behavior"
			InitialValue="False"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="CodeLineCount"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="CommentCount"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="IsApplicationObject"
			Visible=false
			Group="Behavior"
			InitialValue="False"
			Type="Boolean"
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
			Name="MemberCount"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass

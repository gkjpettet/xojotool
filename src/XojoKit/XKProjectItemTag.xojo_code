#tag Class
Protected Class XKProjectItemTag
	#tag Method, Flags = &h0
		Sub Constructor(line As String)
		  /// Extracts the tag data from a #tag line in a .xojo_code item file.
		  ///
		  /// #tag TypeString, Name = NameString, Type = ClassType, Dynamic = Boolean, Flags = HexLiteral, 
		  /// Description = Base64String, Scope = ScopeString, Default = \"ValueString", Binary = Boolean, 
		  /// Attributes = \"AttributeString"
		  ///
		  /// AttributeString → Attribute(\x2C Attribute)*
		  /// Attribute       → NAME \x3D VALUE
		  /// Note above that `\x2C` is a comma and `\x3D` is the equal sign. Who designed this file format??
		  
		  // Remove the #tag prefix.
		  line = line.Replace("#tag", "").Trim
		  
		  Var parts() As String = line.Split(",")
		  Self.TagType = parts(0).Trim
		  parts.RemoveAt(0)
		  
		  If parts.Count = 0 Then Return
		  
		  // Trim the parts.
		  For i As Integer = 0 To parts.LastIndex
		    parts(i) = parts(i).Trim
		  Next i
		  
		  For Each part As String In parts
		    Var keyValue() As String = part.Split(" = ")
		    Var key As String = keyValue(0)
		    Var value As String = keyValue(1)
		    
		    Select Case key
		    Case "Name"
		      Self.Name = value
		      
		    Case "Type"
		      Self.Type = value
		      
		    Case "Flags"
		      Self.Flags = value
		      
		    Case "Default"
		      Self.Default = value
		      
		      // If the default key is present, the value is a string prefixed with `\` and flanked with "".
		      If Self.Default.Left(2) = "\""" Then
		        Self.Default = Self.Default.Middle(2, Default.Length - 3)
		      End If
		      
		    Case "Attributes"
		      value = value.ReplaceAll("\x2C", ",").ReplaceAll("\x3D", "=").Trim
		      If value.BeginsWith("\""") Then value = value.Replace("\""", "")
		      If value.EndsWith("""") Then value = value.Left(value.Length - 1)
		      Var atts() As String = value.Split(",")
		      For Each att As String In atts
		        Var nameValue() As String = att.Split("=")
		        If nameValue.Count = 1 Then
		          Self.Attributes_.Add(nameValue(0).Trim : "")
		        Else
		          Self.Attributes_.Add(nameValue(0).Trim : nameValue(1).Trim)
		        End If
		      Next att
		      
		    Case "Scope"
		      Self.Scope = XojoKit.ScopeFromString(value)
		      
		    Case "Description"
		      Self.Description = value
		      Self.Description = DecodeHex(Self.Description)
		      
		    Case "Dynamic"
		      Self.IsDynamic = If(value = "True", True, False)
		      
		    Case "Binary"
		      Self.IsBinary = If(value = "True", True, False)
		      
		    End Select
		    
		  Next part
		  
		End Sub
	#tag EndMethod


	#tag Note, Name = About
		Represents a "#tag" entry in a .xojo_code file.
		
	#tag EndNote


	#tag Property, Flags = &h0, Description = 54686973207461672773206F7074696F6E616C2061747472696275746573206173206B65792F76616C75652070616972732E204C656674203D204B65792028537472696E67292C205269676874203D2056616C75652028537472696E67292E
		Attributes_() As Pair
	#tag EndProperty

	#tag Property, Flags = &h0, Description = 5468652076616C7565206F662074686973207461672773206044656661756C7460206B6579202869662070726573656E74292E
		Default As String
	#tag EndProperty

	#tag Property, Flags = &h0, Description = 5468652076616C7565206F66207468697320746167277320604465736372697074696F6E60206B6579202869662070726573656E74292E
		Description As String
	#tag EndProperty

	#tag Property, Flags = &h0, Description = 546865206026686020707265666978656420686578206C69746572616C2076616C7565206F6620746869732074616727732060466C61677360206B65792E
		Flags As String
	#tag EndProperty

	#tag Property, Flags = &h0, Description = 5472756520696620746869732074616727732062696E61727920666C616720697320547275652E2054686973206973206F6E6C79207573656420696E20656E756D65726174696F6E732E
		IsBinary As Boolean = False
	#tag EndProperty

	#tag Property, Flags = &h0, Description = 5472756520696620746869732074616727732064796E616D696320666C616720697320547275652E2049207468696E6B2074686973206973206F6E6C79207573656420696E20636F6E7374616E74732E
		IsDynamic As Boolean = False
	#tag EndProperty

	#tag Property, Flags = &h0, Description = 5468652076616C7565206F662074686520604E616D6560206B657920696E2074686973207461672E
		Name As String
	#tag EndProperty

	#tag Property, Flags = &h0, Description = 546869732074616727732073636F70652E
		Scope As XojoKit.Scopes = XojoKit.Scopes.Public_
	#tag EndProperty

	#tag Property, Flags = &h0, Description = 5468652074797065206F66207461672E20452E672E20666F7220222374616720436C617373222C206054616754797065203D20436C617373602E
		TagType As String
	#tag EndProperty

	#tag Property, Flags = &h0, Description = 5468697320746167277320747970652028652E672E2022436C617373222C2022436F6E7374616E7422292E
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
			Name="Default"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="String"
			EditorType="MultiLineEditor"
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
			Name="Flags"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="IsBinary"
			Visible=false
			Group="Behavior"
			InitialValue="False"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="IsDynamic"
			Visible=false
			Group="Behavior"
			InitialValue="False"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="TagType"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass

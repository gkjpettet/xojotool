#tag Class
Protected Class XKXMLItemParser
Implements XKItemParser
	#tag Method, Flags = &h21, Description = 436F6D707574657320616E642072657475726E732074686520706173736564206576656E74277320757365722D666163696E67207369676E617475726520286C657373206465636F726174696F6E73206C696B6520617474726962757465732C20657463292E
		Private Function ComputeEventSignature(e As XKEvent) As String
		  /// Computes and returns the passed event's user-facing signature (less decorations like attributes, etc).
		  
		  Var sig as String = e.Name + "("
		  
		  For i As Integer = 0 To e.Parameters.LastIndex
		    Var p As XKParameter = e.Parameters(i)
		    sig = sig + p.ToString + If(i < e.Parameters.LastIndex, ", ", "")
		  Next i
		  sig = sig + ")"
		  If e.ReturnType <> "" Then
		    sig = sig + " As " + e.ReturnType
		  End If
		  
		  Return sig
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21, Description = 54616B65732061207061727469616C6C792070617273656420636F6D70757465642070726F706572747920616E6420636F6D706C657465732069742062792070617273696E672074686520636F6E74656E7473206F662074686520706173736564202250726F70657274792220584D4C206E6F64652E
		Private Function FinishParsingComputedProperty(cp As XKProperty, node As XmlNode) As XKProperty
		  /// Takes a partially parsed computed property and completes it by 
		  /// parsing the contents of the passed "Property" XML node.
		  ///
		  /// Assumes `node` is a valid property node that was used to generate `p`.
		  
		  Var iLimit As Integer = node.ChildCount - 1
		  For i As Integer = 0 To iLimit
		    Var child As XmlNode = node.Child(i)
		    Select Case child.Name
		    Case "GetAccessor"
		      // Getter.
		      cp.GetterLines = ParseGetterOrSetter(child)
		      
		    Case "SetAccessor"
		      // Setter.
		      cp.SetterLines = ParseGetterOrSetter(child)
		      
		    End Select
		  Next i
		  
		  // The signature is just the name.
		  cp.Signature = cp.Name
		  
		  Return cp
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21, Description = 54616B65732061207061727469616C6C792070617273656420726567756C61722070726F70657274792074686174206973206B6E6F776E20746F206E6F74206265206120636F6D70757465642070726F706572747920616E6420636F6D706C657465732069742062792070617273696E672074686520636F6E74656E7473206F662074686520706173736564202250726F70657274792220584D4C206E6F64652E
		Private Function FinishParsingProperty(prop As XKProperty, node As XmlNode) As XKProperty
		  /// Takes a partially parsed regular property that is known to not be a computed property and completes it by 
		  /// parsing the contents of the passed "Property" XML node.
		  ///
		  /// Assumes `node` is a valid property node that was used to generate `prop`.
		  
		  prop.IsArray = If(prop.Name.IndexOf("(") = -1, False, True)
		  
		  Var iLimit As Integer = node.ChildCount - 1
		  For i As Integer = 0 To iLimit
		    Var child As XmlNode = node.Child(i)
		    Select Case child.Name
		    Case "ItemDeclaration"
		      Var tmp() As String = child.FirstChild.Value.Split(" As ")
		      Var typeDefault() As String = tmp(1).Split(" = ")
		      prop.DefaultValue = If(typeDefault.Count = 1, "", typeDefault(1).Trim)
		      
		    End Select
		  Next i
		  
		  // The signature is just the name.
		  prop.Signature = prop.Name
		  
		  Return prop
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 5061727365732074686520636F6E74656E7473206F6620616E206974656D20696E746F2069747320636F6E7374697475656E74206D6574686F64732C2070726F706572746965732C206576656E747320616E64206E6F7465732E
		Sub Parse(ByRef item As XojoKit.XKItem, options As XojoKit.XKOptions)
		  /// Parses the contents of an item into its constituent methods, properties, events and notes.
		  ///
		  /// The XML to parse should be stored in `item.XML`.
		  /// Part of the XKItemParser interface.
		  
		  // Sanity check.
		  If item.XML = Nil Then
		    Raise New XKException("Unable to parse item as its XML property is Nil.")
		  End If
		  
		  // Keep a reference to the parsing options.
		  mOptions = options
		  
		  // We need to track a couple of flags.
		  Var isClass, isInterface As Boolean = False
		  
		  Var iLimit As Integer = item.XML.ChildCount - 1
		  For i As Integer = 0 To iLimit
		    Var node As XmlNode = item.XML.Child(i)
		    
		    Select Case node.Name
		    Case "IsClass"
		      isClass = If(node.FirstChild.Value = "0", False, True)
		      
		    Case "IsInterface"
		      isInterface = If(node.FirstChild.Value = "0", False, True)
		      
		    Case "Attributes"
		      item.Attributes_ = ParseAttributesNode(node)
		      
		    Case "SuperClass"
		      item.Superclass = If(node.FirstChild = Nil, "", node.FirstChild.Value)
		      
		    Case "IsApplicationObject"
		      item.IsApplicationObject = If(node.FirstChild.Value = "0", False, True)
		      
		    Case "Method"
		      item.Methods.Add(ParseMethod(node))
		      
		    Case "Constant"
		      item.Constants.Add(ParseConstant(node))
		      
		    Case "Property"
		      // Could be either a regular property or a computed property.
		      Var prop As XKProperty = ParseProperty(node)
		      If prop <> Nil Then
		        If prop.IsComputed Then
		          // Parse the rest of the node for the computed property specific data.
		          item.Properties.Add(FinishParsingComputedProperty(prop, node))
		        Else
		          // Parse the rest of the node for the regular property specific data.
		          item.Properties.Add(FinishParsingProperty(prop, node))
		        End If
		      End If
		      
		    Case "Note"
		      item.Notes.Add(ParseNote(node))
		      
		    Case "DelegateDeclaration"
		      item.Delegates.Add(ParseDelegate(node))
		      
		    Case "Enumeration"
		      item.Enums.Add(ParseEnum(node))
		      
		    Case "Hook"
		      // Event definition (NOT an event implementation).
		      item.EventDefinitions.Add(ParseEventDefinition(node))
		      
		    Case "HookInstance"
		      // Event *implementation* (NOT an event definition).
		      item.Events.Add(ParseEvent(node))
		      
		    Case "Structure"
		      item.Structures.Add(ParseStructure(node))
		      
		    Case "ControlBehavior"
		      If item.Type = XojoKit.ItemTypes.Window_ Then
		        // This is an event implement within a control on a window.
		        // Add any events implemented by this control to this window's events. This is obviously
		        // incorrect but it's what the project item parser does so for now we will replicate it.
		        ParseControlBehaviourNode(item, node)
		      End If
		    End Select
		  Next i
		  
		  // Determine the type of item if not already known by analysing the isClass and isInterface flags.
		  If item.Type = XojoKit.ItemTypes.Unknown Then
		    If isInterface Then
		      item.Type = XojoKit.ItemTypes.Interface_
		    ElseIf isClass Then
		      item.Type = XojoKit.ItemTypes.Class_
		    Else
		      item.Type = XojoKit.ItemTypes.Module_
		    End If
		  End If
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21, Description = 54616B657320616E2022417474726962757465732220584D4C206E6F646520616E642072657475726E7320746865206174747269627574657320617320616E206172726179206F662050616972732E204C656674203D204B65792028537472696E67292C205269676874203D2056616C75652028537472696E67292E
		Private Function ParseAttributesNode(node As XmlNode) As Pair()
		  /// Takes an "Attributes" XML node and returns the attributes as an array of Pairs.
		  /// Left = Key (String), Right = Value (String).
		  ///
		  /// ```
		  /// <Attributes>MySuperAttribute, AttributeWithValue = "Hello World"</Attributes>
		  /// ```
		  
		  Var atts() As Pair
		  
		  If node.FirstChild = Nil Then Return atts
		  
		  Var rawValue As String = node.FirstChild.Value.Trim
		  
		  Var rawAtts() As String = rawValue.Split(",")
		  For Each rawAtt As String In rawAtts
		    
		    Var keyValues() As String = rawAtt.Split("=")
		    
		    If keyValues.Count = 1 Then
		      atts.Add(keyValues(0).Trim : "")
		    Else
		      atts.Add(keyValues(0).Trim : keyValues(1).Trim)
		    End If
		  Next rawAtt
		  
		  Return atts
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21, Description = 50617273657320616E20584D4C2022436F6E7374616E7422206E6F646520696E746F20616E2060584B436F6E7374616E74602E
		Private Function ParseConstant(node As XmlNode) As XKConstant
		  /// Parses an XML "Constant" node into an `XKConstant`.
		  ///
		  /// Assumes that `node` has already been validated to be a "Constant" node.
		  
		  Var con As New XKConstant
		  
		  // We set this to False as I'm not sure when it's supposed to be True. Ah the joys of reverse engineering...
		  con.IsDynamic = False
		  
		  Var iLimit As Integer = node.ChildCount - 1
		  For i As Integer = 0 To iLimit
		    Var child As XmlNode = node.Child(i)
		    Select Case child.Name
		    Case "Attributes"
		      con.Attributes_ = ParseAttributesNode(child)
		      
		    Case "CodeDescription"
		      con.Description = If(child.FirstChild <> Nil, child.FirstChild.Value, "")
		      
		    Case "ConstantInstance"
		      con.Variants.Add(ParseConstantVariant(child))
		      
		    Case "ItemDef"
		      con.DefaultValue = If(child.FirstChild <> Nil, child.FirstChild.Value, "")
		      
		    Case "ItemFlags"
		      con.Scope = ScopeFromXMLInteger(Integer.FromString(child.FirstChild.Value))
		      
		    Case "ItemName"
		      con.Name = child.FirstChild.Value
		      
		    Case "ItemType"
		      con.Type = If(child.FirstChild <> Nil, child.FirstChild.Value, "")
		      
		    End Select
		  Next i
		  
		  // The signature is just the name.
		  con.Signature = con.Name
		  
		  // Exclude this member?
		  con.IsExcluded = XKProject.ShouldExcludeMember(con, mOptions)
		  
		  Return con
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21, Description = 50617273657320616E20584D4C2022436F6E7374616E74496E7374616E636522206E6F646520696E746F20616E2060584B436F6E7374616E7456617269616E74602E
		Private Function ParseConstantVariant(node As XmlNode) As XKConstantVariant
		  /// Parses an XML "ConstantInstance" node into an `XKConstantVariant`.
		  ///
		  /// Assumes that `node` has already been validated to be a "ConstantInstance" node.
		  
		  Var cv As New XKConstantVariant
		  
		  Var iLimit As Integer = node.ChildCount - 1
		  For i As Integer = 0 To iLimit
		    Var child As XmlNode = node.Child(i)
		    Select Case child.Name
		    Case "ItemPlatform"
		      cv.Platform = If(child.FirstChild = Nil, "", child.FirstChild.Value)
		      
		    Case "ItemLanguage"
		      cv.Language = If(child.FirstChild = Nil, "", child.FirstChild.Value)
		      
		    Case "ItemDef"
		      cv.Value = If(child.FirstChild = Nil, "", child.FirstChild.Value)
		    End Select
		  Next i
		  
		  Return cv
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21, Description = 50617273657320616E20584D4C2022436F6E74726F6C4265686176696F7222206E6F646520696E746F20612060584B4576656E74607320666F7220606974656D602E
		Private Sub ParseControlBehaviourNode(item As XKItem, node As XmlNode)
		  /// Parses an XML "ControlBehavior" node into a `XKEvent`s for `item`.
		  ///
		  /// Strictly speaking this the implementation of an event within a control.
		  
		  Var iLimit As Integer = node.ChildCount - 1
		  For i As Integer = 0 To iLimit
		    Var child As XmlNode = node.Child(i)
		    Select Case child.Name
		    Case "HookInstance"
		      Var controlEvent As XKEvent = ParseEvent(child)
		      If controlEvent <> Nil Then
		        item.Events.Add(controlEvent)
		      End If
		    End Select
		  Next i
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21, Description = 50617273657320616E20584D4C202244656C65676174654465636C61726174696F6E22206E6F646520696E746F20616E2060584B44656C6567617465602E
		Private Function ParseDelegate(node As XmlNode) As XKDelegate
		  /// Parses an XML "DelegateDeclaration" node into an `XKDelegate`. 
		  ///
		  /// Assumes that `node` has already been validated to be a "DelegateDeclaration" node.
		  
		  Var d As New XKDelegate
		  
		  Var iLimit As Integer = node.ChildCount - 1
		  For i As Integer = 0 To iLimit
		    Var child As XmlNode = node.Child(i)
		    Select Case child.Name
		    Case "ItemName"
		      d.Name = child.FirstChild.Value
		      
		    Case "ItemFlags"
		      d.Scope = ScopeFromXMLInteger(Integer.FromString(child.FirstChild.Value))
		      
		    Case "CodeDescription"
		      d.Description = If(child.FirstChild <> Nil, child.FirstChild.Value, "")
		      
		    Case "ItemResult"
		      d.ReturnType = If(child.FirstChild <> Nil, child.FirstChild.Value, "")
		      
		    Case "Attributes"
		      d.Attributes_ = ParseAttributesNode(child)
		      
		    Case "ItemParams"
		      d.Parameters = ParseParametersNode(child)
		      d.ParameterString = If(child.FirstChild = Nil, "", child.FirstChild.Value)
		    End Select
		  Next i
		  
		  // Compute the signature.
		  d.Signature = d.Name + "(" + d.ParameterString + ")" + If(d.ReturnType = "", "", " As " + d.ReturnType)
		  
		  // Exclude this member?
		  d.IsExcluded = XKProject.ShouldExcludeMember(d, mOptions)
		  
		  Return d
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21, Description = 50617273657320616E20584D4C2022456E756D65726174696F6E22206E6F646520696E746F20616E2060584B456E756D602E
		Private Function ParseEnum(node As XmlNode) As XKEnum
		  /// Parses an XML "Enumeration" node into an `XKEnum`.
		  ///
		  /// Assumes that `node` has already been validated to be an "Enumeration" node.
		  
		  Var e As New XKEnum
		  
		  Var iLimit As Integer = node.ChildCount - 1
		  For i As Integer = 0 To iLimit
		    Var child As XmlNode = node.Child(i)
		    Select Case child.Name
		    Case "Attributes"
		      e.Attributes_ = ParseAttributesNode(child)
		      
		    Case "BinaryEnum"
		      e.IsBinary = If(Integer.FromString(child.FirstChild.Value) = 0, False, True)
		      
		    Case "CodeDescription"
		      e.Description = If(child.FirstChild <> Nil, child.FirstChild.Value, "")
		      
		    Case "ItemFlags"
		      e.Scope = ScopeFromXMLInteger(Integer.FromString(child.FirstChild.Value))
		      
		    Case "ItemName"
		      e.Name = child.FirstChild.Value
		      
		    Case "ItemSource"
		      e.Members = ParseEnumMembers(child)
		      
		    End Select
		  Next i
		  
		  // The signature is just the name.
		  e.Signature = e.Name
		  
		  // Exclude this member?
		  e.IsExcluded = XKProject.ShouldExcludeMember(e, mOptions)
		  
		  Return e
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21, Description = 50617273657320616E20584D4C20656E756D277320224974656D536F7572636522206E6F646520696E746F20616E206172726179206F6620506169727320726570726573656E74696E672069742773206D656D626572732E
		Private Function ParseEnumMembers(node As XmlNode) As Pair()
		  /// Parses an XML enum's "ItemSource" node into an array of Pairs representing it's members.
		  ///
		  /// Assumes that `node` has already been validated to be an "ItemSource" node within an "Enum" node.
		  /// Left = Member name, Right = Value (Integer).
		  /// `Right` May be Nil if it's to be assigned automatically by the Xojo compiler.
		  
		  Var members() As Pair
		  
		  Var iLimit As Integer = node.ChildCount - 1
		  For i As Integer = 0 To iLimit
		    Var child As XmlNode = node.Child(i)
		    Select Case child.Name
		    Case "SourceLine"
		      If child.FirstChild = Nil Then Continue
		      Var nameDefault() As String = child.FirstChild.Value.Split(" = ")
		      If nameDefault.Count = 1 Then
		        members.Add(nameDefault(0) : Nil)
		      Else
		        members.Add(nameDefault(0) : nameDefault(1))
		      End If
		    End Select
		  Next i
		  
		  Return members
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21, Description = 50617273657320616E20584D4C2022486F6F6B496E7374616E636522206E6F646520696E746F20616E2060584B4576656E74602E
		Private Function ParseEvent(node As XmlNode) As XKEvent
		  /// Parses an XML "HookInstance" node into an `XKEvent`.
		  
		  Var e As New XKEvent
		  
		  Var iLimit As Integer = node.ChildCount - 1
		  For i As Integer = 0 To iLimit
		    Var child As XmlNode = node.Child(i)
		    Select Case child.Name
		    Case "ItemName"
		      e.Name = child.FirstChild.Value
		      
		    Case "ItemSource"
		      // First use our helper to get the source lines within the event.
		      e.Lines = ParseItemSourceNode(child)
		      
		      // Now we'll parse the first `SourceLine` node in `ItemSource` as it's the event's signature line.
		      For a As Integer = 0 To child.ChildCount - 1
		        Var itemSourceChild As XmlNode = child.Child(a)
		        If itemSourceChild.Name = "SourceLine" And itemSourceChild.FirstChild <> Nil Then
		          // Only the first source line is the declaration.
		          Var sigLine As String = itemSourceChild.FirstChild.Value
		          Var rx As New XKRegex(REGEX_EVENT_FUNCTION_SIG)
		          If Not rx.Match(sigLine) Then
		            rx = New XKRegex(REGEX_EVENT_SUB_SIG)
		            If Not rx.Match(sigLine) Then
		              Raise New XKException("Expected an event handler's signature line.")
		            End If
		          End If
		          If rx.NamedGroups.Lookup("params", "") <> "" Then
		            Var params() As String = rx.NamedGroups.Value("params").StringValue.Split(", ")
		            Var paramRx As New XKRegex(REGEX_PARAM)
		            For Each param As String In params
		              If Not paramRx.Match(param) Then
		                Raise New XKException("Invalid parameter within an event handler signature.")
		              Else
		                Var p As New XKParameter
		                p.DefaultValue = paramRx.NamedGroups.Lookup("default", "")
		                p.IsParamArray = If(paramRx.NamedGroups.Lookup("isParamArray", "") = "", False, True)
		                p.Name = paramRx.NamedGroups.Lookup("name", "")
		                p.IsArray = If(p.Name.IndexOf("(") = -1, False, True)
		                p.Type = paramRx.NamedGroups.Lookup("type", "")
		                e.Parameters.Add(p)
		              End If
		            Next param
		          End If
		          Exit
		        End If
		      Next a
		      
		    Case "CodeDescription"
		      e.Description = If(child.FirstChild <> Nil, child.FirstChild.Value, "")
		      
		    End Select
		  Next i
		  
		  // Compute the event's signature.
		  e.Signature = ComputeEventSignature(e)
		  
		  // Exclude this member?
		  e.IsExcluded = XKProject.ShouldExcludeMember(e, mOptions)
		  
		  Return e
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21, Description = 50617273657320616E20584D4C2022486F6F6B22206E6F646520696E746F20616E2060584B4576656E74446566696E6974696F6E602E
		Private Function ParseEventDefinition(node As XmlNode) As XKEventDefinition
		  /// Parses an XML "Hook" node into an `XKEventDefinition`.
		  
		  Var ed As NEw XKEventDefinition
		  
		  Var iLimit As Integer = node.ChildCount - 1
		  For i As Integer = 0 To iLimit
		    Var child As XmlNode = node.Child(i)
		    Select Case child.Name
		    Case "Attributes"
		      ed.Attributes_ = ParseAttributesNode(child)
		      
		    Case "CodeDescription"
		      ed.Description = If(child.FirstChild <> Nil, child.FirstChild.Value, "")
		      
		    Case "ItemName"
		      ed.Name = child.FirstChild.Value
		      
		    Case "ItemParams"
		      ed.Parameters = ParseParametersNode(child)
		      ed.ParameterString = If(child.FirstChild = Nil, "", child.FirstChild.Value)
		    Case "ItemResult"
		      ed.ReturnType = If(child.FirstChild <> Nil, child.FirstChild.Value, "")
		    End Select
		  Next i
		  
		  // Compute the signature.
		  ed.Signature = ed.Name + "(" + ed.ParameterString + ")" + If(ed.ReturnType = "", "", " As " + ed.ReturnType)
		  
		  // Exclude this member?
		  ed.IsExcluded = XKProject.ShouldExcludeMember(ed, mOptions)
		  
		  Return ed
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21, Description = 506172736573206120224765744163636573736F7222206F7220225365744163636573736F722220584D4C206E6F646520746F20616E206172726179206F66206C696E657320726570726573656E74696E672074686520636F64652077697468696E2061206765747465722F736574746572206F66206120636F6D70757465642070726F70657274792E
		Private Function ParseGetterOrSetter(node As XmlNode) As String()
		  /// Parses a "GetAccessor" or "SetAccessor" XML node to an array of lines representing the code within a 
		  /// getter/setter of a computed property.
		  ///
		  /// Example:
		  /// ```
		  /// <GetAccessor>
		  ///  <TextEncoding>134217984</TextEncoding>
		  ///  <SourceLine>Get</SourceLine>
		  ///  <SourceLine></SourceLine>
		  ///  <SourceLine>End Get</SourceLine>
		  /// </GetAccessor>
		  /// ```
		  /// I'm ignoring the text encoding because I haven't reverse engineered it yet!
		  
		  Var lines() As String
		  Var sourceLineCount As Integer = 0
		  Var iLimit As Integer = node.ChildCount - 1
		  For i As Integer = 0 To iLimit
		    Var child As XmlNode = node.Child(i)
		    Select Case child.Name
		    Case "SourceLine"
		      If sourceLineCount = 0 Then
		        // The first line should be ignored.
		        sourceLineCount = 1
		        Continue
		      End If
		      
		      // Don't add the last line.
		      If i < iLimit Then
		        If child.FirstChild = Nil Then
		          lines.Add("")
		        Else
		          lines.Add(child.FirstChild.Value)
		        End If
		      End If
		    End Select
		  Next i
		  
		  Return lines
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21, Description = 54616B657320616E20224974656D536F757263652220584D4C206E6F646520616E642072657475726E7320746865206C696E6573206F6620636F64652C206578636C7564696E6720746865206465636C61726174696F6E20616E6420656E64206C696E65732E
		Private Function ParseItemSourceNode(node As XmlNode) As String()
		  /// Takes an "ItemSource" XML node and returns the lines of code, excluding the declaration and end lines.
		  ///
		  /// ```
		  /// <ItemSource>
		  ///  <TextEncoding>134217984</TextEncoding>
		  ///  <SourceLine>SIGNATURE</SourceLine>
		  ///  <SourceLine>Code line 1</SourceLine>
		  ///  <SourceLine>...</SourceLine>
		  ///  <SourceLine>Code line n</SourceLine>
		  ///  <SourceLine>END DECLARATION</SourceLine>
		  /// </ItemSource>
		  /// ```
		  ///
		  /// I'm ignoring the text encoding because I haven't reverse engineered it yet!
		  
		  Var lines() As String
		  Var sourceLineCount As Integer = 0
		  Var iLimit As Integer = node.ChildCount - 1
		  For i As Integer = 0 To iLimit
		    Var child As XmlNode = node.Child(i)
		    Select Case child.Name
		    Case "SourceLine"
		      If sourceLineCount = 0 Then
		        // The first line should be ignored.
		        sourceLineCount = 1
		        Continue
		      End If
		      
		      // Don't add the last line.
		      If i < iLimit Then
		        If child.FirstChild = Nil Then
		          lines.Add("")
		        Else
		          lines.Add(child.FirstChild.Value)
		        End If
		      End If
		      
		    End Select
		  Next i
		  
		  Return lines
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21, Description = 50617273657320616E20584D4C20224D6574686F6422206E6F646520696E746F20616E2060584B4D6574686F64602E
		Private Function ParseMethod(node As XmlNode) As XKMethod
		  /// Parses an XML "Method" node into an `XKMethod`.
		  ///
		  /// Assumes that `node` has already been validated to be a "Method" node.
		  
		  Var m As New XKMethod
		  
		  Var iLimit As Integer = node.ChildCount - 1
		  For i As Integer = 0 To iLimit
		    Var child As XmlNode = node.Child(i)
		    Select Case child.Name
		    Case "ItemName"
		      m.Name = child.FirstChild.Value
		      
		    Case "ItemFlags"
		      m.Scope = ScopeFromXMLInteger(Integer.FromString(child.FirstChild.Value))
		      
		    Case "IsShared"
		      m.IsShared = If(child.FirstChild.Value = "0", False, True)
		      
		    Case "CodeDescription"
		      m.Description = If(child.FirstChild <> Nil, child.FirstChild.Value, "")
		      
		    Case "ItemResult"
		      m.ReturnType = If(child.FirstChild <> Nil, child.FirstChild.Value, "")
		      
		    Case "ItemSource"
		      m.Lines = ParseItemSourceNode(child)
		      
		    Case "Attributes"
		      m.Attributes_ = ParseAttributesNode(child)
		      
		    Case "ItemParams"
		      m.Parameters = ParseParametersNode(child)
		      m.ParameterString = If(child.FirstChild = Nil, "", child.FirstChild.Value)
		    End Select
		  Next i
		  
		  // Compute the signature.
		  m.Signature = m.Name + "(" + m.ParameterString + ")" + If(m.ReturnType = "", "", " As " + m.ReturnType)
		  
		  // Exclude this member?
		  m.IsExcluded = XKProject.ShouldExcludeMember(m, mOptions)
		  
		  Return m
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21, Description = 50617273657320616E20584D4C20224E6F746522206E6F646520696E746F20616E2060584B4E6F7465602E
		Private Function ParseNote(node As XmlNode) As XKNote
		  /// Parses an XML "Note" node into an `XKNote`.
		  ///
		  /// Assumes that `node` has already been validated to be a "Note" node.
		  
		  Var note As New XKNote
		  
		  Var iLimit As Integer = node.ChildCount - 1
		  For i As Integer = 0 To iLimit
		    Var child As XmlNode = node.Child(i)
		    Select Case child.Name
		    Case "ItemName"
		      note.Name = child.FirstChild.Value
		      
		    Case "CodeDescription"
		      note.Description = If(child.FirstChild = Nil, "", child.FirstChild.Value)
		      
		    Case "ItemSource"
		      Var noteLineCount As Integer = 0
		      Var jLimit As Integer = child.ChildCount - 1
		      For j As Integer = 0 To jLimit
		        Var itemSourceChild As XmlNode = child.Child(j)
		        Select Case itemSourceChild.Name
		        Case "NoteLine"
		          If noteLineCount = 0 Then
		            // The first line should be ignored (it's the note's title again).
		            noteLineCount = 1
		            Continue
		          End If
		          If itemSourceChild.FirstChild <> Nil Then
		            note.Lines.Add(itemSourceChild.FirstChild.Value)
		          Else
		            note.Lines.Add("")
		          End If
		        End Select
		      Next j
		      
		    End Select
		  Next i
		  
		  // The signature is just the name.
		  note.Signature = note.Name
		  
		  // Exclude this member?
		  note.IsExcluded = XKProject.ShouldExcludeMember(note, mOptions)
		  
		  Return note
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21, Description = 54616B657320616E20224974656D506172616D732220584D4C206E6F646520616E642072657475726E732074686520706172616D65746572732028696620616E792920617320616E206172726179206F6620584B506172616D65746572732E
		Private Function ParseParametersNode(node As XmlNode) As XKParameter()
		  /// Takes an "ItemParams" XML node and returns the parameters (if any) as an array of XKParameters.
		  ///
		  /// If there are no parameters then ItemParams is empty. 
		  /// If there are parameters then the node contains the parameter string, e.g:
		  /// `i As Integer, s As String = "Hello"`
		  
		  Var result() As XKParameter
		  
		  If node = Nil Or node.FirstChild = Nil Then Return result
		  
		  Var params() As String = node.FirstChild.Value.Split(", ")
		  Var paramRx As New XKRegex(REGEX_PARAM)
		  For Each param As String In params
		    If Not paramRx.Match(param) Then
		      Raise New XKException("Invalid parameter within ""ItemParams"" node.")
		    Else
		      Var p As New XKParameter
		      p.DefaultValue = paramRx.NamedGroups.Lookup("default", "")
		      p.IsParamArray = If(paramRx.NamedGroups.Lookup("isParamArray", "") = "", False, True)
		      p.IsAssigns = If(paramRx.NamedGroups.Lookup("isAssigns", "") = "", False, True)
		      p.Name = paramRx.NamedGroups.Lookup("name", "")
		      p.IsArray = If(p.Name.IndexOf("(") = -1, False, True)
		      p.Type = paramRx.NamedGroups.Lookup("type", "")
		      result.Add(p)
		    End If
		  Next param
		  
		  Return result
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21, Description = 54616B65732061202250726F70657274792220584D4C206E6F646520616E642072657475726E7320616E2061627374726163742070726F706572747920636F6D70726973696E672074686520636F6D6D6F6E2064617461206F6620626F746820726567756C617220616E6420636F6D70757465642070726F706572746965732E
		Private Function ParseProperty(node As XmlNode) As XKProperty
		  /// Takes a "Property" XML node and returns a property comprising the common data of both 
		  /// regular and computed properties.
		  
		  // Default to a regular property.
		  Var prop As New XKProperty(XojoKit.MemberTypes.Property_)
		  
		  If node = Nil Then Return Nil
		  
		  Var iLimit As Integer = node.ChildCount - 1
		  For i As Integer = 0 To iLimit
		    Var child As XmlNode = node.Child(i)
		    
		    Select Case child.Name
		    Case "ItemName"
		      prop.Name = child.FirstChild.Value
		      
		    Case "ItemFlags"
		      prop.Scope = ScopeFromXMLInteger(Integer.FromString(child.FirstChild.Value))
		      
		    Case "CodeDescription"
		      prop.Description = If(child.FirstChild <> Nil, child.FirstChild.Value, "")
		      
		    Case "IsShared"
		      prop.IsShared = If(child.FirstChild.Value = "0", False, True)
		      
		    Case "Attributes"
		      prop.Attributes_ = ParseAttributesNode(child)
		      
		    Case "SetAccessor", "GetAccessor"
		      prop.IsComputed = True
		      
		    Case "ItemDeclaration"
		      Var tmp() As String = child.FirstChild.Value.Split(" As ")
		      Var typeDefault() As String = tmp(1).Split(" = ")
		      prop.Type = typeDefault(0)
		      
		    Case "ItemSource"
		      // Note.
		      prop.NoteLines = ParsePropertyNote(child)
		      
		    End Select
		  Next i
		  
		  // If this is a computed property, update its type to match.
		  If prop.IsComputed Then
		    prop.MemberType = XojoKit.MemberTypes.ComputedProperty_
		  End If
		  
		  // Exclude this member?
		  prop.IsExcluded = XKProject.ShouldExcludeMember(prop, mOptions)
		  
		  Return prop
		  
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21, Description = 50617273657320616E20224974656D536F7572636522206E6F64652077697468696E20612070726F706572747920584D4C206E6F64652E2054686973206D617920636F6E7461696E2061206E6F74652077686963682069732072657475726E656420617320616E206172726179206F66206C696E65732E
		Private Function ParsePropertyNote(node As XmlNode) As String()
		  /// Parses an "ItemSource" node within a property XML node. This may contain a note which is returned as an
		  /// array of lines.
		  ///
		  /// ```
		  /// <ItemSource>
		  ///  <TextEncoding>134217984</TextEncoding>  <--- Always present
		  ///   <SourceLine>Property PublicComputedPropWithNote As Integer</SourceLine> <---- Always present
		  ///   <SourceLine>Here is a note.</SourceLine> <--- optional `n` occurrences
		  /// </ItemSource>
		  /// ```
		  /// I'm ignoring the text encoding because I haven't reverse engineered it yet!
		  
		  Var lines() As String
		  Var sourceLineCount As Integer = 0
		  Var iLimit As Integer = node.ChildCount - 1
		  For i As Integer = 0 To iLimit
		    Var child As XmlNode = node.Child(i)
		    Select Case child.Name
		    Case "SourceLine"
		      If sourceLineCount = 0 Then
		        // The first line should be ignored as it's the property declaration.
		        sourceLineCount = 1
		        Continue
		      End If
		      
		      If child.FirstChild <> Nil Then
		        lines.Add(child.FirstChild.Value)
		      Else
		        lines.Add("")
		      End If
		    End Select
		  Next i
		  
		  Return lines
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21, Description = 50617273657320616E20584D4C202253747275637475726522206E6F646520696E746F20612060584B537472756374757265602E
		Private Function ParseStructure(node As XmlNode) As XKStructure
		  /// Parses an XML "Structure" node into a `XKStructure`.
		  ///
		  /// Assumes that `node` has already been validated to be a "Structure" node.
		  
		  Var s As New XKStructure
		  
		  Var iLimit As Integer = node.ChildCount - 1
		  For i As Integer = 0 To iLimit
		    Var child As XmlNode = node.Child(i)
		    Select Case child.Name
		    Case "Attributes"
		      s.Attributes_ = ParseAttributesNode(child)
		      
		    Case "CodeDescription"
		      s.Description = If(child.FirstChild <> Nil, child.FirstChild.Value, "")
		      
		    Case "ItemFlags"
		      s.Scope = ScopeFromXMLInteger(Integer.FromString(child.FirstChild.Value))
		      
		    Case "ItemName"
		      s.Name = child.FirstChild.Value
		      
		    Case "ItemSource"
		      s.Fields = ParseStructureFields(child)
		      
		    End Select
		  Next i
		  
		  // The signature is just the name.
		  s.Signature = s.Name
		  
		  // Exclude this member?
		  s.IsExcluded = XKProject.ShouldExcludeMember(s, mOptions)
		  
		  Return s
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21, Description = 50617273657320616E20584D4C20737472756374757265277320224974656D536F7572636522206E6F646520696E746F20616E206172726179206F6620584B5374727563747572654669656C647320726570726573656E74696E672069742773206669656C64732E
		Private Function ParseStructureFields(node As XmlNode) As XKStructureField()
		  /// Parses an XML structure's "ItemSource" node into an array of XKStructureFields representing it's fields.
		  ///
		  /// Assumes that `node` has already been validated to be an "ItemSource" node within a "Structure" node.
		  ///
		  /// ```
		  ///   <ItemSource>
		  ///    <TextEncoding>134217984</TextEncoding>
		  ///    <SourceLine>Age As Integer</SourceLine>
		  ///    <SourceLine>Data(100) As Byte</SourceLine>
		  ///    <SourceLine>Name As String * 50</SourceLine>
		  ///   </ItemSource>
		  /// ```
		  
		  Var fields() As XKStructureField
		  
		  Var iLimit As Integer = node.ChildCount - 1
		  Var fieldIndex As Integer = -1
		  For i As Integer = 0 To iLimit
		    Var child As XmlNode = node.Child(i)
		    Select Case child.Name
		    Case "SourceLine"
		      fieldIndex = fieldIndex + 1
		      If child.FirstChild = Nil Then
		        // This is a field with an empty declaration in the IDE. We will still add it as an
		        // empty field although I suspect this is a broken implementation in the IDE.
		        fields.Add(New XKStructureField(fieldIndex, "", ""))
		      Else
		        Var nameType() As String = child.FirstChild.Value.Split(" As ")
		        fields.Add(New XKStructureField(fieldIndex, nameType(0), nameType(1)))
		      End If
		    End Select
		  Next i
		  
		  Return fields
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21, Description = 52657475726E73207468652073636F7065206F6620616E206974656D2066726F6D2074686520696E74656765722076616C75652073746F72656420696E20616E20584D4C2073657269616C69736174696F6E2E
		Private Function ScopeFromXMLInteger(xmlValue As Integer) As XojoKit.Scopes
		  /// Returns the scope of an item from the integer value stored in an XML serialisation.
		  
		  Select Case xmlValue
		  Case 0
		    Return XojoKit.Scopes.Public_
		    
		  Case 1
		    Return XojoKit.Scopes.Protected_
		    
		  Case 33
		    Return XojoKit.Scopes.Private_
		    
		  Else
		    // This is lazy but for now we'll just assume this is a public item.
		    Return XojoKit.Scopes.Public_
		  End Select
		  
		End Function
	#tag EndMethod


	#tag Property, Flags = &h21, Description = 546865206F7074696F6E7320746F20757365207768656E2070617273696E67206974656D7320616E64206D656D626572732E
		Private mOptions As XojoKit.XKOptions
	#tag EndProperty


	#tag Constant, Name = REGEX_EVENT_FUNCTION_SIG, Type = String, Dynamic = False, Default = \"(\?<type>Function)\\s(\?<name>[a-z0-9_]+)\\((\?P<params>.+)\?\\)(\?:\\sAs\\s)(\?P<return>.+)", Scope = Private, Description = 546865207265676578207061747465726E20666F72206D61746368696E6720616E206576656E742068616E646C657227732066756E6374696F6E207369676E61747572652077697468696E20616E20224974656D536F75726365203E20536F757263654C696E652220584D4C206E6F64652E
	#tag EndConstant

	#tag Constant, Name = REGEX_EVENT_SUB_SIG, Type = String, Dynamic = False, Default = \"(\?<type>Sub)\\s(\?<name>[a-z0-9_]+)\\((\?P<params>.+)\?\\)", Scope = Private, Description = 546865207265676578207061747465726E20666F72206D61746368696E6720616E206576656E742068616E646C6572277320737562207369676E61747572652077697468696E20616E20224974656D536F75726365203E20536F757263654C696E652220584D4C206E6F64652E
	#tag EndConstant

	#tag Constant, Name = REGEX_PARAM, Type = String, Dynamic = False, Default = \"(\?P<isParamArray>ParamArray)\?(\?P<isAssigns>Assigns)\?\\s\?(\?P<name>[a-z0-9_\\.]+(\?:\\(.*\\))\?)\\sAs\\s(\?P<type>[a-z0-9_\\.]+)(\?:\\s\x3D\\s)\?(\?P<default>[a-z0-9._\"\\-\\s]+)\?", Scope = Private, Description = 54686520726567657820746F206D6174636820612073696E676C6520706172616D657465722077697468696E2061207369676E61747572652E
	#tag EndConstant


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

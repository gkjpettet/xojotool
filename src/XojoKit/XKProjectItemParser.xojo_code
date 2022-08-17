#tag Class
Protected Class XKProjectItemParser
Implements XKItemParser
	#tag Method, Flags = &h21, Description = 436F6D707574657320616E642072657475726E7320746865207061737365642064656C6567617465277320757365722D666163696E67207369676E617475726520286C657373206465636F726174696F6E73206C696B6520617474726962757465732C20657463292E
		Private Function ComputeDelegateSignature(d As XKDelegate) As String
		  /// Computes and returns the passed delegate's user-facing signature (less decorations like attributes, etc).
		  
		  Var sig as String = d.Name + "("
		  
		  For i As Integer = 0 To d.Parameters.LastIndex
		    Var p As XKParameter = d.Parameters(i)
		    sig = sig + p.ToString + If(i < d.Parameters.LastIndex, ", ", "")
		  Next i
		  sig = sig + ")"
		  If d.ReturnType <> "" Then
		    sig = sig + " As " + d.ReturnType
		  End If
		  
		  Return sig
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21, Description = 436F6D707574657320616E642061737369676E7320746865207061737365642064656C6567617465277320757365722D666163696E67207369676E617475726520286C657373206465636F726174696F6E73206C696B6520617474726962757465732C206574632920616E64206974732060706172616D65746572537472696E67602E
		Private Sub ComputeDelegateSignatureAndParameterString(ByRef d As XKDelegate)
		  /// Computes and assigns the passed delegate's user-facing signature (less decorations like attributes, etc) and
		  /// its `parameterString`.
		  
		  d.Signature = d.Name + "("
		  
		  For i As Integer = 0 To d.Parameters.LastIndex
		    Var p As XKParameter = d.Parameters(i)
		    d.ParameterString = d.ParameterString + p.ToString + If(i < d.Parameters.LastIndex, ", ", "")
		  Next i
		  
		  d.Signature = d.Signature + d.ParameterString + ")"
		  
		  If d.ReturnType <> "" Then
		    d.Signature = d.Signature + " As " + d.ReturnType
		  End If
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21, Description = 436F6D707574657320616E642061737369676E732074686520706173736564206576656E7420646566696E6974696F6E277320757365722D666163696E67207369676E617475726520286C657373206465636F726174696F6E73206C696B6520617474726962757465732C206574632920616E64206974732060706172616D65746572537472696E67602E
		Private Sub ComputeEventDefinitionSignatureAndParameterString(ByRef e As XKEventDefinition)
		  /// Computes and assigns the passed event definition's user-facing signature (less decorations like attributes, etc) and
		  /// its `parameterString`.
		  
		  e.Signature = e.Name + "("
		  
		  For i As Integer = 0 To e.Parameters.LastIndex
		    Var p As XKParameter = e.Parameters(i)
		    e.ParameterString = e.ParameterString + p.ToString + If(i < e.Parameters.LastIndex, ", ", "")
		  Next i
		  
		  e.Signature = e.Signature + e.ParameterString + ")"
		  
		  If e.ReturnType <> "" Then
		    e.Signature = e.Signature + " As " + e.ReturnType
		  End If
		  
		End Sub
	#tag EndMethod

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

	#tag Method, Flags = &h21, Description = 436F6D707574657320616E642061737369676E732074686520706173736564206D6574686F64277320757365722D666163696E67207369676E617475726520286C657373206465636F726174696F6E73206C696B6520617474726962757465732C206574632920616E64206974732060706172616D65746572537472696E67602E
		Private Sub ComputeMethodSignatureAndParameterString(ByRef m As XKMethod)
		  /// Computes and assigns the passed method's user-facing signature (less decorations like attributes, etc) and
		  /// its `parameterString`.
		  
		  m.Signature = m.Name + "("
		  
		  For i As Integer = 0 To m.Parameters.LastIndex
		    Var p As XKParameter = m.Parameters(i)
		    m.ParameterString = m.ParameterString + p.ToString + If(i < m.Parameters.LastIndex, ", ", "")
		  Next i
		  
		  m.Signature = m.Signature + m.ParameterString + ")"
		  
		  If m.ReturnType <> "" Then
		    m.Signature = m.Signature + " As " + m.ReturnType
		  End If
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 5061727365732074686520636F6E74656E7473206F6620612066696C6520696E746F2069747320636F6E7374697475656E74206D6574686F64732C2070726F706572746965732C206576656E747320616E64206E6F7465732E
		Sub Parse(ByRef item As XojoKit.XKItem, options As XojoKit.XKOptions)
		  /// Parses the contents of an item into its constituent methods, properties, events and notes.
		  ///
		  /// Part of the XKItemParser interface.
		  
		  // Keep a reference to the parsing options.
		  mOptions = options
		  
		  // Default to this item being a class.
		  item.Type = XojoKit.ItemTypes.Class_
		  
		  Var tin As TextInputStream
		  Var contents As String
		  
		  Try
		    tin = TextInputStream.Open(item.File)
		    contents = tin.ReadAll
		    
		  Catch e
		    Raise New XKException("Unable to open file for reading `" + item.Path + "`.")
		    
		  Finally
		    tin.Close
		  End Try
		  
		  contents = contents.ReplaceLineEndings(EndOfLine.UNIX)
		  Var lines() As String = contents.Split(EndOfLine.UNIX)
		  
		  Var line As String
		  For i As Integer = 0 To lines.LastIndex
		    
		    // Skip empty lines and lines that don't start with `#tag`.
		    line = lines(i).Trim
		    If line.IsEmpty Then Continue
		    If Not line.BeginsWith("#tag") Then Continue
		    
		    // Parse the tag.
		    Var tag As New XKProjectItemTag(line)
		    
		    Select Case tag.TagType
		    Case "Class"
		      ParseClassTag(item, lines, i)
		      
		    Case "Module"
		      ParseModuleTag(item, lines, i)
		      
		    Case "WindowCode"
		      ParseWindowCodeTag(item, lines, i)
		      
		    Case "Interface"
		      ParseInterfaceTag(item, lines, i)
		      
		    Case "Property"
		      item.Properties.Add(ParseProperty(tag, lines, i))
		      
		    Case "ComputedProperty"
		      item.Properties.Add(ParseComputedProperty(tag, lines, i))
		      
		    Case "Method"
		      item.Methods.Add(ParseMethod(tag, lines, i))
		      // Ensure that interfaces methods are empty.
		      If item.Type = XojoKit.ItemTypes.Interface_ Then
		        item.Methods(item.Methods.LastIndex).Lines.RemoveAll
		      End If
		      
		    Case "DelegateDeclaration"
		      item.Delegates.Add(ParseDelegate(tag, lines, i))
		      
		    Case "Event"
		      // This is an event that has been implemented by a class (NOT an event definition).
		      item.Events.Add(ParseEvent(tag, lines, i))
		      
		    Case "Hook"
		      // This is an event definition.
		      item.EventDefinitions.Add(ParseEventDefinition(tag, lines, i))
		      
		    Case "Enum"
		      item.Enums.Add(ParseEnum(tag, lines, i))
		      
		    Case "Note"
		      item.Notes.Add(ParseNote(tag, lines, i))
		      
		    Case "Constant"
		      item.Constants.Add(ParseConstant(tag, lines, i))
		      
		    Case "Structure"
		      item.Structures.Add(ParseStructure(tag, lines, i))
		    End Select
		  Next i
		  
		  // HACK: Xojo stores Windows and Containers in `.xojo_window` files. The only way I can see to tell
		  // them apart is that Windows have an `ImplicitInstance` property and Containers do not.
		  // If we can find this in the xojo_window file then we will assume it is a Window.
		  // Of course, if someone adds this property to their Container then the parser will wrongly assume this is 
		  // a Window.
		  If item.Type = XojoKit.ItemTypes.Window_ Then
		    item.Type = XojoKit.ItemTypes.Container // Default to a container.
		    For Each l As String In lines
		      If l.Trim.BeginsWith("ImplicitInstance") Then
		        item.Type = XojoKit.ItemTypes.Window_
		        Exit
		      End If
		    Next l
		  End If
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21, Description = 506172736573206120436C617373207461672E204D757461746573206069602E204D617920726169736520612060586F646F63457863657074696F6E602E
		Private Sub ParseClassTag(ByRef item As XKItem, lines() As String, ByRef i As Integer)
		  /// Parses a Class tag. Mutates `i`. May raise a `XKException`.
		  ///
		  /// Assumes `lines` is the contents of `file`.
		  /// Assumes `i` is the index in `lines` of a "#tag Class" line.
		  /// Sets the required properties on `item` for this class.
		  ///
		  /// #tag Class format:
		  /// ```
		  /// #tag Class
		  /// (Attributes LPAREN AttributeKeyValue (COMMA AttributeKeyValue)* RPAREN)? Scope CLASS CLASS_NAME
		  /// (INHERITS SUPERCLASS)?
		  /// (IMPLEMENTS FQN (COMMA FQN)*)?
		  /// ...
		  /// #tag EndClass
		  /// 
		  /// ```
		  ///
		  /// AttributeKeyValue → ATTRIBUTE (EQUAL VALUE)?
		  /// Scope             → PROTECTED | PRIVATE
		  
		  // The item must be a class.
		  item.Type = XojoKit.ItemTypes.Class_
		  
		  // Sanity check.
		  If i >= lines.LastIndex Then
		    Raise New XKException("Expected a scope / attributes line after the Class tag. " + _
		    "Instead the parser ran out of lines.")
		  End If
		  
		  // ===============
		  // SCOPE LINE
		  // ===============
		  // The next line must be the scope +/- attributes line.
		  Var scopeLine As String = lines(i + 1).Trim
		  i = i + 1
		  Var hasAttributes As Boolean = False
		  If scopeLine.BeginsWith("Attributes") Then
		    hasAttributes = True
		  End If
		  
		  // ===============
		  // INHERITS LINE
		  // ===============
		  // Get the optional "inherits" line.
		  Var inheritsLine As String
		  If i < lines.LastIndex Then
		    inheritsLine = lines(i + 1).Trim
		    If inheritsLine.BeginsWith("Inherits") Then
		      i = i + 1
		    Else
		      inheritsLine = ""
		    End If
		  End If
		  
		  // ===============
		  // IMPLEMENTS LINE
		  // ===============
		  // Get the optional "implements" line.
		  Var implementsLine As String
		  If i < lines.LastIndex Then
		    implementsLine = lines(i + 1).Trim
		    If implementsLine.BeginsWith("Implements") Then
		      i = i + 1
		    Else
		      implementsLine = ""
		    End If
		  End If
		  
		  // Optional attributes?
		  If hasAttributes Then
		    Var attrString As String = scopeLine.Left(scopeLine.IndexOf(")") + 1)
		    scopeLine = scopeLine.Replace(attrString, "").Trim
		    attrString = attrString.Replace("Attributes (", "")
		    attrString = attrString.Replace(")", "")
		    attrString = attrString.Trim
		    Var attributeKeyValues() As String = attrString.Split(", ")
		    For Each keyValue As String In attributeKeyValues
		      Var kv() As String = keyValue.Split(" = ")
		      If kv.Count > 1 Then
		        item.Attributes_.Add(kv(0).Trim : kv(1).Trim)
		      Else
		        item.Attributes_.Add(kv(0).Trim : "")
		      End If
		    Next keyValue
		  End If
		  
		  // Scope.
		  If scopeLine.BeginsWith("Private") Then
		    item.Scope = XojoKit.Scopes.Private_
		  ElseIf scopeLine.BeginsWith("Protected") Then
		    item.Scope = XojoKit.Scopes.Protected_
		  Else
		    item.Scope = XojoKit.Scopes.Public_
		  End If
		  
		  // Optional superclass?
		  If Not inheritsLine.IsEmpty Then
		    item.Superclass = inheritsLine.Replace("Inherits", "").Trim
		  End If
		  
		  // Optional interfaces?
		  If Not implementsLine.IsEmpty Then
		    implementsLine = implementsLine.Replace("Implements", "").Trim
		    Var interfaces() As String = implementsLine.Split(",")
		    For Each inter As String In interfaces
		      item.ImplementedInterfaces.Add(inter.Trim)
		    Next inter
		  End If
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21, Description = 506172736573206120636F6D70757465642070726F70657274792066726F6D20606C696E657360207374617274696E6720617420606960207573696E672074686520646174612077697468696E2060746167602E
		Private Function ParseComputedProperty(tag As XKProjectItemTag, lines() As String, ByRef i As Integer) As XKProperty
		  /// Parses a computed property from `lines` starting at `i` using the data within `tag`. 
		  ///
		  /// Assumes `lines(i)` is the "#tag ComputedProperty" line which has been parsed into `tag`.
		  /// Format:
		  /// ```
		  /// #TAG COMPUTED_PROPERTY TagProperties
		  ///   Getter?
		  ///   Setter?
		  ///   (Shared)? (Scope)? NAME AS TYPE
		  /// #TAG END_COMPUTED_PROPERTY
		  ///
		  /// TagProperties → (FLAGS EQUAL HexLiteral)?, DESCRIPTION EQUAL Base64String
		  /// Scope         → PUBLIC | GLOBAL | PROTECTED | PRIVATE
		  /// Getter        → #TAG GETTER EOL GET EOL (CODE_LINE)* END GET #TAG END_GETTER
		  /// Setter        → #TAG SETTER EOL SET EOL (CODE_LINE)* END SET #TAG END_SETTER
		  /// ```
		  
		  // Sanity check.
		  If i >= lines.LastIndex Then
		    Raise New XKException("Expected a computed property declaration line but instead the " + _
		    "parser reached the end.")
		  End If
		  
		  Var cp As New XKProperty(XojoKit.MemberTypes.ComputedProperty_)
		  cp.IsComputed = True
		  cp.Description = tag.Description
		  
		  // Advance past the #tag "ComputedProperty" line.
		  i = i + 1
		  
		  // Optional note?
		  If lines(i).Trim.BeginsWith("#tag Note") Then
		    i = i + 1
		    While i <= lines.LastIndex
		      Var line As String = lines(i).Trim
		      If line = "#tag EndNote" Then
		        i = i + 1
		        Exit
		      End If
		      cp.NoteLines.Add(line)
		      i = i + 1
		    Wend
		  End If
		  
		  // Optional getter?
		  If lines(i).Trim.BeginsWith("#tag Getter") Then
		    cp.GetterLines = ParseGetter(lines, i)
		  End If
		  
		  // Optional setter?
		  If lines(i).Trim.BeginsWith("#tag Setter") Then
		    cp.SetterLines = ParseSetter(lines, i)
		  End If
		  
		  // Get the declaration and advance `i` past it.
		  Var decLine As String = lines(i).Trim
		  i = i + 1
		  
		  // Get the scope.
		  If decLine.IndexOf("Private ") <> - 1 Then
		    cp.Scope = XojoKit.Scopes.Private_
		    decLine = decLine.Replace("Private ", "").Trim
		  ElseIf decLine.IndexOf("Protected ") <> -1 Then
		    cp.Scope = XojoKit.Scopes.Protected_
		    decLine = decLine.Replace("Protected ", "").Trim
		  Else
		    cp.Scope = XojoKit.Scopes.Public_
		    decLine = decLine.Trim
		  End If
		  
		  // Shared?
		  If decLine.IndexOf("Shared ") <> -1 Then
		    cp.IsShared = True
		    decLine = decLine.Replace("Shared ", "").Trim
		  Else
		    cp.IsShared = False
		  End If
		  
		  // Get the constant name and type.
		  Var nameType() As String = decLine.Split(" As ")
		  cp.Name = nameType(0).Trim
		  cp.Type = nameType(1).Trim
		  
		  // The signature is just the name.
		  cp.Signature = cp.Name
		  
		  // Exclude this member?
		  cp.IsExcluded = XKProject.ShouldExcludeMember(cp, mOptions)
		  
		  Return cp
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21, Description = 506172736573206120586F6A6F20636F6E7374616E742066726F6D20606C696E657360207374617274696E6720617420606960207573696E672074686520646174612077697468696E206074616760
		Private Function ParseConstant(tag As XKProjectItemTag, lines() As String, ByRef i As Integer) As XKConstant
		  /// Parses a Xojo constant from `lines` starting at `i` using the data within `tag`
		  ///
		  /// Assumes `lines(i)` is the "#tag Constant" line which has been parsed into `tag`.
		  /// Format:
		  /// ```
		  /// #TAG CONSTANT TagProperties
		  ///   (#TAG INSTANCE InstanceProperties)*
		  /// #TAG ENDCONSTANT
		  ///
		  /// TagProperties      → NAME EQUAL IDENTIFIER, TYPE EQUAL Literal, DYNAMIC EQUAL Boolean, 
		  ///                      (FLAGS EQUAL HexLiteral)?, DESCRIPTION EQUAL Base64String, SCOPE EQUAL ScopeString, 
		  ///                      DEFAULT EQUAL \"Literal"
		  /// Scope              → PUBLIC | GLOBAL | PROTECTED | PRIVATE
		  /// InstanceProperties → PLATFORM = String, LANGUAGE EQUAL String, DEFINITION EQUAL \"Literal"
		  /// ```
		  
		  // Sanity check.
		  If i >= lines.LastIndex Then
		    Raise New XKException("Expected a constant declaration line but instead the parser reached the end.")
		  End If
		  
		  Var con As New XKConstant
		  con.Name = tag.Name
		  con.Attributes_ = tag.Attributes_
		  con.DefaultValue = tag.Default
		  con.IsDynamic = tag.IsDynamic
		  con.Scope = tag.Scope
		  con.Type = tag.Type
		  con.Description = tag.Description
		  
		  // Advance past the #Tag Constant line.
		  i = i + 1
		  
		  // Variants?
		  While i <= lines.LastIndex
		    Var line As String = lines(i).Trim
		    If line.BeginsWith("#tag EndConstant") Then
		      Exit
		    ElseIf line.BeginsWith("#Tag Instance") Then
		      con.Variants.Add(ParseConstantVariant(lines(i)))
		    End If
		    i = i + 1
		  Wend
		  
		  // The signature is just the name.
		  con.Signature = con.Name
		  
		  // Exclude this member?
		  con.IsExcluded = XKProject.ShouldExcludeMember(con, mOptions)
		  
		  Return con
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21, Description = 506172736573206120636F6E7374616E742076617269616E742066726F6D20606C696E65602E
		Private Function ParseConstantVariant(line As String) As XKConstantVariant
		  /// Parses a constant variant from `line`.
		  ///
		  /// Assumes `line` is a "#Tag Instance" line within a `#tag Constant...#tag EndConstant` construct.
		  /// Format:
		  /// ```
		  /// #Tag Instance, Platform = Mac OS, Language = Default, Definition  = \"&h0A"
		  /// ```
		  
		  line = line.Trim
		  
		  // Sanity check.
		  If Not line.BeginsWith("#Tag Instance") Then
		    Raise New XKException("Expected a `#Tag Instance` line. Instead got `" + line + "`.")
		  End If
		  
		  Var cv As New XKConstantVariant
		  
		  // Remove the `#Tag Instance` prefix.
		  line = line.Replace("#Tag Instance", "").Trim
		  
		  // Get the (non-empty) parts.
		  Var parts() As String = line.Split(",")
		  For i As Integer = parts.LastIndex DownTo 0
		    parts(i) = parts(i).Trim
		    If parts(i).IsEmpty Then parts.RemoveAt(i)
		  Next i
		  
		  For Each part As String In parts
		    Var keyValue() As String = part.Split(" = ")
		    Var key As String = keyValue(0).Trim
		    Var value As String = keyValue(1)
		    
		    Select Case key
		    Case "Platform"
		      cv.Platform = value
		      
		    Case "Language"
		      cv.Language = value
		      
		    Case "Definition"
		      // The value is a string prefixed with `\` and flanked with "".
		      If value.Left(2) = "\""" Then
		        value = value.Middle(2, value.Length - 3)
		      End If
		      cv.Value = value
		    End Select
		    
		  Next part
		  
		  Return cv
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21, Description = 506172736573206120586F6A6F2064656C65676174652066726F6D20606C696E657360207374617274696E6720617420606960207573696E672074686520646174612077697468696E2060746167602E
		Private Function ParseDelegate(tag As XKProjectItemTag, lines() As String, ByRef i As Integer) As XKDelegate
		  /// Parses a Xojo delegate from `lines` starting at `i` using the data within `tag`.
		  ///
		  /// Assumes `lines(i)` is the "#tag DelegateDeclaration" line which has been parsed into `tag`.
		  /// Format:
		  /// ```
		  /// Attributes? Scope? (FUNCTION | SUB) NAME LPAREN (Param (COMMA Param)*)? RPAREN (AS TYPE)?
		  /// Attributes → ATTRIBUTES( KeyValue (COMMA KeyValue)* )
		  /// Scope → PUBLIC | GLOBAL | PROTECTED | PRIVATE
		  /// Param → PARAM_ARRAY? NAME(LPAREN RPAREN)? AS TYPE (EQUAL VALUE)?
		  /// ```
		  
		  // Sanity check.
		  If i >= lines.LastIndex Then
		    Raise New XKException("Expected a delegate signature line but instead the parser reached the end.")
		  End If
		  
		  // Advance to the signature line.
		  i = i + 1
		  Var sigLine As String = lines(i)
		  
		  // Search the signature line.
		  Var rx As New XKRegex(REGEX_FUNCTION_SIG)
		  If Not rx.Match(sigLine) Then
		    rx = New XKRegex(REGEX_SUB_SIG)
		    If Not rx.Match(sigLine) Then
		      Raise New XKException("Expected a delegate signature line.")
		    End If
		  End If
		  
		  // Advance past the signature line index.
		  i = i + 1
		  
		  Var d As New XKDelegate
		  d.Name = rx.NamedGroups.Lookup("name", "")
		  d.ReturnType = rx.NamedGroups.Lookup("return", "")
		  d.Scope = XojoKit.ScopeFromString(rx.NamedGroups.Lookup("scope", ""))
		  
		  If rx.NamedGroups.Lookup("Attributes", "") <> "" Then
		    // Remove "Attributes (" and the trailing ")".
		    Var attValue As String = rx.NamedGroups.Value("Attributes")
		    attValue = attValue.Replace("Attributes( ", "").Replace(")", "").Trim
		    Var attPairs() As String = attValue.Split(", ")
		    For Each attPair As String In attPairs
		      Var nameValue() As String = attPair.Split(" = ")
		      If nameValue.Count = 1 Then
		        d.Attributes_.Add(nameValue(0) : "")
		      Else
		        d.Attributes_.Add(nameValue(0) : nameValue(1))
		      End If
		    Next attPair
		  End If
		  
		  If rx.NamedGroups.Lookup("params", "") <> "" Then
		    Var params() As String = rx.NamedGroups.Value("params").StringValue.Split(", ")
		    Var paramRx As New XKRegex(REGEX_PARAM)
		    For Each param As String In params
		      If Not paramRx.Match(param) Then
		        Raise New XKException("Invalid parameter within a delegate signature.")
		      Else
		        Var p As New XKParameter
		        p.DefaultValue = paramRx.NamedGroups.Lookup("default", "")
		        p.IsParamArray = If(paramRx.NamedGroups.Lookup("isParamArray", "") = "", False, True)
		        p.Name = paramRx.NamedGroups.Lookup("name", "")
		        p.IsArray = If(p.Name.IndexOf("(") = -1, False, True)
		        p.Type = paramRx.NamedGroups.Lookup("type", "")
		        d.Parameters.Add(p)
		      End If
		    Next param
		  End If
		  
		  d.Description = tag.Description
		  
		  // Compute the delegate's signature and parameter string.
		  ComputeDelegateSignatureAndParameterString(d)
		  
		  // Exclude this member?
		  d.IsExcluded = XKProject.ShouldExcludeMember(d, mOptions)
		  
		  Return d
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21, Description = 506172736573206120586F6A6F20656E756D65726174696F6E2066726F6D20606C696E657360207374617274696E6720617420606960207573696E672074686520646174612077697468696E2060746167602E
		Private Function ParseEnum(tag As XKProjectItemTag, lines() As String, ByRef i As Integer) As XKEnum
		  /// Parses a Xojo enumeration from `lines` starting at `i` using the data within `tag`.
		  ///
		  /// Assumes `lines(i)` is the "#tag Enum" line which has been parsed into `tag`.
		  /// Format:
		  /// ```
		  /// #TAG ENUM TagProperties
		  /// (Member)+
		  /// #TAG ENDENUM
		  ///
		  /// TagProperties → NAME EQUAL IDENTIFIER, TYPE EQUAL Literal,
		  ///                 (FLAGS EQUAL HexLiteral)?, DESCRIPTION EQUAL Base64String, (BINARY = Boolean)?
		  /// Member        → NAME (EQUAL VALUE)?
		  /// ```
		  /// 
		  /// The scope of an enum is defined by it's `Flags` value.
		  
		  // Sanity check.
		  If i >= lines.LastIndex Then
		    Raise New XKException("Expected an enumeration declaration line but instead the parser reached the end.")
		  End If
		  
		  Var e As New XKEnum
		  e.Attributes_ = tag.Attributes_
		  e.Name = tag.Name
		  e.IsBinary = tag.IsBinary
		  e.Description = tag.Description
		  
		  // Advance past the #Tag Enum line.
		  i = i + 1
		  
		  // Determine scope.
		  If tag.Flags = "" Or Not tag.Flags.BeginsWith("&h") Then
		    e.Scope = XojoKit.Scopes.Public_
		  Else
		    Var flagValue As Integer = Integer.FromHex(tag.Flags.TrimLeft("&h"))
		    Select Case flagValue
		    Case 0
		      e.Scope = XojoKit.Scopes.Public_
		    Case 1
		      e.Scope = XojoKit.Scopes.Protected_
		    Case &h21
		      e.Scope = XojoKit.Scopes.Private_
		    Else
		      Raise New XKException("Unknown enumeration flag value.")
		    End Select
		  End If
		  
		  // Get the members.
		  While i <= lines.LastIndex
		    Var line As String = lines(i).Trim
		    If line.BeginsWith("#tag EndEnum") Then
		      Exit
		    Else
		      If line.IndexOf("=") = -1 Then
		        e.Members.Add(line : Nil)
		      Else
		        Var nameValue() As String = line.Split("=")
		        e.Members.Add(nameValue(0).Trim : nameValue(1).Trim)
		      End If
		    End If
		    i = i + 1
		  Wend
		  
		  // The signature is just the name.
		  e.Signature = e.Name
		  
		  // Exclude this member?
		  e.IsExcluded = XKProject.ShouldExcludeMember(e, mOptions)
		  
		  Return e
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21, Description = 506172736573206120586F6A6F206576656E742068616E646C65722066726F6D20606C696E657360207374617274696E6720617420606960207573696E672074686520646174612077697468696E2060746167602E
		Private Function ParseEvent(tag As XKProjectItemTag, lines() As String, ByRef i As Integer) As XKEvent
		  /// Parses a Xojo event handler from `lines` starting at `i` using the data within `tag`.
		  ///
		  /// Assumes `lines(i)` is the "#tag Event" line which has been parsed into `tag`.
		  /// Format:
		  /// ```
		  /// (FUNCTION | SUB) NAME LPAREN (Param (COMMA Param)*)? RPAREN (AS TYPE)?
		  /// Param → PARAM_ARRAY? NAME(LPAREN RPAREN)? AS TYPE (EQUAL VALUE)?
		  /// ```
		  
		  // Sanity check.
		  If i >= lines.LastIndex Then
		    Raise New XKException("Expected an event handler signature line but instead the parser reached the end.")
		  End If
		  
		  // Advance to the signature line.
		  i = i + 1
		  Var sigLine As String = lines(i)
		  
		  // Search the signature line.
		  Var rx As New XKRegex(REGEX_EVENT_FUNCTION_SIG)
		  If Not rx.Match(sigLine) Then
		    rx = New XKRegex(REGEX_EVENT_SUB_SIG)
		    If Not rx.Match(sigLine) Then
		      Raise New XKException("Expected an event handler signature line.")
		    End If
		  End If
		  
		  // Advance past the signature line index.
		  i = i + 1
		  
		  Var e As New XKEvent
		  e.Name = rx.NamedGroups.Lookup("name", "")
		  e.ReturnType = rx.NamedGroups.Lookup("return", "")
		  
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
		  
		  e.Description = tag.Description
		  
		  While i <= lines.LastIndex
		    Var line As String = lines(i).Trim(&u09)
		    If line.BeginsWith("End Sub") Or line.BeginsWith("End Function") Or line.BeginsWith("#tag") Then Exit
		    e.Lines.Add(line)
		    i = i + 1
		  Wend
		  
		  // Compute the event's signature.
		  e.Signature = ComputeEventSignature(e)
		  
		  // Exclude this member?
		  e.IsExcluded = XKProject.ShouldExcludeMember(e, mOptions)
		  
		  Return e
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21, Description = 50617273657320616E206576656E7420646566696E6974696F6E2066726F6D20606C696E657360207374617274696E6720617420606960207573696E672074686520646174612077697468696E206074616760
		Private Function ParseEventDefinition(tag As XKProjectItemTag, lines() As String, ByRef i As Integer) As XKEventDefinition
		  /// Parses an event definition from `lines` starting at `i` using the data within `tag`
		  ///
		  /// Assumes `lines(i)` is the "#tag Hook" line which has been parsed into `tag`.
		  /// Format:
		  /// ```
		  /// Attributes? EVENT NAME LPAREN (Param (COMMA Param)*)? RPAREN (AS TYPE)?
		  /// Attributes → ATTRIBUTES( KeyValue (COMMA KeyValue)* )
		  /// Param → PARAM_ARRAY? NAME(LPAREN RPAREN)? AS TYPE (EQUAL VALUE)?
		  /// ```
		  
		  // Sanity check.
		  If i >= lines.LastIndex Then
		    Raise New XKException("Expected an event definition signature line but instead the parser reached the end.")
		  End If
		  
		  // Advance to the signature line.
		  i = i + 1
		  Var sigLine As String = lines(i).Trim
		  
		  // Is this a function (no return value) or sub (has a return value)?
		  Var sigPattern As String
		  If SignatureHasReturnValue(sigLine) Then
		    sigPattern = REGEX_EVENT_DEF_FUNCTION_SIG
		  Else
		    sigPattern = REGEX_EVENT_DEF_SUB_SIG
		  End If
		  
		  // Search the signature line.
		  Var rx As New XKRegex(sigPattern)
		  If Not rx.Match(sigLine) Then
		    Raise New XKException("Expected an event definition signature line.")
		  End If
		  
		  // Advance past the signature line index.
		  i = i + 1
		  
		  Var ed As New XKEventDefinition
		  ed.Name = rx.NamedGroups.Lookup("name", "")
		  ed.ReturnType = rx.NamedGroups.Lookup("return", "")
		  
		  If rx.NamedGroups.Lookup("Attributes", "") <> "" Then
		    // Remove "Attributes (" and the trailing ")".
		    Var attValue As String = rx.NamedGroups.Value("Attributes")
		    attValue = attValue.Replace("Attributes( ", "").Replace(")", "").Trim
		    Var attPairs() As String = attValue.Split(", ")
		    For Each attPair As String In attPairs
		      Var nameValue() As String = attPair.Split(" = ")
		      If nameValue.Count = 1 Then
		        ed.Attributes_.Add(nameValue(0) : "")
		      Else
		        ed.Attributes_.Add(nameValue(0) : nameValue(1))
		      End If
		    Next attPair
		  End If
		  
		  If rx.NamedGroups.Lookup("params", "") <> "" Then
		    Var params() As String = rx.NamedGroups.Value("params").StringValue.Split(", ")
		    Var paramRx As New XKRegex(REGEX_PARAM)
		    For Each param As String In params
		      If Not paramRx.Match(param) Then
		        Raise New XKException("Invalid parameter within an event definition's signature.")
		      Else
		        Var p As New XKParameter
		        p.DefaultValue = paramRx.NamedGroups.Lookup("default", "")
		        p.IsParamArray = If(paramRx.NamedGroups.Lookup("isParamArray", "") = "", False, True)
		        p.Name = paramRx.NamedGroups.Lookup("name", "")
		        p.IsArray = If(p.Name.IndexOf("(") = -1, False, True)
		        p.Type = paramRx.NamedGroups.Lookup("type", "")
		        ed.Parameters.Add(p)
		      End If
		    Next param
		  End If
		  
		  ed.Description = tag.Description
		  
		  // Compute the event definition's signature and parameter string.
		  ComputeEventDefinitionSignatureAndParameterString(ed)
		  
		  // Exclude this member?
		  ed.IsExcluded = XKProject.ShouldExcludeMember(ed, mOptions)
		  
		  Return ed
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21, Description = 506172736573206120676574746572206F66206120636F6D70757465642070726F70657274792072657475726E696E6720697473206C696E6573206F6620636F646520287768696368206D617920626520656D707479292E20416476616E63657320606960206265796F6E642074686520602374616720456E6447657474657260206C696E652E
		Private Function ParseGetter(lines() As String, ByRef i As Integer) As String()
		  /// Parses a getter of a computed property returning its lines of code (which may be empty).
		  /// Advances `i` beyond the `#tag EndGetter` line.
		  ///
		  /// Assumes `lines(i) = #tag Getter`
		  /// Getter → #TAG GETTER EOL GET EOL (CODE_LINE)* END GET #TAG END_GETTER
		  
		  Var code() As String
		  
		  If i >= lines.LastIndex Then
		    Raise New XKException("Expected a `Get` line but instead the parser reached the end.")
		  End If
		  
		  // Advance past the "#tag Getter" line.
		  i = i + 1
		  
		  If lines(i).Trim <> "Get" Then
		    Raise New XKException("Expected a `Get` line but instead the parser reached the end.")
		  End If
		  If i >= lines.LastIndex Then
		    Raise New XKException("Expected the contents of a getter but instead the parser reached the end.")
		  End If
		  
		  // Advance past the "Get" line.
		  i = i + 1
		  
		  // Consume the contents of the getter.
		  While i <= lines.LastIndex
		    Var line As String = lines(i).Trim(&u09)
		    If line = "End Get" Then
		      i = i + 1
		      Exit
		    Else
		      code.Add(line)
		      i = i + 1
		    End If
		  Wend
		  
		  // Expect to see "#tag EndGetter"
		  If lines(i).Trim.BeginsWith("#tag EndGetter") Then
		    i = i + 1
		  Else
		    Raise New XKException("Expected to see a `#tag EndGetter` line but did not.")
		  End If
		  
		  Return code
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21, Description = 50617273657320616E2022496E7465726661636522207461672E204D757461746573206069602E204D617920726169736520612060586F646F63457863657074696F6E602E
		Private Sub ParseInterfaceTag(ByRef item As XojoKit.XKItem, lines() As String, ByRef i As Integer)
		  /// Parses an "Interface" tag. Mutates `i`. May raise a `XKException`.
		  ///
		  /// Assumes `lines` is the contents of `file`.
		  /// Assumes `i` is the index in `lines` of a "#tag Interface" line.
		  /// Sets the required properties on `item` for this interface.
		  ///
		  /// #tag Interface format:
		  /// ```
		  /// #tag Interface
		  /// (Attributes LPAREN AttributeKeyValue (COMMA AttributeKeyValue)* RPAREN)? Scope CLASS CLASS_NAME
		  /// (IMPLEMENTS FQN (COMMA FQN)*)?
		  /// ...
		  /// #tag EndInterface
		  /// ```
		  ///
		  /// AttributeKeyValue → ATTRIBUTE (EQUAL VALUE)?
		  /// Scope             → PROTECTED | PRIVATE
		  
		  // The file must be an interface.
		  item.Type = XojoKit.ItemTypes.Interface_
		  
		  // Sanity check.
		  If i >= lines.LastIndex Then
		    Raise New XKException("Expected a scope / attributes line after the Interface tag. " + _
		    "Instead the parser ran out of lines.")
		  End If
		  
		  // ===============
		  // SCOPE LINE
		  // ===============
		  // The next line must be the scope +/- attributes line.
		  Var scopeLine As String = lines(i + 1).Trim
		  i = i + 1
		  Var hasAttributes As Boolean = False
		  If scopeLine.BeginsWith("Attributes") Then
		    hasAttributes = True
		  End If
		  
		  // Get the optional "implements" line.
		  Var implementsLine As String
		  If i < lines.LastIndex Then
		    implementsLine = lines(i + 1).Trim
		    If implementsLine.BeginsWith("Implements") Then
		      i = i + 1
		    Else
		      implementsLine = ""
		    End If
		  End If
		  
		  // Optional attributes?
		  If hasAttributes Then
		    Var attrString As String = scopeLine.Left(scopeLine.IndexOf(")") + 1)
		    scopeLine = scopeLine.Replace(attrString, "").Trim
		    attrString = attrString.Replace("Attributes (", "")
		    attrString = attrString.Replace(")", "")
		    attrString = attrString.Trim
		    Var attributeKeyValues() As String = attrString.Split(", ")
		    For Each keyValue As String In attributeKeyValues
		      Var kv() As String = keyValue.Split(" = ")
		      If kv.Count > 1 Then
		        item.Attributes_.Add(kv(0).Trim : kv(1).Trim)
		      Else
		        item.Attributes_.Add(kv(0).Trim : "")
		      End If
		    Next keyValue
		  End If
		  
		  // Scope.
		  If scopeLine.BeginsWith("Private") Then
		    item.Scope = XojoKit.Scopes.Private_
		  ElseIf scopeLine.BeginsWith("Protected") Then
		    item.Scope = XojoKit.Scopes.Protected_
		  Else
		    item.Scope = XojoKit.Scopes.Public_
		  End If
		  
		  // Optional interfaces?
		  If Not implementsLine.IsEmpty Then
		    implementsLine = implementsLine.Replace("Implements", "").Trim
		    Var interfaces() As String = implementsLine.Split(",")
		    For Each inter As String In interfaces
		      item.ImplementedInterfaces.Add(inter.Trim)
		    Next inter
		  End If
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21, Description = 506172736573206120586F6A6F206D6574686F642066726F6D20606C696E657360207374617274696E6720617420606960207573696E672074686520646174612077697468696E2060746167602E
		Private Function ParseMethod(tag As XKProjectItemTag, lines() As String, ByRef i As Integer) As XKMethod
		  /// Parses a Xojo method from `lines` starting at `i` using the data within `tag`.
		  ///
		  /// Assumes `lines(i)` is the "#tag Method" line which has been parsed into `tag`.
		  /// Format:
		  /// ```
		  /// Attributes? Scope? (SHARED)? (FUNCTION | SUB) NAME LPAREN (Param (COMMA Param)*)? RPAREN (AS TYPE)?
		  /// Attributes → ATTRIBUTES( KeyValue (COMMA KeyValue)* )
		  /// Scope → PUBLIC | GLOBAL | PROTECTED | PRIVATE
		  /// Param → PARAM_ARRAY? NAME(LPAREN RPAREN)? AS TYPE (EQUAL VALUE)?
		  /// ```
		  
		  // Sanity check.
		  If i >= lines.LastIndex Then
		    Raise New XKException("Expected a method signature line but instead the parser reached the end.")
		  End If
		  
		  // Advance to the signature line.
		  i = i + 1
		  Var sigLine As String = lines(i)
		  
		  // Is this a function (no return value) or sub (has a return value)?
		  Var sigPattern As String
		  If SignatureHasReturnValue(sigLine) Then
		    sigPattern = REGEX_FUNCTION_SIG
		  Else
		    sigPattern = REGEX_SUB_SIG
		  End If
		  
		  // Search the signature line.
		  Var rx As New XKRegex(sigPattern)
		  If Not rx.Match(sigLine) Then
		    Raise New XKException("Expected a method signature line.")
		  End If
		  
		  
		  
		  ' // Search the signature line.
		  ' Var rx As New XKRegex(REGEX_FUNCTION_SIG)
		  ' If Not rx.Match(sigLine) Then
		  ' rx = New XKRegex(REGEX_SUB_SIG)
		  ' If Not rx.Match(sigLine) Then
		  ' Raise New XKException("Expected a method signature line.")
		  ' End If
		  ' End If
		  
		  // Advance past the signature line index.
		  i = i + 1
		  
		  Var m As New XKMethod
		  m.IsShared = If(rx.NamedGroups.Lookup("shared", "") = "Shared", True, False)
		  m.Name = rx.NamedGroups.Lookup("name", "")
		  m.ReturnType = rx.NamedGroups.Lookup("return", "")
		  m.Scope = XojoKit.ScopeFromString(rx.NamedGroups.Lookup("scope", ""))
		  
		  If rx.NamedGroups.Lookup("Attributes", "") <> "" Then
		    // Remove "Attributes (" and the trailing ")".
		    Var attValue As String = rx.NamedGroups.Value("Attributes")
		    attValue = attValue.Replace("Attributes( ", "").Replace(")", "").Trim
		    Var attPairs() As String = attValue.Split(", ")
		    For Each attPair As String In attPairs
		      Var nameValue() As String = attPair.Split(" = ")
		      If nameValue.Count = 1 Then
		        m.Attributes_.Add(nameValue(0) : "")
		      Else
		        m.Attributes_.Add(nameValue(0) : nameValue(1))
		      End If
		    Next attPair
		  End If
		  
		  If rx.NamedGroups.Lookup("params", "") <> "" Then
		    Var params() As String = rx.NamedGroups.Value("params").StringValue.Split(", ")
		    Var paramRx As New XKRegex(REGEX_PARAM)
		    For Each param As String In params
		      If Not paramRx.Match(param) Then
		        Raise New XKException("Invalid parameter within a method signature.")
		      Else
		        Var p As New XKParameter
		        p.DefaultValue = paramRx.NamedGroups.Lookup("default", "")
		        p.IsParamArray = If(paramRx.NamedGroups.Lookup("isParamArray", "") = "", False, True)
		        p.IsAssigns = If(paramRx.NamedGroups.Lookup("isAssigns", "") = "", False, True)
		        p.Name = paramRx.NamedGroups.Lookup("name", "")
		        p.IsArray = If(p.Name.IndexOf("(") = -1, False, True)
		        p.Type = paramRx.NamedGroups.Lookup("type", "")
		        m.Parameters.Add(p)
		      End If
		    Next param
		  End If
		  
		  m.Description = tag.Description
		  
		  While i <= lines.LastIndex
		    Var line As String = lines(i).TrimLeft(&u09)
		    If line.BeginsWith("End Sub") Or line.BeginsWith("End Function") Or line.BeginsWith("#tag") Then Exit
		    m.Lines.Add(line.Trim)
		    i = i + 1
		  Wend
		  
		  // Compute the method's signature and parameter string.
		  ComputeMethodSignatureAndParameterString(m)
		  
		  // Exclude this member?
		  m.IsExcluded = XKProject.ShouldExcludeMember(m, mOptions)
		  
		  Return m
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21, Description = 506172736573206120224D6F64756C6522207461672E204D757461746573206069602E204D617920726169736520612060586F646F63457863657074696F6E602E
		Private Sub ParseModuleTag(ByRef item As XojoKit.XKItem, lines() As String, ByRef i As Integer)
		  /// Parses a "Module" tag. Mutates `i`. May raise a `XKException`.
		  ///
		  /// Assumes `lines` is the contents of `file`.
		  /// Assumes `i` is the index in `lines` of a "#tag Module" line.
		  /// Sets the required properties on `item` for this module.
		  ///
		  /// #tag Module format:
		  /// ```
		  /// #tag Module
		  /// (Attributes LPAREN AttributeKeyValue (COMMA AttributeKeyValue)* RPAREN)? Scope MODULE MODULE_NAME
		  /// ...
		  /// #tag EndModule
		  /// 
		  /// ```
		  ///
		  /// Scope → PROTECTED | PRIVATE
		  
		  // The file must be a module.
		  item.Type = XojoKit.ItemTypes.Module_
		  
		  // Sanity check.
		  If i >= lines.LastIndex Then
		    Raise New XKException("Expected a scope / attributes line after the Module tag. " + _
		    "Instead the parser ran out of lines.")
		  End If
		  
		  // ===============
		  // SCOPE LINE
		  // ===============
		  // The next line must be the scope +/- attributes line.
		  Var scopeLine As String = lines(i + 1).Trim
		  i = i + 1
		  Var hasAttributes As Boolean = False
		  If scopeLine.BeginsWith("Attributes") Then
		    hasAttributes = True
		  End If
		  
		  // Optional attributes?
		  If hasAttributes Then
		    Var attrString As String = scopeLine.Left(scopeLine.IndexOf(")") + 1)
		    scopeLine = scopeLine.Replace(attrString, "").Trim
		    attrString = attrString.Replace("Attributes (", "")
		    attrString = attrString.Replace(")", "")
		    attrString = attrString.Trim
		    Var attributeKeyValues() As String = attrString.Split(", ")
		    For Each keyValue As String In attributeKeyValues
		      Var kv() As String = keyValue.Split(" = ")
		      If kv.Count > 1 Then
		        item.Attributes_.Add(kv(0).Trim : kv(1).Trim)
		      Else
		        item.Attributes_.Add(kv(0).Trim : "")
		      End If
		    Next keyValue
		  End If
		  
		  // Scope.
		  If scopeLine.BeginsWith("Private") Then
		    item.Scope = XojoKit.Scopes.Private_
		  ElseIf scopeLine.BeginsWith("Protected") Then
		    item.Scope = XojoKit.Scopes.Protected_
		  Else
		    item.Scope = XojoKit.Scopes.Global_
		  End If
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function ParseNote(tag As XKProjectItemTag, lines() As String, ByRef i As Integer) As XKNote
		  /// Parses a note from `lines` starting at `i` using the data within `tag`
		  ///
		  /// Assumes `lines(i)` is the "#tag Note" line which has been parsed into `tag`.
		  
		  // Sanity check.
		  If i >= lines.LastIndex Then
		    Raise New XKException("Expected a some content within the notebut instead the parser reached the end.")
		  End If
		  
		  Var note As New XKNote
		  note.Name = tag.Name
		  note.Description = tag.Description
		  
		  // Get the contents of the note.
		  i = i + 1
		  While i <= lines.LastIndex
		    Var line As String = lines(i).TrimLeft
		    If line.BeginsWith("#tag EndNote") Then Exit
		    note.Lines.Add(line)
		    i = i + 1
		  Wend
		  
		  // Tidy the note up by removing flanking whitespace.
		  Var s As String = String.FromArray(note.Lines, EndOfLine.UNIX)
		  s = s.Trim
		  note.Lines = s.Split(EndOfLine.UNIX)
		  
		  // The signature is just the name.
		  note.Signature = note.Name
		  
		  // Exclude this member?
		  note.IsExcluded = XKProject.ShouldExcludeMember(note, mOptions)
		  
		  Return note
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21, Description = 506172736573206120586F6A6F2070726F70657274792066726F6D20606C696E657360207374617274696E6720617420606960207573696E672074686520646174612077697468696E2060746167602E
		Private Function ParseProperty(tag As XKProjectItemTag, lines() As String, ByRef i As Integer) As XKProperty
		  /// Parses a Xojo property from `lines` starting at `i` using the data within `tag`.
		  ///
		  /// Assumes `lines(i)` is the "#tag Property" line which has been parsed into `tag`.
		  /// Format:
		  /// ```
		  /// Attributes? Scope? (SHARED)? NAME (LPAREN RPAREN)?
		  /// Attributes → ATTRIBUTES( KeyValue (COMMA KeyValue)* )
		  /// Scope → PUBLIC | GLOBAL | PROTECTED | PRIVATE
		  /// ```
		  
		  // Sanity check.
		  If i >= lines.LastIndex Then
		    Raise New XKException("Expected a property signature line but instead the parser reached the end.")
		  End If
		  
		  Var prop As New XKProperty(XojoKit.MemberTypes.Property_)
		  
		  // Advance to first line after the #tag Property. It's likely the signature but could be a note tag.
		  i = i + 1
		  Var firstLine As String = lines(i)
		  
		  // Optional note?
		  If firstLine.Trim.BeginsWith("#tag Note") Then
		    i = i + 1
		    While i <= lines.LastIndex
		      Var line As String = lines(i).Trim
		      If line = "#tag EndNote" Then
		        i = i + 1
		        Exit
		      End If
		      prop.NoteLines.Add(line)
		      i = i + 1
		    Wend
		  End If
		  
		  Var sigLine As String = lines(i)
		  // Search the signature line.
		  Var rx As New XKRegex(REGEX_PROP_SIG)
		  If Not rx.Match(sigLine) Then
		    Raise New XKException("Expected a property signature line.")
		  End If
		  
		  // Advance past the signature line index.
		  i = i + 1
		  
		  prop.IsShared = If(rx.NamedGroups.Lookup("shared", "") = "Shared", True, False)
		  prop.Name = rx.NamedGroups.Lookup("name", "")
		  prop.IsArray = If(prop.Name.IndexOf("(") = -1, False, True)
		  prop.Scope = XojoKit.ScopeFromString(rx.NamedGroups.Lookup("scope", ""))
		  prop.Type = rx.NamedGroups.Lookup("type", "")
		  prop.DefaultValue = rx.NamedGroups.Lookup("default", "")
		  
		  If rx.NamedGroups.Lookup("Attributes", "") <> "" Then
		    // Remove "Attributes (" and the trailing ")".
		    Var attValue As String = rx.NamedGroups.Value("Attributes")
		    attValue = attValue.Replace("Attributes( ", "").Replace(")", "").Trim
		    Var attPairs() As String = attValue.Split(", ")
		    For Each attPair As String In attPairs
		      Var nameValue() As String = attPair.Split(" = ")
		      If nameValue.Count = 1 Then
		        prop.Attributes_.Add(nameValue(0) : "")
		      Else
		        prop.Attributes_.Add(nameValue(0) : nameValue(1))
		      End If
		    Next attPair
		  End If
		  
		  prop.Description = tag.Description
		  
		  // The signature is just the name.
		  prop.Signature = prop.Name
		  
		  // Exclude this member?
		  prop.IsExcluded = XKProject.ShouldExcludeMember(prop, mOptions)
		  
		  Return prop
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21, Description = 506172736573206120736574746572206F66206120636F6D70757465642070726F70657274792072657475726E696E6720697473206C696E6573206F6620636F646520287768696368206D617920626520656D707479292E20416476616E63657320606960206265796F6E642074686520602374616720456E6453657474657260206C696E652E
		Private Function ParseSetter(lines() As String, ByRef i As Integer) As String()
		  /// Parses a setter of a computed property returning its lines of code (which may be empty).
		  /// Advances `i` beyond the `#tag EndSetter` line.
		  ///
		  /// Assumes `lines(i) = #tag Setter`
		  /// Getter → #TAG SETTER EOL SET EOL (CODE_LINE)* END SET #TAG END_SETTER
		  
		  Var code() As String
		  
		  If i >= lines.LastIndex Then
		    Raise New XKException("Expected a `Set` line but instead the parser reached the end.")
		  End If
		  
		  // Advance past the "#tag Setter" line.
		  i = i + 1
		  
		  If lines(i).Trim <> "Set" Then
		    Raise New XKException("Expected a `Set` line but instead the parser reached the end.")
		  End If
		  If i >= lines.LastIndex Then
		    Raise New XKException("Expected the contents of a setter but instead the parser reached the end.")
		  End If
		  
		  // Advance past the "Set" line.
		  i = i + 1
		  
		  // Consume the contents of the setter.
		  While i <= lines.LastIndex
		    Var line As String = lines(i).Trim(&u09)
		    If line = "End Set" Then
		      i = i + 1
		      Exit
		    Else
		      code.Add(line)
		      i = i + 1
		    End If
		  Wend
		  
		  // Expect to see "#tag EndSetter"
		  If lines(i).Trim.BeginsWith("#tag EndSetter") Then
		    i = i + 1
		  Else
		    Raise New XKException("Expected to see a `#tag EndSetter` line but did not.")
		  End If
		  
		  Return code
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21, Description = 506172736573206120586F6A6F207374727563747572652066726F6D20606C696E657360207374617274696E6720617420606960207573696E672074686520646174612077697468696E206074616760
		Private Function ParseStructure(tag As XKProjectItemTag, lines() As String, ByRef i As Integer) As XKStructure
		  /// Parses a Xojo structure from `lines` starting at `i` using the data within `tag`
		  ///
		  /// Assumes `lines(i)` is the "#tag Structure" line which has been parsed into `tag`.
		  /// Format:
		  /// ```
		  /// #TAG STRUCTURE TagProperties
		  ///   (Field)*
		  /// #TAG ENDSTRUCTURE
		  ///
		  /// TagProperties      → NAME EQUAL IDENTIFIER, TYPE EQUAL Literal, DYNAMIC EQUAL Boolean, 
		  ///                      (FLAGS EQUAL HexLiteral)?, DESCRIPTION EQUAL Base64String, SCOPE EQUAL ScopeString, 
		  ///                      DEFAULT EQUAL \"Literal"
		  /// Scope              → PUBLIC | GLOBAL | PROTECTED | PRIVATE
		  /// Field → NAME (LPAREN NUMBER RPAREN)? AS FieldType
		  /// FieldType → TYPE (STAR) NUMBER
		  /// ```
		  
		  // Sanity check.
		  If i >= lines.LastIndex Then
		    Raise New XKException("Expected a constant declaration line but instead the parser reached the end.")
		  End If
		  
		  Var s As New XKStructure
		  s.Attributes_ = tag.Attributes_
		  s.Description = tag.Description
		  s.Name = tag.Name
		  s.Scope = tag.Scope
		  
		  // Advance past the #Tag Structure line.
		  i = i + 1
		  
		  // Fields?
		  Var fieldIndex As Integer = -1
		  While i <= lines.LastIndex
		    Var line As String = lines(i).Trim
		    If line.BeginsWith("#tag EndStructure") Then
		      Exit
		    Else
		      fieldIndex = fieldIndex + 1
		      If line = "" Then
		        s.Fields.Add(New XKStructureField(fieldIndex, "", ""))
		      Else
		        Var nameValue() As String = line.Split(" As ")
		        s.Fields.Add(New XKStructureField(fieldIndex, nameValue(0).Trim, nameValue(1).Trim))
		      End If
		    End If
		    i = i + 1
		  Wend
		  
		  // There seems to be a bug in the IDE where an empty field can get appended to the end of the declaration.
		  If s.Fields.Count > 0 And s.Fields(s.Fields.LastIndex).Name = "" Then
		    Call s.Fields.Pop
		  End If
		  
		  // The signature is just the name.
		  s.Signature = s.Name
		  
		  // Exclude this member?
		  s.IsExcluded = XKProject.ShouldExcludeMember(s, mOptions)
		  
		  Return s
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21, Description = 50617273657320612057696E646F77436F6465207461672E204D757461746573206069602E204D617920726169736520612060584B457863657074696F6E602E
		Private Sub ParseWindowCodeTag(ByRef item As XKItem, lines() As String, ByRef i As Integer)
		  /// Parses a WindowCode tag. Mutates `i`. May raise a `XKException`.
		  ///
		  /// Assumes `lines` is the contents of `file`.
		  /// Assumes `i` is the index in `lines` of a "#tag WindowCode" line.
		  /// Sets the required properties on `item` for this window.
		  ///
		  /// #tag WindowCode format:
		  /// ```
		  /// #tag WindowCode
		  /// ...
		  /// #tag EndWindowCode
		  /// ```
		  
		  #Pragma Unused item
		  #Pragma Unused lines
		  #Pragma Unused i
		  
		  // The item must be a window.
		  item.Type = XojoKit.ItemTypes.Window_
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21, Description = 52657475726E73205472756520696620607369676E6174757265602068617320612072657475726E2076616C75652E
		Private Function SignatureHasReturnValue(signature As String) As Boolean
		  /// Returns True if `signature` has a return value.
		  
		  Var rx As New XojoKit.XKRegex(REGEX_SIGNATURE_HAS_RETURN_VALUE)
		  
		  Return rx.Match(signature)
		  
		End Function
	#tag EndMethod


	#tag Note, Name = About
		Parses the contents of a Xojo item serialised to a `.xojo_code` file.
		
	#tag EndNote


	#tag Property, Flags = &h21, Description = 546865206F7074696F6E7320746F20757365207768656E2070617273696E67206974656D7320616E64206D656D626572732E
		Private mOptions As XojoKit.XKOptions
	#tag EndProperty


	#tag Constant, Name = REGEX_EVENT_DEF_FUNCTION_SIG, Type = String, Dynamic = False, Default = \"(\?P<attributes>Attributes\\(.+\\))\?\\s\?(\?:Event)\\s(\?<name>[a-z0-9_]+)\\((\?P<params>.+)\?\\)(\?:\\s+As\\s+)(\?P<return>.+)", Scope = Private, Description = 546865207265676578207061747465726E20666F72206D61746368696E6720616E206576656E7420646566696E6974696F6E207369676E617475726520746861742072657475726E7320612076616C75652077697468696E206120602E786F6A6F5F636F6465602066696C652E
	#tag EndConstant

	#tag Constant, Name = REGEX_EVENT_DEF_SUB_SIG, Type = String, Dynamic = False, Default = \"(\?P<attributes>Attributes\\(.+\\))\?\\s\?(\?:Event)\\s(\?<name>[a-z0-9_]+)\\((\?P<params>.+)\?\\)", Scope = Private, Description = 546865207265676578207061747465726E20666F72206D61746368696E6720616E206576656E7420646566696E6974696F6E207369676E6174757265207468617420646F65736E27742072657475726E20612076616C75652077697468696E206120602E786F6A6F5F636F6465602066696C652E
	#tag EndConstant

	#tag Constant, Name = REGEX_EVENT_FUNCTION_SIG, Type = String, Dynamic = False, Default = \"(\?<type>Function)\\s(\?<name>[a-z0-9_]+)\\((\?P<params>.+)\?\\)(\?:\\s+As\\s+)(\?P<return>.+)", Scope = Private, Description = 546865207265676578207061747465726E20666F72206D61746368696E6720616E206576656E742068616E646C657227732066756E6374696F6E207369676E61747572652077697468696E206120602E786F6A6F5F636F6465602066696C652E
	#tag EndConstant

	#tag Constant, Name = REGEX_EVENT_SUB_SIG, Type = String, Dynamic = False, Default = \"(\?<type>Sub)\\s(\?<name>[a-z0-9_]+)\\((\?P<params>.+)\?\\)", Scope = Private, Description = 546865207265676578207061747465726E20666F72206D61746368696E6720616E206576656E742068616E646C6572207375622077697468696E206120602E786F6A6F5F636F6465602066696C652E
	#tag EndConstant

	#tag Constant, Name = REGEX_FUNCTION_SIG, Type = String, Dynamic = False, Default = \"(\?P<attributes>Attributes\\(.+\\))\?\\s\?(\?P<scope>Public|Global|Protected|Private)\?\\s\?(\?<shared>Shared)\?\\s\?(\?<type>Function)\\s(\?<name>[a-z0-9_]+)\\((\?P<params>.+)\?\\)(\?:\\s+As\\s+)(\?P<return>.+)", Scope = Private, Description = 546865207265676578207061747465726E20666F72206D61746368696E6720612066756E6374696F6E207369676E61747572652077697468696E206120602E786F6A6F5F636F6465602066696C652E
	#tag EndConstant

	#tag Constant, Name = REGEX_PARAM, Type = String, Dynamic = False, Default = \"(\?P<isParamArray>ParamArray)\?(\?P<isAssigns>Assigns)\?\\s\?(\?P<name>[a-z0-9_\\.]+(\?:\\(.*\\))\?)\\s+As\\s+(\?P<type>[a-z0-9_\\.]+)(\?:\\s\x3D\\s)\?(\?P<default>[a-z0-9._\"\\-\\s]+)\?", Scope = Private, Description = 54686520726567657820746F206D6174636820612073696E676C6520706172616D657465722077697468696E2061207369676E61747572652E
	#tag EndConstant

	#tag Constant, Name = REGEX_PROP_SIG, Type = String, Dynamic = False, Default = \"(\?P<attributes>Attributes\\(.+\\))\?\\s\?(\?P<scope>Public|Global|Protected|Private)\?\\s\?(\?<shared>Shared)\?\\s\?(\?<name>[a-z0-9_]+(\?:\\(.*\\))\?)(\?:\\sAs\\s)(\?P<type>[a-z0-9_\\.]+\\(\?\x2C\?\\)\?)\?\\s\?\x3D\?\\s\?(\?P<default>[a-z0-9_\\.\"\\-\\s\\&\\+]+)\?$", Scope = Private, Description = 54686520726567657820666F7220612070726F7065727479207369676E6174757265206C696E652E
	#tag EndConstant

	#tag Constant, Name = REGEX_SIGNATURE_HAS_RETURN_VALUE, Type = String, Dynamic = False, Default = \".+\\) As [a-zA-Z0-9._]+(\?:\\(\\))\?$", Scope = Private
	#tag EndConstant

	#tag Constant, Name = REGEX_SUB_SIG, Type = String, Dynamic = False, Default = \"(\?P<attributes>Attributes\\(.+\\))\?\\s\?(\?P<scope>Public|Global|Protected|Private)\?\\s\?(\?<shared>Shared)\?\\s\?(\?<type>Sub)\\s(\?<name>[a-z0-9_]+)\\((\?P<params>.+)\?\\)", Scope = Private, Description = 546865207265676578207061747465726E20666F72206D61746368696E67206120737562207369676E61747572652077697468696E206120602E786F6A6F5F636F6465602066696C652E
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

#tag Class
Protected Class Option
	#tag Method, Flags = &h0
		Sub AddAllowedValue(ParamArray values() As String)
		  If AllowedValues.LastIndex <> -1 Then
		    Raise new OptionException("You cannot set both allowed values and disallowed values")
		  End If
		  
		  For Each v As String In values
		    AllowedValues.Add(v.Trim)
		  Next v
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub AddDisallowedValue(ParamArray values() As String)
		  If AllowedValues.LastIndex <> -1 Then
		    Raise New OptionException("You cannot set both disallowed values and allowed values")
		  End If
		  
		  For Each v As String In values
		    DisallowedValues.Add(v.Trim)
		  Next v
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor(shortKey As String, longKey As String, description As String, type As OptionTypes = OptionTypes.String, isRequired As Boolean = False)
		  //
		  // Construct a new `Option` for use with `CKOptionParser`. Provides most
		  // common attributes about an option as parameters. 
		  //
		  // ### Parameters
		  // * `shortKey` - Option's short key, can be blank
		  // * `longKey` - Option's long key, can be blank
		  // * `description` - Description of option used when display the help message
		  // * `type` - Type of this option, see `OptionType` enum
		  //
		  // ### Notes
		  //
		  // While both `shortKey` and `longKey` are optional, one must be supplied. Further,
		  // `longKey` must be more than 1 character in length.
		  //
		  // ### Example
		  //
		  // ```
		  // Var opt As New CKOptionParser
		  //
		  // Var o As CKOption
		  // o = New CKOption("", "name", "Name to say hello to")
		  // o.IsRequired = True
		  // opt.AddOption o
		  //
		  // opt.AddOption New CKOption("", "count", "Number of times to say hello", Option.OptionTypes.Integer)
		  // ```
		  //
		  
		  // Validate and cleanup
		  shortKey = shortKey.Trim
		  longKey = longKey.Trim
		  description = description.Trim.ReplaceLineEndings(EndOfLine)
		  
		  While shortKey.Left(1) = "-"
		    shortKey = shortKey.Middle(1).Trim
		  Wend
		  While longKey.Left(1) = "-"
		    longKey = longKey.Middle(1).Trim
		  Wend
		  
		  If shortKey = "" and longKey = "" Then
		    Raise New OptionException("Option must specify at least one key.")
		  End If
		  If shortKey.Length > 1 Then
		    Raise New OptionException("Short Key is optional but may only be one character: " + shortKey)
		  End If
		  If longKey.Length = 1 Then
		    Raise New OptionException("Long Key is optional but must be more than one character: " + longKey)
		  End If
		  
		  Self.ShortKey = shortKey
		  Self.LongKey = longKey
		  Self.Description = description
		  Self.Type = type
		  Self.IsRequired = isRequired
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub HandleValue(value As String)
		  //
		  // For internal `CKOptionParser` use.
		  //
		  // Handles converting the `String` representation of an option as supplied
		  // by the user to the actual `OptionType`, for example, converts a `String`
		  // to an `Integer`, `Double`, `Date`, `Boolean`, `FolderItem`, etc...
		  //
		  
		  //
		  // Check to see if the value is allowed or disallowed first
		  //
		  If AllowedValues.LastIndex <> -1 And AllowedValues.IndexOf(value) = -1 Then
		    Raise New OptionException("The key value is not allowed: " + value)
		  End If
		  If DisallowedValues.LastIndex <> -1 And DisallowedValues.IndexOf(value) <> -1 Then
		    Raise New OptionException("The key value is dissallowed: " + value)
		  End If
		  
		  Var newValue As Variant
		  
		  Select Case Type
		  Case OptionTypes.Boolean
		    Select Case value
		    Case "", "y", "yes", "t", "true", "on", "1"
		      newValue = True
		      
		    Else
		      newValue = False
		    End Select
		    
		  Case OptionTypes.DateTime
		    Try
		      newValue = DateTime.FromString(value)
		    Catch
		      newValue = value
		    End Try
		    
		  Case OptionTypes.Directory
		    If value <> "" Then
		      newValue = ConsoleKit.OptionParser.GetRelativeFolderItem(value)
		    End If
		    
		  Case OptionTypes.Double
		    newValue = Val(value)
		    
		  Case OptionTypes.File
		    If value <> "" Then
		      newValue = ConsoleKit.OptionParser.GetRelativeFolderItem(value)
		    End If
		    
		  Case OptionTypes.Integer
		    newValue = Val(value)
		    
		  Case OptionTypes.String
		    newValue = value
		  End Select
		  
		  If Self.IsArray Then
		    If Not Self.WasSet Then
		      Self.Value = Array(newValue)
		      
		    Else
		      Var ary() As Variant = Self.Value
		      ary.Add(newValue)
		      Self.Value = ary
		    End If
		    
		  Else
		    Self.Value = newValue
		  End If
		  
		  Self.WasSet = True
		End Sub
	#tag EndMethod


	#tag Note, Name = Enums
		### OptionType
		
		Represent a valid type of option.
		
		* `String`
		* `Integer` - Supplied value must be a valid number
		* `Double` - Supplied value must be a valid number
		* `Date` - Supplied value must pass be a valid input to `DateTime.FromString`
		* `Boolean` - If supplied value is `""`, `"y"`, `"yes"`, `"t"`, `"true"`, `"on"`, `"1"` then it is considered `True`, otherwise `False`
		* `File` - Represented by a `FolderItem`
		* `Directory` - Represented by a `FolderItem`
		
	#tag EndNote


	#tag Property, Flags = &h21
		Private AllowedValues() As String
	#tag EndProperty

	#tag Property, Flags = &h0
		#tag Note
			Description that will appear in the application help for this option.
		#tag EndNote
		Description As String
	#tag EndProperty

	#tag Property, Flags = &h21
		Private DisallowedValues() As String
	#tag EndProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  Var desc() as string = Array(Description)
			  
			  if AllowedValues.LastIndex <> -1 then
			    Var chunk as string = "[can be: `" + String.FromArray(AllowedValues, "', `") + "']"
			    desc.Add(chunk)
			  end if
			  
			  if DisallowedValues.LastIndex <> -1 then
			    Var chunk as string = "[may not be: `" + String.FromArray(DisallowedValues, "', `") + "']"
			    desc.Add(chunk)
			  end if
			  
			  return String.FromArray(desc, " ")
			  
			End Get
		#tag EndGetter
		HelpDescription As String
	#tag EndComputedProperty

	#tag Property, Flags = &h0
		#tag Note
			
			
			For example, say this option has `IsArray=True` and is `-i/--include`. On the command line one could:
			
			```
			$ myapp -i include -i project/include -i support/include abc.c
			```
			
			In code would look like:
			
			```
			Var v() As Variant = optParser.ArrayValue("include")
			
			Print v(0) // include
			Print v(1) // project/include
			Print v(2) // support/include
			```
			If True, this option will handle multiple values and store those values into an array, even if one or none.
		#tag EndNote
		IsArray As Boolean
	#tag EndProperty

	#tag Property, Flags = &h0
		#tag Note
			When set to `True` validation will be done on a `OptionTypes.File` and `OptionTypes.Folder`
			to ensure that it can be read from. If the validation fails a `OptionInvalidKeyValueException`
			exception will be raised.
			
			**NOTE:** This does not mean that the option is required. It simply means that if supplied, the
			option needs to be readable. If you want to make sure that the option is both readable and
			required, one should also set `IsRequired=True`.
		#tag EndNote
		IsReadableRequired As Boolean
	#tag EndProperty

	#tag Property, Flags = &h0
		#tag Note
			If set to `True`, this option will be required to be supplied at the command line. If it is not
			supplied, a `OptionMissingKeyException` will be raised.
		#tag EndNote
		IsRequired As Boolean
	#tag EndProperty

	#tag ComputedProperty, Flags = &h0
		#tag Note
			Read-only property that one can check to ensure if the Option value is valid
			or not.
		#tag EndNote
		#tag Getter
			Get
			  If IsRequired And Not WasSet Then
			    Return False
			  End If
			  
			  If IsRequired Or WasSet Then
			    Select Case Type
			    Case OptionTypes.DateTime
			      If IsValidDateRequired Then
			        #Pragma BreakOnExceptions False
			        Var d As DateTime
			        Try
			          d = Datetime.FromString(Value.StringValue)
			        Catch e
			          Return False
			        End Try
			        If d Is Nil Then
			          Return False
			        End If
			      End If
			      
			    Case OptionTypes.Directory, OptionTypes.File
			      Var fi As FolderItem = Value
			      
			      If IsRequired Or WasSet Then
			        If IsReadableRequired And (fi Is Nil Or fi.IsReadable = False) Then
			          Return False
			        End If
			        
			        If IsWriteableRequired And (fi Is Nil Or fi.IsWriteable = False) Then
			          Return False
			        End If
			      End If
			      
			    Case OptionTypes.Double, OptionTypes.Integer
			      Var d As Double = Value
			      
			      If MinimumNumber <> kNumberNotSet And d < MinimumNumber Then
			        Return False
			      End If
			      
			      If MaximumNumber <> kNumberNotSet And d > MaximumNumber Then
			        Return False
			      End If
			    End Select
			  End If
			  
			  Return True
			End Get
		#tag EndGetter
		IsValid As Boolean
	#tag EndComputedProperty

	#tag Property, Flags = &h0
		#tag Note
			When set to `True` validation is performed on the supplied value to make sure it is a valid
			date. If the validation fails a `OptionInvalidKeyValueException` exception will be raised.
			
			**NOTE:** This does not mean that the option is required. It simply means that if supplied, the
			option needs to be a valid date. If you want to make sure that the option is both a readable
			date and required, one should also set `IsRequired=True`.
		#tag EndNote
		IsValidDateRequired As Boolean
	#tag EndProperty

	#tag Property, Flags = &h0
		#tag Note
			When set to `True` validation will be done on a `OptionTypes.File` and `OptionTypes.Folder`
			to ensure that it can be written to. If the validation fails a `OptionInvalidKeyValueException`
			exception will be raised.
			
			**NOTE:** This does not mean that the option is required. It simply means that if supplied, the
			option needs to be writeable. If you want to make sure that the option is both writeable and
			required, one should also set `IsRequired=True`.
		#tag EndNote
		IsWriteableRequired As Boolean
	#tag EndProperty

	#tag Property, Flags = &h0
		#tag Note
			An option can have a short and long key. This is the long key. A key is what the user
			supplies on the command line to supply a particular value to a given option.
			
			For example, suppose you are writing a Hello World program and wish to accept a name
			on the command line of who to say hello to. The long option name be "name" while the
			short "n".
			
			```
			$ say-hello -n John
			Hello John!
			$ say-hello --name=John
			Hello John!
			```
		#tag EndNote
		LongKey As String
	#tag EndProperty

	#tag Property, Flags = &h0
		#tag Note
			Set a maximum limit to an `Integer` or `Double` option type.
			
			**NOTE:** This does not mean that the option is required. It simply means that if supplied, the
			option needs to be no more than this. If you want to make sure that the option has a maximum value
			and is required, one should also set `IsRequired=True`.
		#tag EndNote
		MaximumNumber As Double = kNumberNotSet
	#tag EndProperty

	#tag Property, Flags = &h0
		#tag Note
			Set a minimum limit to an `Integer` or `Double` option type.
			
			**NOTE:** This does not mean that the option is required. It simply means that if supplied, the
			option needs to be no less than this. If you want to make sure that the option has a minimum value
			and is required, one should also set `IsRequired=True`.
		#tag EndNote
		MinimumNumber As Double = kNumberNotSet
	#tag EndProperty

	#tag Property, Flags = &h0
		#tag Note
			An option can have a short and long key. This is the short key. A key is what the user
			supplies on the command line to supply a particular value to a given option.
			
			For example, suppose you are writing a Hello World program and wish to accept a name
			on the command line of who to say hello to. The long option name be "name" while the
			short "n".
			
			```
			$ say-hello -n John
			Hello John!
			$ say-hello --name=John
			Hello John!
			```
		#tag EndNote
		ShortKey As String
	#tag EndProperty

	#tag Property, Flags = &h0
		#tag Note
			Gets or set what type of option this is.
			
			Please see the `OptionTypes` enum for more information.
		#tag EndNote
		Type As OptionTypes
	#tag EndProperty

	#tag ComputedProperty, Flags = &h0
		#tag Note
			Retrieve a `String` representation of the enum `OptionType` associated with this option.
		#tag EndNote
		#tag Getter
			Get
			  Select Case Type
			  Case OptionTypes.Boolean
			    Return "BOOL"
			    
			  Case OptionTypes.DateTime
			    Return "DATE TIME"
			    
			  Case OptionTypes.Directory
			    Return "DIR"
			    
			  Case OptionTypes.Double
			    Return "DOUBLE"
			    
			  Case OptionTypes.File
			    Return "FILE"
			    
			  Case OptionTypes.Integer
			    Return "INTEGER"
			    
			  Case OptionTypes.String
			    Return "STR"
			  End Select
			End Get
		#tag EndGetter
		TypeString As String
	#tag EndComputedProperty

	#tag Property, Flags = &h0
		#tag Note
			Get or set the user supplied value of this option.
		#tag EndNote
		Value As Variant
	#tag EndProperty

	#tag Property, Flags = &h0
		#tag Note
			If the option was supplied on the command line, `WasSet` will return True. Otherwise
			it will return `False`. This can be used to determine if a default value should be
			used or maybe further user prompting.
		#tag EndNote
		WasSet As Boolean
	#tag EndProperty


	#tag Constant, Name = kNone, Type = String, Dynamic = False, Default = \"", Scope = Private
	#tag EndConstant

	#tag Constant, Name = kNumberNotSet, Type = Double, Dynamic = False, Default = \"-32768", Scope = Private
	#tag EndConstant


	#tag ViewBehavior
		#tag ViewProperty
			Name="Description"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="String"
			EditorType="MultiLineEditor"
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
			Name="IsReadableRequired"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="IsRequired"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="IsValid"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="IsValidDateRequired"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="IsWriteableRequired"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Boolean"
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
			Name="LongKey"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="MaximumNumber"
			Visible=false
			Group="Behavior"
			InitialValue="kNumberNotSet"
			Type="Double"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="MinimumNumber"
			Visible=false
			Group="Behavior"
			InitialValue="kNumberNotSet"
			Type="Double"
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
			Name="ShortKey"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="String"
			EditorType="MultiLineEditor"
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
			Name="Top"
			Visible=true
			Group="Position"
			InitialValue="0"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="TypeString"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="WasSet"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="IsArray"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Type"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="OptionTypes"
			EditorType="Enum"
			#tag EnumValues
				"0 - String"
				"1 - Integer"
				"2 - Double"
				"3 - DateTime"
				"4 - Boolean"
				"5 - File"
				"6 - Directory"
			#tag EndEnumValues
		#tag EndViewProperty
		#tag ViewProperty
			Name="HelpDescription"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass

#tag Class
Protected Class XKProject
	#tag Method, Flags = &h21, Description = 436F6D70757465732074686520746F74616C206E756D626572206F6620757365722D7772697474656E206C696E6573206F6620636F646520616E6420636F6D6D656E74732E
		Private Sub ComputeLineAndCommentCounts()
		  /// Computes the total number of user-written lines of code and comments.
		  
		  For Each item As XKItem In Self.Items
		    mCodeLineCount = mCodeLineCount + item.CodeLineCount
		    mCommentCount = mCommentCount + item.CommentCount
		  Next item
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor(manifest As FolderItem)
		  Self.Manifest = manifest
		  Self.ItemContainers = New Dictionary
		  Self.Options = New XKOptions
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21, Description = 466F722022586F6A6F2050726F6A6563742220666F726D61742070726F6A656374732C2066696E6420746865206974656D207468617420697320746865206170706C69636174696F6E206F626A6563742E
		Private Sub FindApplicationObject()
		  /// For "Xojo Project" format projects, find the item that is the application object.
		  ///
		  /// This process is not required for XML projects as the application object item has a special 
		  /// flag (`<IsApplicationObject>1</IsApplicationObject>`).
		  /// Thanks to Norm for help with this: https://ifnotnil.com/t/re-tree-problem/2450/7?u=garry
		  /// See also my public post: https://forum.xojo.com/t/xojo-project-manifest/69783/10
		  ///
		  /// Essentially we need to find the **first** item whose super class is the correct "Application" class (this 
		  /// will vary by project type, e.g. DesktopApplication, WebApplication, etc). This is the **Prime** item. 
		  /// If this is the only item with that superclass then that's the AppObject.
		  /// If there are multiple items in the project that subclass the "Application" class then we'll assume 
		  /// that the AppObject is the first item found that inherits from the Prime item.
		  
		  Var prime As XKItem // The first item that subclasses the Application super.
		  Var appSubclassCount As Integer = 0 // How many items subclass the Application super.
		  
		  // What is the expected Application superclass?
		  Var superClass As String
		  Select Case Self.Type
		  Case "Desktop"
		    // There are two types of application superclass (Application and DesktopApplication). We'll have
		    // to check for both of these separately so do nothing for now.
		    superClass = ""
		  Case "Console"
		    superClass = "ConsoleApplication"
		  Case "Web", "Web2"
		    superClass = "WebApplication"
		  Case "iOS"
		    superClass = "MobileApplication"
		  Else
		    Raise New UnsupportedOperationException("Unknown Xojo project type `" + Self.type + "`")
		  End Select
		  
		  // Find the prime and count the number of items that subclass the application super.
		  For Each item As XKItem In Self.Items
		    If Self.Type = "Desktop" Then
		      If item.Superclass = "DesktopApplication" Or item.Superclass = "Application" Then
		        If appSubclassCount = 0 Then
		          prime = item
		        End If
		        appSubclassCount = appSubclassCount + 1
		      End If
		    Else
		      If item.Superclass = superClass Then
		        If appSubclassCount = 0 Then
		          prime = item
		        End If
		        appSubclassCount = appSubclassCount + 1
		      End If
		    End If
		  Next item
		  
		  Var foundAppObject As Boolean = False
		  If appSubclassCount = 0 Then
		    Raise New UnsupportedOperationException("Could not find the application object in the project.")
		    
		  Else
		    If appSubclassCount = 1 And prime.Name = "App" Then
		      // This is the commonest scenario. The prime is the AppObject.
		      prime.IsApplicationObject = True
		      foundAppObject = True
		    Else
		      // Find the first item whose super is the prime.
		      For Each item As XKItem In Self.Items
		        If item.Superclass = prime.Name Then
		          item.IsApplicationObject = True
		          foundAppObject = True
		          Exit
		        End If
		      Next item
		    End If
		  End If
		  
		  If Not foundAppObject Then
		    Raise New UnsupportedOperationException("Could not find the application object in the project.")
		  End If
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21, Description = 52657475726E732074686520466F6C6465724974656D207265666572656E636564206279206070617468602C206F7074696F6E616C6C792072656C617469766520746F206072656C6174697665546F602E204D617920726169736520612060586F646F63457863657074696F6E602E
		Private Function FolderItemFromManifestPath(path As String, relativeTo As FolderItem = Nil) As FolderItem
		  /// Returns the FolderItem referenced by `path`, optionally relative to `relativeTo`.
		  /// May raise a `XKException`.
		  
		  Var prefix As String = ""
		  
		  Var pathSep As String
		  #If TargetWindows Then
		    pathSep = "\"
		  #Else
		    pathSep = "/"
		  #EndIf
		  
		  // Is what is passed actually a relative path?
		  #If TargetWindows Then
		    If path.Middle(1, 1) = ":" Then
		      Return GetFolderItem(path, FolderItem.PathTypeShell)
		    End If
		    
		    If path.Left(1) = pathSep Then
		      relativeTo = GetFolderItem(SpecialFolder.CurrentWorkingDirectory.NativePath.Left(3))
		    End If
		    
		  #Else
		    If path.Left(1) = pathSep Then
		      Try
		        Var f As New FolderItem(path, FolderItem.PathModes.Shell)
		        Return f
		      Catch e
		        Raise New XKException("Unable to retrieve FolderItem with path `" + path + "`.")
		      End Try
		    End If
		    
		    prefix = pathSep
		  #EndIf
		  
		  // Seems to be a relative path.
		  If relativeTo = Nil Then relativeTo = SpecialFolder.CurrentWorkingDirectory
		  
		  path = relativeTo.NativePath + pathSep + path
		  
		  Var newParts() As String
		  Var pathParts() As String = path.Split(pathSep)
		  For i As Integer = 0 to pathParts.LastIndex
		    Var p As String = pathParts(i)
		    If p = "" Then
		      // Happens on Windows as it appends `pathSep` onto the end of NativePath if `relativeTo` is a folder.
		      
		    ElseIf p = "." Then
		      // Skip this path component.
		      
		    ElseIf p = ".." Then
		      // Remove the last path component from `newParts`.
		      If newParts.Count > 0 Then Call newParts.Pop
		      
		    Else
		      // Nothing special about this path component.
		      newParts.Add(p)
		    End If
		  Next i
		  
		  path = prefix + String.FromArray(newParts, pathSep)
		  
		  Try
		    Var f As New FolderItem(path, FolderItem.PathModes.Shell)
		    Return f
		  Catch e
		    Raise New XKException("Unable to retrieve FolderItem with path `" + path + "`.")
		  End Try
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21, Description = 412064656C656761746520746F20736F727420616E206172726179206F662060584B4974656D60206974656D7320616C7068616265746963616C6C79206279206E616D652E
		Private Function ItemChildrenSortDelegate(item1 As XKItem, item2 As XKItem) As Integer
		  /// A delegate to sort an array of `XKItem` items alphabetically by name.
		  
		  If item1.Name > item2.Name Then
		    Return 1
		  ElseIf item1.Name < item2.Name Then
		    Return -1
		  Else
		    Return 0
		  End If
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 52657475726E7320616E206172726179206F6620616C6C206974656D7320696E207468652070726F6A656374207769746820616E20656D707479206465736372697074696F6E2E
		Function ItemsMissingDescription(excludeConstructors As Boolean = False) As XKItem()
		  /// Returns an array of all items in the project with an empty description.
		  ///
		  /// This is useful for ensuring you have added a description to all item members.
		  /// We provide the option to exclude constructors because there is little point adding a description to
		  /// them for many developers as the IDE does not show their descriptions in the IDE.
		  
		  Var missing() As XKItem
		  
		  For Each item As XKItem In Self.Items
		    If item.MembersMissingDescription(excludeConstructors).Count > 0 Then
		      missing.Add(item)
		    End If
		  Next item
		  
		  Return missing
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 506172736573207468652070726F6A6563742066696C65206164686572696E6720746F2069747320736574206F7074696F6E732E
		Sub Parse()
		  /// Parses the project file adhering to its set options.
		  
		  ParseManifest
		  
		  ParseItems
		  
		  // Clear out any references to items in Root that are excluded.
		  If Options.RemoveExcludedItems Then
		    PurgeExcludedChildren(Self.Root)
		  End If
		  
		  ComputeLineAndCommentCounts
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21, Description = 5061727365732074686F73652066696C657320696E207468652070726F6A656374206D616E696665737420746861742068617665206E6F74206265656E206578636C756465642E20417373756D6573206050617273654D616E6966657374602068617320616C72656164792065786563757465642E
		Private Sub ParseItems()
		  /// Parses those items in the project manifest that have not been excluded. 
		  /// Assumes `ParseManifest` has already executed.
		  
		  For i As Integer = Items.LastIndex DownTo 0
		    Var item As XKItem = Self.Items(i)
		    
		    If item.Type <> XojoKit.ItemTypes.Folder And item.Type <> XojoKit.ItemTypes.Root Then
		      item.Parse(Options)
		    End If
		    
		    // Since we only now know the item's scope, exclude it if needed.
		    If Options.ExcludePrivate And item.Scope = XojoKit.Scopes.Private_ Then
		      Self.Items(i).IsExcluded = True
		    End If
		    
		    // If at least one item is external then store this fact.
		    If item.IsExternal Then mContainsExternalItems = True
		    
		    // Update the project's count of individual item counts.
		    UpdateItemCounts(item)
		  Next i
		  
		  // Find the classes and modules contained within other modules.
		  For Each item As XKItem In Self.Items
		    If item.Type <> XojoKit.ItemTypes.Module_ Then Continue
		    
		    For Each query As XKItem In Self.Items
		      If query.ParentID = item.ID Then
		        // `item` is the parent of `query`.
		        If query.Type = XojoKit.ItemTypes.Class_ Then
		          item.Classes.Add(query)
		        ElseIf query.Type = XojoKit.ItemTypes.Module_ Then
		          item.Modules.Add(query)
		        ElseIf query.Type = XojoKit.ItemTypes.Interface_ Then
		          item.Interfaces.Add(query)
		        End If
		      End If
		    Next query
		  Next item
		  
		  If Self.FileFormat = XojoKit.FileFormats.Project Then
		    FindApplicationObject
		  End If
		  
		  If Options.ExcludeAppObject Then
		    For Each item As XKItem In Self.Items
		      If item.IsApplicationObject Then
		        item.IsExcluded = True
		        Exit
		      End If
		    Next item
		  End If
		  
		  // Do we need to remove excluded items?
		  If Options.RemoveExcludedItems Then
		    For i As Integer = Items.LastIndex DownTo 0
		      If Items(i).IsExcluded Then
		        Items.RemoveAt(i)
		      End If
		    Next i
		  End If
		  
		  // Do we need to remove excluded members?
		  If Options.RemoveExcludedMembers Then
		    For Each item As XKItem In Items
		      // Classes.
		      For i As Integer = item.Classes.LastIndex DownTo 0
		        If item.Classes(i).IsExcluded Then
		          item.Classes.RemoveAt(i)
		        End If
		      Next i
		      
		      // Constants.
		      For i As Integer = item.Constants.LastIndex DownTo 0
		        If item.Constants(i).IsExcluded Then
		          item.Constants.RemoveAt(i)
		        End If
		      Next i
		      
		      // Delegates.
		      For i As Integer = item.Delegates.LastIndex DownTo 0
		        If item.Delegates(i).IsExcluded Then
		          item.Delegates.RemoveAt(i)
		        End If
		      Next i
		      
		      // Enums.
		      For i As Integer = item.Enums.LastIndex DownTo 0
		        If item.Enums(i).IsExcluded Then
		          item.Enums.RemoveAt(i)
		        End If
		      Next i
		      
		      // Event definitions.
		      For i As Integer = item.EventDefinitions.LastIndex DownTo 0
		        If item.EventDefinitions(i).IsExcluded Then
		          item.EventDefinitions.RemoveAt(i)
		        End If
		      Next i
		      
		      // Events.
		      For i As Integer = item.Events.LastIndex DownTo 0
		        If item.Events(i).IsExcluded Then
		          item.Events.RemoveAt(i)
		        End If
		      Next i
		      
		      // Interfaces.
		      For i As Integer = item.Interfaces.LastIndex DownTo 0
		        If item.Interfaces(i).IsExcluded Then
		          item.Interfaces.RemoveAt(i)
		        End If
		      Next i
		      
		      // Methods.
		      For i As Integer = item.Methods.LastIndex DownTo 0
		        If item.Methods(i).IsExcluded Then
		          item.Methods.RemoveAt(i)
		        End If
		      Next i
		      
		      // Modules.
		      For i As Integer = item.Modules.LastIndex DownTo 0
		        If item.Modules(i).IsExcluded Then
		          item.Modules.RemoveAt(i)
		        End If
		      Next i
		      
		      // Notes.
		      For i As Integer = item.Notes.LastIndex DownTo 0
		        If item.Notes(i).IsExcluded Then
		          item.Notes.RemoveAt(i)
		        End If
		      Next i
		      
		      // Properties.
		      For i As Integer = item.Properties.LastIndex DownTo 0
		        If item.Properties(i).IsExcluded Then
		          item.Properties.RemoveAt(i)
		        End If
		      Next i
		      
		      // Structures.
		      For i As Integer = item.Structures.LastIndex DownTo 0
		        If item.Structures(i).IsExcluded Then
		          item.Structures.RemoveAt(i)
		        End If
		      Next i
		    Next item
		  End If
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21, Description = 5061727365732074686520636F6E74656E7473206F6620746865206D616E69666573742E
		Private Sub ParseManifest()
		  /// Parses the contents of the manifest. May raise a `XKException`.
		  
		  // Sanity checks.
		  If Self.Manifest = Nil Then
		    Raise New UnsupportedOperationException("Cannot parse the manifest as it is Nil.")
		  End If
		  If Not Self.Manifest.Exists Then
		    Raise New UnsupportedOperationException("Cannot parse the manifest file as it does not exist.")
		  End If
		  
		  // Is this a Xojo Project or XML manifest?
		  Select Case Self.Manifest.NameExtensionMBS
		  Case "xojo_project"
		    Self.FileFormat = XojoKit.FileFormats.Project
		    Self.Name = Self.Manifest.NameWithoutExtensionMBS
		    ParseProjectManifest
		    
		  Case "xojo_xml_project"
		    Self.FileFormat = XojoKit.FileFormats.XML
		    Self.Name = Self.Manifest.NameWithoutExtensionMBS
		    ParseXMLManifest
		    
		  Else
		    Raise New XKException("Unknown project manifest file format. Only `.xojo_project` and " + _
		    "`.xojo_xml_project` formats are supported.")
		  End Select
		  
		  // =================================================
		  // COMPUTE EACH ITEM'S PATH AND FULLY QUALIFIED NAME
		  // =================================================
		  For Each item As XKItem In Self.Items
		    Var path() As String
		    Var fqn() As String // Will be concatenated to form the item's FQN.
		    
		    If item.ParentId = 0 Then
		      // This is an item at the root of the project.
		      item.FQN = item.Name
		      Continue
		    End If
		    
		    // This item is within folder(s) and/or module(s). Get its parent(s).
		    Var current As XKItem = ItemContainers.Lookup(item.ParentID, Nil)
		    Var parents() As XKItem
		    If current <> Nil Then
		      Do
		        If current.Type <> XojoKit.ItemTypes.Root Then
		          parents.Add(current)
		        End If
		        current = Self.ItemContainers.Lookup(current.ParentID, Nil)
		      Loop Until current Is Nil
		    End If
		    
		    // Add the parent names to the FQN array.
		    For i As Integer = parents.LastIndex DownTo 0
		      path.Add(parents(i).Name)
		      If parents(i).Type = XojoKit.ItemTypes.Folder Then
		        path(path.LastIndex) = path(path.LastIndex) + ">"
		      Else
		        fqn.Add(parents(i).Name)
		      End If
		    Next i
		    
		    // Lastly append item's name to the FQN array.
		    fqn.Add(item.Name)
		    
		    // We can now construct the folder/module path from the parents.
		    // Modules and folders are separated with `>`. Items in the root of the project have an empty path.
		    item.Path = String.FromArray(path, ".").ReplaceAll(">.", ">")
		    If item.Path.EndsWith(">") Then item.Path = item.Path.TrimRight(">")
		    
		    // The fully qualified name is a dot-separated path that excludes folders.
		    item.FQN = String.FromArray(fqn, ".")
		    
		  Next item
		  
		  // =================================================
		  // EXCLUSIONS
		  // =================================================
		  For i As Integer = Self.Items.LastIndex DownTo 0
		    Var item As XKItem = Self.Items(i)
		    
		    // Exclude any items in the option's list of excluded object types.
		    For Each excludedType As XojoKit.ItemTypes In Options.ExcludedItemTypes
		      If item.Type = excludedType Then
		        Self.Items(i).IsExcluded = True
		        If Self.ItemContainers.HasKey(item.ID) Then
		          XKItem(Self.ItemContainers.Value(item.ID)).IsExcluded = True
		        End If
		        GoTo NextItem
		      End If
		    Next excludedType
		    
		    // Exclude any items in the option's list of excluded paths.
		    For Each excludedPath As String In Options.ExcludedPaths
		      If item.Path.IndexOf(excludedPath) <> -1 Or (item.Path = "" And item.Name = excludedPath) Then
		        Self.Items(i).IsExcluded = True
		        If Self.ItemContainers.HasKey(item.ID) Then
		          XKItem(Self.ItemContainers.Value(item.ID)).IsExcluded = True
		        End If
		        GoTo NextItem
		      End If
		    Next excludedPath
		    
		    // Exclude any items in the option's list of excluded FQNs.
		    For Each excludedFQN As String In Options.ExcludedFQNs
		      If item.FQN.IndexOf(excludedFQN) <> -1 Then
		        Self.Items(i).IsExcluded = True
		        If Self.ItemContainers.HasKey(item.ID) Then
		          XKItem(Self.ItemContainers.Value(item.ID)).IsExcluded = True
		        End If
		        GoTo NextItem
		      End If
		    Next excludedFQN
		    
		    NextItem:
		  Next i
		  
		  // =================================================
		  // Set each item's children.
		  For Each entry As DictionaryEntry In Self.ItemContainers
		    Var current As XKItem = entry.Value
		    // Find every item whose parent is the current one.
		    For Each item As XKItem In Self.Items
		      If item.ParentID = current.ID Then
		        current.Children.Add(item)
		      End If
		    Next item
		    // Sort this item's children alphabetically (folders first, then modules, then all other item types)
		    current.Children.Sort(AddressOf ItemChildrenSortDelegate)
		  Next entry
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21, Description = 5061727365732074686520636F6E74656E7473206F6620612022586F6A6F2050726F6A6563742220666F726D6174206D616E69666573742E204D617920726169736520612060584B457863657074696F6E602E
		Private Sub ParseProjectManifest()
		  /// Parses the contents of a "Xojo Project" format manifest. May raise a `XKException`.
		  ///
		  /// Assumes `Self.Manifest` is actually a `.xojo_project` file.
		  /// Line format:
		  /// KEY EQUAL value
		  /// value = (component(;component)*)?
		  /// component = STRING | NUMBER | BOOLEAN
		  
		  // Many line values follow a specified format of multiple semicolon-delimited components.
		  // KEY=NAME;PATH;ID;PARENT_ID;UNKNOWN
		  Const COMPONENT_NAME = 0
		  Const COMPONENT_PATH = 1
		  Const COMPONENT_ID = 2
		  Const COMPONENT_PARENT_ID = 3
		  Const COMPONENT_UNKNOWN = 4
		  
		  // Clear out the `ItemContainers` dictionary and add a new project root.
		  Self.ItemContainers = New Dictionary
		  mRoot = New XKItem(Self)
		  mRoot.Type = XojoKit.ItemTypes.Root
		  mRoot.Name = "Project Root"
		  mRoot.ID = 0
		  mRoot.ParentID = -1
		  ItemContainers.Value(mRoot.ID) = mRoot
		  
		  // Clear out any existing items.
		  Self.Items.RemoveAll
		  
		  // Get the contents of the manifest.
		  Var tin As TextInputStream
		  Var contents As String
		  Try
		    tin = TextInputStream.Open(Self.Manifest)
		    contents = tin.ReadAll.ReplaceLineEndings(EndOfLine.UNIX)
		    tin.Close
		  Catch e As IOException
		    Raise New IOException("Unable to read the contents of the manifest file: `" + e.Message + "`.")
		  End Try
		  
		  // Get the lines.
		  Var lines() As String = contents.Split(EndOfLine.UNIX)
		  
		  // Remove empty lines.
		  For i As Integer = lines.LastIndex DownTo 0
		    If lines(i).IsEmpty Then lines.RemoveAt(i)
		  Next i
		  
		  // Analyse each line of the manifest.
		  For Each line As String In lines
		    // Get the line's key and raw value.
		    Var key As String = line.Left(line.IndexOf("="))
		    Var value As String = line.Middle(line.IndexOf("=") + 1).Trim
		    
		    // Split the value into its components.
		    Var components() As String = value.Split(";")
		    If components.Count = 0 Then
		      // Not interested in this.
		      Continue
		    End If
		    
		    Select Case key
		    Case "MacCarbonMachName"
		      Self.NameMac = value
		      
		    Case "LinuxX86Name"
		      Self.NameLinux = value
		      
		    Case "WindowsName"
		      Self.NameWindows = value
		      
		    Case "HiDPI"
		      Self.SupportsHiDPI = If(value = "True", True, False)
		      
		    Case "DarkMode"
		      Self.SupportsDarkMode = If(value = "True", True, False)
		      
		    Case "Type"
		      Self.Type = value
		      
		    Case "RBProjectVersion"
		      Self.RBProjectVersion = value
		      
		    Case "MinIDEVersion"
		      Self.MinimumIDEVersion = value
		      
		    Case "OrigIDEVersion"
		      Self.OriginalIDEVersion = value
		      
		    Case "Class", "Module", "Interface", "DesktopWindow", "Window", "MobileScreen"
		      // Assert that the path is a known xojo file format.
		      Var fileFormat As XojoKit.FileFormats = XojoKit.FileFormats.Unknown
		      If components(COMPONENT_PATH).EndsWith(".xojo_code") Then
		        fileFormat = XojoKit.FileFormats.Project
		        
		      ElseIf components(COMPONENT_PATH).EndsWith(".xojo_xml_code") Then
		        fileFormat = XojoKit.FileFormats.XML
		        
		      ElseIf components(COMPONENT_PATH).EndsWith(".xojo_window") Then
		        fileFormat = XojoKit.FileFormats.Window
		      End If
		      
		      If fileFormat = XojoKit.FileFormats.Unknown Then
		        // We don't support files of this type.
		        Continue
		      End If
		      
		      // Add this item to the project.
		      Var item As New XKItem(Self)
		      Var f As FolderItem = FolderItemFromManifestPath(components(COMPONENT_PATH), Self.Manifest.Parent)
		      item.Name = components(COMPONENT_NAME)
		      item.File = f
		      item.FileFormat = fileFormat
		      item.ID = Integer.FromHex(components(COMPONENT_ID).ReplaceAll("&h", ""))
		      item.ParentID = Integer.FromHex(components(COMPONENT_PARENT_ID).ReplaceAll("&h", ""))
		      
		      // XML files within a `.xojo_project` are external.
		      item.IsExternal = If(fileFormat = XojoKit.FileFormats.XML, True, False)
		      
		      // If this is an XML file, get the XML node containing the item's properties.
		      If item.IsExternal And item.FileFormat = XojoKit.FileFormats.XML Then
		        Var itemXML As String
		        // The item is contained within an external XML file.
		        Try
		          tin = TextInputStream.Open(item.File)
		          itemXML = tin.ReadAll
		          tin.Close
		        Catch e
		          Raise New XKException("Unable to get the XML contents of the item's file.")
		        Finally
		          tin.Close
		        End Try
		        // Create an XML document from the string.
		        Var xmlDoc As New XmlDocument(itemXML)
		        // Extract the item's node from the document. 
		        // It's properties are contained within the first <block> element.
		        // <RBProject><block>...</block></RBProject>
		        item.XML = xmlDoc.FirstChild.FirstChild
		      End If
		      
		      Self.Items.Add(item)
		      
		      // Modules can also be containers.
		      If key = "Module" Then
		        item.Type = XojoKit.ItemTypes.Module_
		        Self.ItemContainers.Value(item.ID) = item
		      End If
		      
		    Case "Folder"
		      Var folder As New XKItem(Self)
		      folder.Type = XojoKit.ItemTypes.Folder
		      folder.Name = components(COMPONENT_NAME)
		      folder.ID = Integer.FromHex(components(COMPONENT_ID).ReplaceAll("&h", ""))
		      folder.ParentID = Integer.FromHex(components(COMPONENT_PARENT_ID).ReplaceAll("&h", ""))
		      Self.Items.Add(folder)
		      ItemContainers.Value(folder.ID) = folder
		      
		    Case "MenuBar"
		      #Pragma Warning "TODO: Parse MenuBars"
		      
		    Case "DesktopToolbar", "Toolbar"
		      #Pragma Warning "TODO: Parse ToolBars"
		      
		    Case "Worker"
		      #Pragma Warning "TODO: Parse Workers"
		      
		    Case "FileTypeSet"
		      #Pragma Warning "TODO: Parse FileTypeSets"
		      
		    Case "MultiImage"
		      #Pragma Warning "TODO: Parse ImageSets"
		      
		    Case "MajorVersion"
		      Self.AppMajorVersion = Integer.FromString(value)
		      
		    Case "MinorVersion"
		      Self.AppMinorVersion = Integer.FromString(value)
		      
		    Case "SubVersion"
		      Self.AppBugVersion = Integer.FromString(value)
		      
		    Case "NonRelease"
		      Self.AppNonReleaseVersion = Integer.FromString(value)
		      
		    Else
		      // We're not interested in the other manifest values.
		      Continue
		    End Select
		  Next line
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21, Description = 5061727365732074686520636F6E74656E7473206F66206120586F6A6F20584D4C20666F726D6174206D616E69666573742E204D617920726169736520612060584B457863657074696F6E602E
		Private Sub ParseXMLManifest()
		  /// Parses the contents of a Xojo XML format manifest. May raise a `XKException`.
		  ///
		  /// Assumes `Self.Manifest` is actually a `.xojo_xml_project` file.
		  
		  // Clear out the item containers dictionary and add the root.
		  Self.ItemContainers = New Dictionary
		  mRoot = New XKItem(Self)
		  mRoot.Type = XojoKit.ItemTypes.Root
		  mRoot.Name = "Project Root"
		  mRoot.ID = 0
		  mRoot.ParentID = -1
		  ItemContainers.Value(mRoot.ID) = mRoot
		  
		  // Clear out any existing items.
		  Self.Items.RemoveAll
		  
		  Var xmlDoc As New XmlDocument(Self.Manifest)
		  
		  Var rbProject As XmlNode = xmlDoc.FirstChild
		  // Get the versions used when saving the project.
		  // The XML project format `RBProjectVersion` value is subtly different:
		  // XML format:          "2022r1"
		  // Xojo project format: "2022.01"
		  Self.RBProjectVersion = rbProject.GetAttribute("version")
		  Self.MinimumIDEVersion = rbProject.GetAttribute("MinIDEVersion")
		  Self.XMLProjectFormat = rbProject.GetAttribute("FormatVersion")
		  
		  For i As Integer = 0 To rbProject.ChildCount - 1
		    Var block As XmlNode = rbProject.Child(i)
		    
		    If block.Name = "block" Then
		      Select Case block.GetAttribute("type")
		      Case "Project"
		        // Contains data about the project.
		        For j As Integer = 0 To block.ChildCount - 1
		          Var node As XmlNode = block.Child(j)
		          Select Case node.Name
		          Case "IDEVersion"
		            Self.OriginalIDEVersion = node.FirstChild.Value
		            
		          Case "MajorVersion"
		            Self.AppMajorVersion = Integer.FromString(node.FirstChild.Value)
		            
		          Case "MinorVersion"
		            Self.AppMinorVersion = Integer.FromString(node.FirstChild.Value)
		            
		          Case "SubVersion"
		            Self.AppBugVersion = Integer.FromString(node.FirstChild.Value)
		            
		          Case "ProjectType"
		            Self.Type = XMLProjectTypeToString(Integer.FromString(node.FirstChild.Value))
		            
		          Case "BuildCarbonMachOName"
		            Self.NameMac = If(node.FirstChild <> Nil, node.FirstChild.Value, "")
		            
		          Case "BuildWinName"
		            Self.NameWindows = If(node.FirstChild <> Nil, node.FirstChild.Value, "")
		            
		          Case "BuildLinuxX86Name"
		            Self.NameLinux = If(node.FirstChild <> Nil, node.FirstChild.Value, "")
		            
		          Case "HiDPI"
		            If node.FirstChild = Nil Then
		              Self.SupportsHiDPI = False
		            Else
		              Self.SupportsHiDPI = If(node.FirstChild.Value = "0", False, True)
		            End If
		            
		          Case "DarkMode"
		            If node.FirstChild = Nil Then
		              Self.SupportsDarkMode = False
		            Else
		              Self.SupportsDarkMode = If(node.FirstChild.Value = "0", False, True)
		            End If
		            
		          Else
		            // We're not interested in the other project block elements.
		          End Select
		        Next j
		        
		      Case "Module"
		        // An internal item. Either a class, interface or module.
		        // Build this item.
		        Var item As New XKItem(Self)
		        item.FileFormat = XojoKit.FileFormats.XML
		        item.IsExternal = False
		        item.File = Nil
		        item.ID = Integer.FromString(block.GetAttribute("ID"))
		        item.XML = block.Clone(True)
		        'item.Type = XojoKit.ItemTypes.Module_
		        
		        For k As Integer = 0 To block.ChildCount - 1
		          Var node As XmlNode = block.Child(k)
		          Select Case node.Name
		          Case "ObjName"
		            item.Name = node.FirstChild.Value
		            
		          Case "ObjContainerID"
		            item.ParentID = Integer.FromString(node.FirstChild.Value)
		          End Select
		        Next k
		        
		        // Add this item to the project.
		        Self.Items.Add(item)
		        
		        // Modules can also be containers.
		        Self.ItemContainers.Value(item.ID) = item
		        
		      Case "ExternalCode"
		        // An external item.
		        // Build this item.
		        Var item As New XKItem(Self)
		        item.FileFormat = XojoKit.FileFormats.XML
		        item.IsExternal = True
		        item.ID = Integer.FromString(block.GetAttribute("ID"))
		        
		        For k As Integer = 0 To block.ChildCount - 1
		          Var node As XmlNode = block.Child(k)
		          Select Case node.Name
		          Case "ObjName"
		            item.Name = node.FirstChild.Value
		            
		          Case "ObjContainerID"
		            item.ParentID = Integer.FromString(node.FirstChild.Value)
		            
		          Case "FullPath"
		            item.File = FolderItemFromManifestPath(node.FirstChild.Value, Nil)
		            
		            // Extract the XML block node from this file.
		            Var tin As TextInputStream = TextInputStream.Open(item.File)
		            Var externalXML As String = tin.ReadAll
		            tin.Close
		            Var doc As New XmlDocument(externalXML)
		            item.XML = doc.FirstChild.FirstChild.Clone(True)
		          End Select
		        Next k
		        
		        // Add this item to the project.
		        Self.Items.Add(item)
		        
		      Case "Folder"
		        // A folder.
		        Var folder As New XKItem(Self)
		        folder.Type = XojoKit.ItemTypes.Folder
		        folder.ID = Integer.FromString(block.GetAttribute("ID"))
		        
		        For a As Integer = 0 To block.ChildCount - 1
		          Var node As XmlNode = block.Child(a)
		          Select Case node.Name
		          Case "ObjName"
		            folder.Name = node.FirstChild.Value
		            
		          Case "ObjContainerID"
		            folder.ParentID = Integer.FromString(node.FirstChild.Value)
		            
		          End Select
		        Next a
		        ItemContainers.Value(folder.ID) = folder
		        
		      Case "Worker"
		        #Pragma Warning "TODO: Parse Workers"
		        
		      Case "DesktopWindow", "Window"
		        // Build this item.
		        Var item As New XKItem(Self)
		        item.FileFormat = XojoKit.FileFormats.XML
		        item.IsExternal = False
		        item.File = Nil
		        item.ID = Integer.FromString(block.GetAttribute("ID"))
		        item.XML = block.Clone(True)
		        item.Type = XojoKit.ItemTypes.Window_
		        
		        For k As Integer = 0 To block.ChildCount - 1
		          Var node As XmlNode = block.Child(k)
		          Select Case node.Name
		          Case "ObjName"
		            item.Name = node.FirstChild.Value
		            
		          Case "ObjContainerID"
		            item.ParentID = Integer.FromString(node.FirstChild.Value)
		          End Select
		        Next k
		        
		        // Add this item to the project.
		        Self.Items.Add(item)
		        
		      Case "MobileScreen"
		        // Build this item.
		        Var item As New XKItem(Self)
		        item.FileFormat = XojoKit.FileFormats.XML
		        item.IsExternal = False
		        item.File = Nil
		        item.ID = Integer.FromString(block.GetAttribute("ID"))
		        item.XML = block.Clone(True)
		        item.Type = XojoKit.ItemTypes.MobileScreen
		        
		        For k As Integer = 0 To block.ChildCount - 1
		          Var node As XmlNode = block.Child(k)
		          Select Case node.Name
		          Case "ObjName"
		            item.Name = node.FirstChild.Value
		            
		          Case "ObjContainerID"
		            item.ParentID = Integer.FromString(node.FirstChild.Value)
		          End Select
		        Next k
		        
		        // Add this item to the project.
		        Self.Items.Add(item)
		        
		      Case "MultiImage"
		        #Pragma Warning "TODO: Parse ImageSets"
		        
		      Case "FileTypes"
		        #Pragma Warning "TODO: Parse FileTypeSets"
		        
		      Case "DesktopToolbar", "Toolbar"
		        #Pragma Warning "TODO: Parse Toolbars"
		        
		      Case "Menu"
		        #Pragma Warning "TODO: Parse MenuBars"
		        
		      Else
		        // We're not interested in these blocks.
		      End Select
		    End If
		  Next i
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21, Description = 4C6F6F7073207468726F756768206974656D2773206368696C6472656E2C2072656D6F76696E6720616E79207468617420617265206D61726B6564206173206578636C756465642E
		Private Sub PurgeExcludedChildren(item As XKItem)
		  /// Loops through item's children, removing any that are marked as excluded.
		  
		  For i As Integer = item.Children.LastIndex DownTo 0
		    Var child As XKItem = item.Children(i)
		    If child.Children.Count > 0 Then
		      PurgeExcludedChildren(child)
		    End If
		    If item.Children(i).IsExcluded Then
		      item.Children.RemoveAt(i)
		    End If
		  Next i
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 52657475726E73205472756520696620606D656D626572602073686F756C64206265206578636C756465642066726F6D20612070726F6A656374206261736564206F6E20606F7074696F6E73602E
		Shared Function ShouldExcludeMember(member As XojoKit.XKMember, options As XojoKit.XKOptions) As Boolean
		  /// Returns True if `member` should be excluded from a project based on `options`.
		  
		  If (options.ExcludePrivate And member.Scope = XojoKit.Scopes.Private_) Or _
		    options.ExcludedMemberTypes.IndexOf(member.MemberType) <> -1 Then
		    Return True
		  Else
		    Return False
		  End If
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21, Description = 44657465726D696E652773207468652074797065206F66206974656D2070617373656420616E6420696E6372656D656E7473207468652070726F6A656374277320696E7465726E616C206974656D207479706520636F756E742070726F706572746965732E
		Private Sub UpdateItemCounts(item As XKItem)
		  /// Determine's the type of item passed and increments the project's internal item type count properties.
		  
		  Select Case item.Type
		  Case XojoKit.ItemTypes.Class_
		    mClassCount = mClassCount + 1
		    
		  Case XojoKit.ItemTypes.Container
		    mContainerCount = mContainerCount + 1
		    
		  Case XojoKit.ItemTypes.FileType_
		    mFileTypeCount = mFileTypeCount + 1
		    
		  Case XojoKit.ItemTypes.ImageSet_
		    mImageSetCount = mImageSetCount + 1
		    
		  Case XojoKit.ItemTypes.Interface_
		    mInterfaceCount = mInterfaceCount + 1
		    
		  Case XojoKit.ItemTypes.MenuBar_
		    mMenuBarCount = mMenuBarCount + 1
		    
		  Case XojoKit.ItemTypes.MobileScreen
		    mScreenCount = mScreenCount + 1
		    
		  Case XojoKit.ItemTypes.Module_
		    mModuleCount = mModuleCount + 1
		    
		  Case XojoKit.ItemTypes.ToolBar_
		    mToolBarCount = mToolBarCount + 1
		    
		  Case XojoKit.ItemTypes.Window_
		    mWindowCount = mWindowCount + 1
		  End Select
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21, Description = 584D4C2070726F6A656374732073746F7265207468652070726F6A656374207479706520617320616E20696E74656765722E20546869732072657475726E732074686174206173206120737472696E672E
		Private Function XMLProjectTypeToString(value As Integer) As String
		  /// XML projects store the project type as an integer. This returns that as a string.
		  
		  Select Case value
		  Case 0
		    Return "Desktop"
		    
		  Case 1
		    Return "Console"
		    
		  Case 2
		    Raise New XKException("Unknown XML project type (" + value.ToString + ").")
		    
		  Case 3
		    // Note that Web 2.0 apps in Xojo Project files are "Web2". In XML projects both Web 1.0 and 
		    // Web 2.0 projects have the same integer value. We'll therefore just return "Web".
		    Return "Web"
		    
		  Case 4
		    Return "iOS"
		    
		  Else
		    Raise New XKException("Unknown XML project type (" + value.ToString + ").")
		  End Select
		  
		End Function
	#tag EndMethod


	#tag Property, Flags = &h0, Description = 54686520617070206275672076657273696F6E2E
		AppBugVersion As Integer
	#tag EndProperty

	#tag Property, Flags = &h0, Description = 54686520617070206D616A6F722076657273696F6E2E
		AppMajorVersion As Integer
	#tag EndProperty

	#tag Property, Flags = &h0, Description = 54686520617070206D696E6F722076657273696F6E2E
		AppMinorVersion As Integer
	#tag EndProperty

	#tag Property, Flags = &h0, Description = 54686520617070206E6F6E2D72656C656173652076657273696F6E2E
		AppNonReleaseVersion As Integer
	#tag EndProperty

	#tag ComputedProperty, Flags = &h0, Description = 52657475726E732074686520746F74616C206E756D626572206F6620636C617373657320696E20746869732070726F6A6563742E20436F6D7075746564206F6E6365206166746572207468652070726F6A6563742069732070617273656420736F20696E657870656E7369766520746F2063616C6C2E
		#tag Getter
			Get
			  Return mClassCount
			  
			  
			End Get
		#tag EndGetter
		ClassCount As Integer
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0, Description = 52657475726E732074686520746F74616C206E756D626572206F6620757365722D7772697474656E206C696E6573206F6620636F646520696E20746869732070726F6A656374206578636C7564696E6720636F6D6D656E74732E20436F6D7075746564206F6E6365206166746572207468652070726F6A6563742069732070617273656420736F20696E657870656E7369766520746F2063616C6C2E
		#tag Getter
			Get
			  Return mCodeLineCount
			  
			End Get
		#tag EndGetter
		CodeLineCount As Integer
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0, Description = 52657475726E732074686520746F74616C206E756D626572206F6620636F6D6D656E747320696E20746869732070726F6A6563742E20436F6D7075746564206F6E6365206166746572207468652070726F6A6563742069732070617273656420736F20696E657870656E7369766520746F2063616C6C2E
		#tag Getter
			Get
			  Return mCommentCount
			  
			End Get
		#tag EndGetter
		CommentCount As Integer
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0, Description = 52657475726E732074686520746F74616C206E756D626572206F6620636F6E7461696E65727320696E20746869732070726F6A6563742E20436F6D7075746564206F6E6365206166746572207468652070726F6A6563742069732070617273656420736F20696E657870656E7369766520746F2063616C6C2E
		#tag Getter
			Get
			  Return mContainerCount
			  
			  
			  
			End Get
		#tag EndGetter
		ContainerCount As Integer
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0, Description = 54727565206966207468652070726F6A65637420636F6E7461696E7320616E792065787465726E616C206974656D732E20436F6D7075746564206F6E6365206166746572207468652070726F6A6563742069732070617273656420736F20696E657870656E7369766520746F2063616C6C2E
		#tag Getter
			Get
			  Return mContainsExternalItems
			End Get
		#tag EndGetter
		ContainsExternalItems As Boolean
	#tag EndComputedProperty

	#tag Property, Flags = &h0, Description = 5468652066696C6520666F726D6174206F66207468652070726F6A656374206D616E69666573742E
		FileFormat As XojoKit.FileFormats = XojoKit.FileFormats.Project
	#tag EndProperty

	#tag ComputedProperty, Flags = &h0, Description = 52657475726E732074686520746F74616C206E756D626572206F662066696C652074797065207365747320696E20746869732070726F6A6563742E20436F6D7075746564206F6E6365206166746572207468652070726F6A6563742069732070617273656420736F20696E657870656E7369766520746F2063616C6C2E
		#tag Getter
			Get
			  Return mFileTypeCount
			  
			  
			End Get
		#tag EndGetter
		FileTypeCount As Integer
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0, Description = 52657475726E732074686520746F74616C206E756D626572206F6620696D616765207365747320696E20746869732070726F6A6563742E20436F6D7075746564206F6E6365206166746572207468652070726F6A6563742069732070617273656420736F20696E657870656E7369766520746F2063616C6C2E
		#tag Getter
			Get
			  Return mImageSetCount
			  
			  
			  
			End Get
		#tag EndGetter
		ImageSetCount As Integer
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0, Description = 52657475726E732074686520746F74616C206E756D626572206F6620696E746572666163657320696E20746869732070726F6A6563742E20436F6D7075746564206F6E6365206166746572207468652070726F6A6563742069732070617273656420736F20696E657870656E7369766520746F2063616C6C2E
		#tag Getter
			Get
			  Return mInterfaceCount
			  
			  
			End Get
		#tag EndGetter
		InterfaceCount As Integer
	#tag EndComputedProperty

	#tag Property, Flags = &h21, Description = 412064696374696F6E617279206D617070696E6720746865204944206F66206974656D73207468617420636F6E7461696E206368696C6472656E20746F207468652061637475616C206974656D2E204B6579203D206974656D2049442028496E7465676572292C2056616C7565203D20584B4974656D2E205573656420647572696E672070617273696E672E
		Private ItemContainers As Dictionary
	#tag EndProperty

	#tag Property, Flags = &h0, Description = 546865206974656D732028636C61737365732C206D6F64756C657320616E6420696E7465726661636573292077697468696E20746869732070726F6A6563742E
		Items() As XojoKit.XKItem
	#tag EndProperty

	#tag Property, Flags = &h0, Description = 54686520586F6A6F2070726F6A656374206D616E69666573742066696C652E
		Manifest As FolderItem
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mClassCount As Integer = 0
	#tag EndProperty

	#tag Property, Flags = &h21, Description = 4261636B732060436F64654C696E65436F756E74602E2054686520746F74616C206E756D626572206F6620757365722D7772697474656E206C696E6573206F6620636F646520696E20746869732070726F6A656374206578636C7564696E6720636F6D6D656E74732E20436F6D7075746564206166746572207468652070726F6A656374206973207061727365642E
		Private mCodeLineCount As Integer = 0
	#tag EndProperty

	#tag Property, Flags = &h21, Description = 4261636B732060436F6D6D656E74436F756E74602E2054686520746F74616C206E756D626572206F6620636F6D6D656E747320696E20746869732070726F6A6563742E20436F6D7075746564206166746572207468652070726F6A656374206973207061727365642E
		Private mCommentCount As Integer = 0
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mContainerCount As Integer = 0
	#tag EndProperty

	#tag Property, Flags = &h21, Description = 54727565206966207468652070726F6A65637420636F6E7461696E7320616E792065787465726E616C206974656D732E20436F6D7075746564206F6E6365206166746572207468652070726F6A6563742069732070617273656420736F20696E657870656E7369766520746F2063616C6C2E
		Private mContainsExternalItems As Boolean = False
	#tag EndProperty

	#tag ComputedProperty, Flags = &h0, Description = 52657475726E732074686520746F74616C206E756D626572206F66206D656E756261727320696E20746869732070726F6A6563742E20436F6D7075746564206F6E6365206166746572207468652070726F6A6563742069732070617273656420736F20696E657870656E7369766520746F2063616C6C2E
		#tag Getter
			Get
			  Return mMenuBarCount
			  
			  
			  
			End Get
		#tag EndGetter
		MenuBarCount As Integer
	#tag EndComputedProperty

	#tag Property, Flags = &h21
		Private mFileTypeCount As Integer = 0
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mImageSetCount As Integer = 0
	#tag EndProperty

	#tag Property, Flags = &h0, Description = 546865206D696E696D756D20726571756972656420586F6A6F204944452076657273696F6E2E
		MinimumIDEVersion As String
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mInterfaceCount As Integer = 0
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mMenuBarCount As Integer = 0
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mModuleCount As Integer = 0
	#tag EndProperty

	#tag ComputedProperty, Flags = &h0, Description = 52657475726E732074686520746F74616C206E756D626572206F66206D6F64756C657320696E20746869732070726F6A6563742E20436F6D7075746564206F6E6365206166746572207468652070726F6A6563742069732070617273656420736F20696E657870656E7369766520746F2063616C6C2E
		#tag Getter
			Get
			  Return mModuleCount
			  
			  
			End Get
		#tag EndGetter
		ModuleCount As Integer
	#tag EndComputedProperty

	#tag Property, Flags = &h21, Description = 54686520227669727475616C2220726F6F74206974656D207468617420636F6E7461696E7320616C6C206F74686572206974656D7320696E207468652070726F6A6563742E
		Private mRoot As XojoKit.XKItem
	#tag EndProperty

	#tag Property, Flags = &h21, Description = 546865206E756D626572206F66204D6F62696C6553637265656E7320696E20746869732070726F6A6563742028694F532070726F6A65637473206F6E6C79292E
		Private mScreenCount As Integer = 0
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mToolBarCount As Integer = 0
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mWindowCount As Integer = 0
	#tag EndProperty

	#tag Property, Flags = &h0, Description = 546865206E616D65206F66207468652070726F6A6563742E
		Name As String
	#tag EndProperty

	#tag Property, Flags = &h0, Description = 546865206170702773204C696E7578206E616D652E
		NameLinux As String
	#tag EndProperty

	#tag Property, Flags = &h0, Description = 546865206170702773206D61634F53206E616D652E
		NameMac As String
	#tag EndProperty

	#tag Property, Flags = &h0, Description = 5468652061707027732057696E646F7773206E616D652E
		NameWindows As String
	#tag EndProperty

	#tag Property, Flags = &h0, Description = 546865206F7074696F6E7320746F20757365207768656E2070617273696E67207468652070726F6A6563742E
		Options As XojoKit.XKOptions
	#tag EndProperty

	#tag Property, Flags = &h0, Description = 5468652076657273696F6E206F662074686520494445207468652070726F6A65637420776173206F726967696E616C6C7920736176656420696E2E
		OriginalIDEVersion As String
	#tag EndProperty

	#tag Property, Flags = &h0, Description = 546865204944452076657273696F6E207468652070726F6A6563742077617320736176656420696E2E
		RBProjectVersion As String
	#tag EndProperty

	#tag ComputedProperty, Flags = &h0, Description = 54686520227669727475616C2220726F6F74206974656D2E20497420636F6E7461696E7320616C6C206F74686572206974656D7320696E207468652070726F6A6563742E
		#tag Getter
			Get
			  If Self.ItemContainers.Lookup(0, Nil) = Nil Then
			    mRoot = New XKItem(Self)
			    mRoot.Type = XojoKit.ItemTypes.Root
			    mRoot.Name = "Project Root"
			    mRoot.ID = 0
			    mRoot.ParentID = -1
			    'Return mRoot
			  Else
			    mRoot = Self.ItemContainers.Value(0)
			    'Return Self.ItemContainers.Value(0)
			  End If
			  
			  Return mRoot
			End Get
		#tag EndGetter
		Root As XojoKit.XKItem
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0, Description = 52657475726E732074686520746F74616C206E756D626572206F662073637265656E7320696E20746869732070726F6A6563742028694F532070726F6A65637473206F6E6C79292E20436F6D7075746564206F6E6365206166746572207468652070726F6A6563742069732070617273656420736F20696E657870656E7369766520746F2063616C6C2E
		#tag Getter
			Get
			  Return mScreenCount
			  
			  
			  
			End Get
		#tag EndGetter
		ScreenCount As Integer
	#tag EndComputedProperty

	#tag Property, Flags = &h0, Description = 5472756520696620746869732070726F6A65637420737570706F727473206461726B206D6F64652E
		SupportsDarkMode As Boolean = False
	#tag EndProperty

	#tag Property, Flags = &h0, Description = 5472756520696620746869732070726F6A65637420737570706F7274732048694450492E
		SupportsHiDPI As Boolean = False
	#tag EndProperty

	#tag ComputedProperty, Flags = &h0, Description = 52657475726E732074686520746F74616C206E756D626572206F6620746F6F6C6261727320696E20746869732070726F6A6563742E20436F6D7075746564206F6E6365206166746572207468652070726F6A6563742069732070617273656420736F20696E657870656E7369766520746F2063616C6C2E
		#tag Getter
			Get
			  Return mToolBarCount
			  
			  
			  
			End Get
		#tag EndGetter
		ToolBarCount As Integer
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0, Description = 54686520746F74616C206E756D626572206F66206C696E6573206F6620636F646520696E207468652070726F6A6563742028696E636C7564696E6720636F6D6D656E7473292E
		#tag Getter
			Get
			  Return mCodeLineCount + mCommentCount
			  
			End Get
		#tag EndGetter
		TotalLineCount As Integer
	#tag EndComputedProperty

	#tag Property, Flags = &h0, Description = 5468652070726F6A65637420747970652028652E672E20224465736B746F7022292E
		Type As String
	#tag EndProperty

	#tag ComputedProperty, Flags = &h0, Description = 52657475726E732074686520746F74616C206E756D626572206F662077696E646F777320696E20746869732070726F6A6563742E20436F6D7075746564206F6E6365206166746572207468652070726F6A6563742069732070617273656420736F20696E657870656E7369766520746F2063616C6C2E
		#tag Getter
			Get
			  Return mWindowCount
			  
			  
			  
			End Get
		#tag EndGetter
		WindowCount As Integer
	#tag EndComputedProperty

	#tag Property, Flags = &h0, Description = 466F7220584D4C2070726F6A656374732C2074686973206973207468652076616C7565206F66207468652060466F726D617456657273696F6E602061747472696275746520696E207468652060524250726F6A65637460206E6F64652E
		XMLProjectFormat As String = "-1"
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
			Name="AppBugVersion"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="AppMajorVersion"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="AppMinorVersion"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="AppNonReleaseVersion"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="MinimumIDEVersion"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="OriginalIDEVersion"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="RBProjectVersion"
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
			Name="XMLProjectFormat"
			Visible=false
			Group="Behavior"
			InitialValue="-1"
			Type="String"
			EditorType="MultiLineEditor"
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
			Name="NameMac"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="NameLinux"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="NameWindows"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="SupportsDarkMode"
			Visible=false
			Group="Behavior"
			InitialValue="False"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="SupportsHiDPI"
			Visible=false
			Group="Behavior"
			InitialValue="False"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="ContainsExternalItems"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="ClassCount"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="ModuleCount"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="InterfaceCount"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="FileTypeCount"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="ImageSetCount"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="WindowCount"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="ToolBarCount"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="MenuBarCount"
			Visible=false
			Group="Behavior"
			InitialValue=""
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
			Name="TotalLineCount"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="ContainerCount"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="FileFormat"
			Visible=false
			Group="Behavior"
			InitialValue="XojoKit.FileFormats.Project"
			Type="XojoKit.FileFormats"
			EditorType="Enum"
			#tag EnumValues
				"0 - Project"
				"1 - Unknown"
				"2 - XML"
				"3 - Window"
			#tag EndEnumValues
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass

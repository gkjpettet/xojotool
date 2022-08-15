#tag BuildAutomation
			Begin BuildStepList Linux
				Begin BuildProjectStep Build
				End
			End
			Begin BuildStepList Mac OS X
				Begin BuildProjectStep Build
				End
				Begin SignProjectStep Sign
				  DeveloperID=
				End
				Begin IDEScriptBuildStep IncrementAppRunCount , AppliesTo = 1, Architecture = 0, Target = 0
					// Increments the `App.RunCount` constant.
					Var value As String = ConstantValue("App.RunCount")
					Var count As Integer = Val(value)
					count = count + 1
					ConstantValue("App.RunCount") = Str(count)
					
				End
			End
			Begin BuildStepList Windows
				Begin BuildProjectStep Build
				End
			End
#tag EndBuildAutomation

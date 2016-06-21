# auto-ipa-packager
This script adds the necessary SwiftSupport to a signed IPA package.  This is in direct response from a rejection from the app store citing "Invalid Swift Support - The SwiftSupport folder is missing. Rebuild your app using the current public (GM) version of Xcode and resubmit it."

If you run your IPA package through this script, it should remedy this issue in a one step process.

#Usage
Simply export your signed IPA from Xcode or Xamarin Studio, and then simply run the script.
```shell
	sh auto_package_ipa.sh /path/to/MyApp.ipa
```
The script will output to MyApp.ipa and the original saved as MyApp-original.ipa.

#Credit
This is a simplification of @bq ipa-packager which you can find here: https://github.com/bq/ipa-packager.  Many thanks!

#Requirements
* XCode 6+
* XCode Command Line Tools
* macOS Mavericks or Higher

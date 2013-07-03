# Build And Release Tool #

Bart is a build and release tool designed to work with
[git](http://git-scm.com) repositories. It is comprised of two
separate scripts, [bart](bart) and [bartbot](bartbot).

## Bart ##

Bart will clone a repository, tag, build, package, and
release. Tags are only pushed back if build and packaging are
successful.

### Theory of operation ###

- Bart first clones the specified repository to a temporary directory.  The temporary directory is created using the `TMPDIR` environment variable.
- Next, bart will source the `.bart` file located in the root of the repository. This file defines how the repository is tagged, built, packaged, and released.
- If asked, bart will generate a tag for the repository by calling `bart_get_tag ()` defined in the `.bart` file. This function should set the `TAG` variable and return 0 on success. Bart tags the repository prior to the build phase using the value in `TAG`.
- The pre-build phase is run by calling `bart_pre_build ()` defined in the `.bart` file. This function should return 0 on success.
- The build phase is run by calling `bart_build ()` defined in the `.bart` file. This function should return 0 on success.
- The post-build phase is run by calling `bart_post_build ()` defined in the `.bart` file. This function should return 0 on success.
- The package phase is run by calling `bart_package ()` defined in the `.bart` file. This function should set the `PACKAGE` variable and return 0 on success. The `PACKAGE` variable specifies the location of the packaging result.
- If everything is successful to this point, the tag is pushed back to the origin.
- If asked, the release phase is run by calling `bart_release ()` defined in the `.bart` file. This function should return 0 on success. The release phase is where you should do something with the package, such as upload it to a server. If the release phase is not run, bart will move the package to the present working directory.

### Usage ###

	bart [OPTIONS] <repository>

### Options ###

	-h, --help      Print usage
	--version       Print version
	--tag           Tag revision if build succeeds
	--settag <>     Use supplied tag instead of generated tag
	--release       Run the release phase of the build
	--branch <>     Specify branch to checkout
	--dotfile <>    Specify .bart file inside of the repository to use
	--extdotfile <> Specify .bart file outside of the repository to use
	--head          Get the current head revision

## Bartbot ##

Bartbot is used to run continuous bart builds automatically. It
uses a project file that defines the repository origin, the branch,
the destination directory for the package, and the last successful
build. This allows it to be easily run from a cron job or LaunchAgent,
and it will only do work when new changes are present on the
configured branch.

### Usage ###

	bartbot [OPTIONS] <project file>

### Options ###

	-h, --help      Print usage
	--version       Print version
	--tag           Tag revision if build succeeds
	--settag <>     Use supplied tag instead of generated tag
	--release       Run the release phase of the build
	--init <repo>   Create a new project file

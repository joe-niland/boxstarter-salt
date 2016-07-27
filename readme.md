Provision-Salt :: BoxStarter package to install Salt on Windows
----------------------------------------------------------------

This BoxStarter packages is a very basic wrapper around bootstrap-salt.ps1. Requires further work to expose config variables or pull them from a config store, etc.

Currently Salt version 2016.3.1 is hard-coded in this package.

Building
==========

If you change anything in tools\ChocolateyInstall.ps1 or Provision-Salt.nuspec you will need to build a new BoxStarter package.

Open a PowerShell console and run the following command from the directory containing Provision-Salt.nuspec:

```
Import-Moodule Boxstarter.Chocolatey
Invoke-BoxStarterBuild -name Provision-Salt
```

This will build the package and save it in your LocalRepo directory as per your BoxStarter configuration:

```
(Get-BoxStarterConfig).LocalRepo
```

You will need BoxStarter installed, which can be done with [Chocolatey](https://chocolatey.org/install):

```
cinst Boxstarter -y
```

If you are using Sublime Text, I've created a [Sublime Build System for BoxStarter](https://github.com/joe-niland/boxstarter-sublime-build).

Usage
========

Once you have a package built you can run it remotely with the following command (from PowerShell console):

```
# Get your domain or machine credentials
$cred = Get-Credential domain\username
# Add -DisableReboots if you don't want any pending reboots to be executed
Install-BoxstarterPackage -ComputerName ServerToBeSalted -PackageName Provision-Salt -Credential $cred -DisableReboots
```
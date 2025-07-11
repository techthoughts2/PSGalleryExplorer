---
external help file: PSGalleryExplorer-help.xml
Module Name: PSGalleryExplorer
online version: https://psgalleryexplorer.readthedocs.io/en/latest/Find-ModuleByCommand/
schema: 2.0.0
---

# Find-ModuleByCommand

## SYNOPSIS

Searches for modules that contain a specific command or cmdlet name.

## SYNTAX

```powershell
Find-ModuleByCommand [-CommandName] <String> [-InsightView]
 [<CommonParameters>]
```

## DESCRIPTION

The Find-ModuleByCommand cmdlet searches for modules on the PowerShell Gallery that contain a specified command or cmdlet name.
The cmdlet returns a list of modules that include the command or cmdlet, along with key metrics and information about the module.
This cmdlet is useful when you need to quickly find a module that includes a particular command or cmdlet, without having to install or download the module first.

## EXAMPLES

### EXAMPLE 1

```powershell
Find-ModuleByCommand -CommandName New-ModuleProject
```

Returns a list of modules that contain the command New-ModuleProject

### EXAMPLE 2

```powershell
Find-ModuleByCommand -CommandName 'Send-TelegramTextMessage'
```

Returns a list of modules that contain the command Send-TelegramTextMessage

### EXAMPLE 3

```powershell
Find-ModuleByCommand -CommandName 'Send-TelegramTextMessage' -InsightView
```

Returns a list of modules that contain the command Send-TelegramTextMessage, with focused community insights about the module

## PARAMETERS

### -CommandName

Specifies the command name to search for

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -InsightView

Output focuses on additional insights available through PSGalleryExplorer.
This includes the module's size and file count, as well as repository metrics like stars, forks, and last repo update date

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutBuffer, -OutVariable, -PipelineVariable, -Verbose, -WarningAction, -WarningVariable, and -ProgressAction. 
For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

### PSGEFormat

## NOTES

Author: Jake Morrison - @jakemorrison - https://www.techthoughts.info/

## RELATED LINKS

[https://psgalleryexplorer.readthedocs.io/en/latest/Find-ModuleByCommand/](https://psgalleryexplorer.readthedocs.io/en/latest/Find-ModuleByCommand/)

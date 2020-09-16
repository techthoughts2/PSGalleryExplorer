---
external help file: PSGalleryExplorer-help.xml
Module Name: PSGalleryExplorer
online version:
schema: 2.0.0
---

# Find-PSGModule

## SYNOPSIS
Finds PowerShell Gallery module(s) that match specified criteria.

## SYNTAX

### GalleryDownloads
```
Find-PSGModule [-ByDownloads] [-ByRandom] [-IncludeCorps] [-IncludeRegulars] [-NumberToReturn <Int32>]
 [<CommonParameters>]
```

### Repo
```
Find-PSGModule [-ByRepoInfo <String>] [-IncludeCorps] [-IncludeRegulars] [-NumberToReturn <Int32>]
 [<CommonParameters>]
```

### Update
```
Find-PSGModule [-ByRecentUpdate <String>] [-IncludeCorps] [-IncludeRegulars] [-NumberToReturn <Int32>]
 [<CommonParameters>]
```

### Names
```
Find-PSGModule [-ByName <String>] [-IncludeCorps] [-IncludeRegulars] [-NumberToReturn <Int32>]
 [<CommonParameters>]
```

### Tags
```
Find-PSGModule [-ByTag <String>] [-IncludeCorps] [-IncludeRegulars] [-NumberToReturn <Int32>]
 [<CommonParameters>]
```

## DESCRIPTION
Searches PowerShell Gallery for modules and their associated project repositories.
Results are returned based on provided criteria.
By default, more common/popular modules and modules made by corporations are excluded.
This is to aid in discovery of other modules.
Popular modules and corporation modules can be included in results by specifying the necessary parameter switches.
35 module results are returned by default unless the NumberToReturn parameter is used.

## EXAMPLES

### EXAMPLE 1
```
Find-PSGModule -ByDownloads
```

Returns up to 35 modules based on number of PowerShell Gallery downloads.

### EXAMPLE 2
```
Find-PSGModule -ByDownloads -IncludeRegulars
```

Returns up to 35 modules based on number of PowerShell Gallery downloads including more popular modules.

### EXAMPLE 3
```
Find-PSGModule -ByDownloads -IncludeCorps -IncludeRegulars -NumberToReturn 50
```

Returns up to 50 modules based on number of PowerShell Gallery downloads including more popular downloads, and modules made by corporations.

### EXAMPLE 4
```
Find-PSGModule -ByRepoInfo StarCount
```

Returns up to 35 modules based on number of stars the project's repository has.

### EXAMPLE 5
```
Find-PSGModule -ByRepoInfo Forks
```

Returns up to 35 modules based on number of forks the project's repository has.

### EXAMPLE 6
```
Find-PSGModule -ByRepoInfo Issues
```

Returns up to 35 modules based on number of issues the project's repository has.

### EXAMPLE 7
```
Find-PSGModule -ByRepoInfo Subscribers
```

Returns up to 35 modules based on number of subscribers the project's repository has.

### EXAMPLE 8
```
Find-PSGModule -ByRecentUpdate GalleryUpdate
```

Returns up to 35 modules based on their most recent PowerShell Gallery update.

### EXAMPLE 9
```
Find-PSGModule -ByRecentUpdate RepoUpdate
```

Returns up to 35 modules based on recent updates to their associated repository.

### EXAMPLE 10
```
Find-PSGModule -ByRandom
```

Returns up to 35 modules randomly

### EXAMPLE 11
```
Find-PSGModule -ByName 'PoshGram'
```

Returns module that equals the provided name, if found.

### EXAMPLE 12
```
Find-PSGModule -ByTag Telegram
```

Returns up to 35 modules that contain the tag: Telegram.

### EXAMPLE 13
```
Find-PSGModule -ByTag Telegram -IncludeCorps -IncludeRegulars -NumberToReturn 100
```

Returns up to 100 modules that contains the tag: Telegram, including more popular modules and modules made by corporations.

### EXAMPLE 14
```
$results = Find-PSGModule -ByRepoInfo Watchers -IncludeCorps -IncludeRegulars -NumberToReturn 40
$results | Format-List
```

Returns up to 40 modules based on number of module project repository watchers.
It includes more popular modules as well as modules made by corporations.
A list of results is displayed.

## PARAMETERS

### -ByDownloads
Find modules by number of PowerShell Gallery Downloads

```yaml
Type: SwitchParameter
Parameter Sets: GalleryDownloads
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -ByRepoInfo
Find modules based on various project repository metrics

```yaml
Type: String
Parameter Sets: Repo
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ByRecentUpdate
Find modules based on recent updated to PowerShell Gallery or associated repository

```yaml
Type: String
Parameter Sets: Update
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ByRandom
Find modules randomly from the PowerShell Gallery

```yaml
Type: SwitchParameter
Parameter Sets: GalleryDownloads
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -ByName
Find module by module name

```yaml
Type: String
Parameter Sets: Names
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ByTag
Find modules by tag

```yaml
Type: String
Parameter Sets: Tags
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -IncludeCorps
Include modules written by corporations in results

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

### -IncludeRegulars
Include modules that are well known in results

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

### -NumberToReturn
Max number of modules to return

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: 35
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable.
For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

### PSGEFormat
## NOTES
Author: Jake Morrison - @jakemorrison - https://techthoughts.info/

## RELATED LINKS

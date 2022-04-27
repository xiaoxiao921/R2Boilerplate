# Use this script to create a ZIP package for uploading to the Thunderstore.
# More info: https://thunderstore.io/package/create/
# Make sure to change the $ModName variable below if you rename/reorganize the project.

$ErrorActionPreference = 'Stop'

$PackageFiles = 'icon.png', 'README.md', 'manifest.json'

$MissingFiles = $PackageFiles | Where-Object { !(Test-Path $_) }
if ($MissingFiles) {
    Write-Host "Can't create a package, because these files are missing: $($MissingFiles -join ', ')" -ForegroundColor Red
    Write-Host 'More info about package requirements: https://thunderstore.io/package/create/docs/'
    exit 1
}

$ModName = 'ExamplePlugin'
$OutputPath = 'output'
$ZipPath = "$(Get-Location)\$ModName.zip"

dotnet build --no-incremental --configuration Release --output $OutputPath
if (!$?) {
    exit 1
}

Compress-Archive ($PackageFiles += "$OutputPath\$ModName.dll") -DestinationPath $ZipPath -Force

Remove-Item $OutputPath -Recurse

Write-Host "`nPackage is successfully created at: $ZipPath" -ForegroundColor Green

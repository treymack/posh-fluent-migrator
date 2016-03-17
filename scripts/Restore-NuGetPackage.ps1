Push-Location (Join-Path $PSScriptRoot "..")
    .\.nuget\NuGet.exe update -self
    .\.nuget\NuGet.exe restore .\everything.sln
Pop-Location

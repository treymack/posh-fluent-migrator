param (
    [ValidateSet("project-name", "project-name2")]
    [string]$DBName = ""
)

$migrationProjects = Get-Content -Raw (Join-Path $PSScriptRoot "MigrationProjects.json") | ConvertFrom-Json
$migrationProjects | ForEach-Object {
    $_ | Add-Member ShortName $_.Name
    $_ | Add-Member LocalDatabaseName "Database.$($_.Name)"
    $_ | Add-Member ProjectName "$($_.Name).Migrations"
    $_ | Add-Member ProjectPath ".\src\db\$($_.Name).Migrations\$($_.Name).Migrations.csproj"
    $_ | Add-Member ProjectAssemblyTargetPath ".\src\db\$($_.Name).Migrations\bin\Release\$($_.Name).Migrations.dll"
    $_ | Add-Member LocalDatabaseConnectionString "Data Source=.;Initial Catalog=Database.$($_.Name);Integrated Security=SSPI;"
}
if ($DBName -ne "") {
    $migrationProjects = $migrationProjects | Where-Object { $_.Name -eq $DBName }
}
$migrationProjects
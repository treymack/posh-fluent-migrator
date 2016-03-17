param (
    [ValidateSet("project-name", "project-name2")]
    [string]$DbName = "Portal",
    [ValidateSet("Migration", "AutoReversingMigration", "AutoScriptMigration", "ForwardOnlyMigration")]
    [string]$MigrationType = "AutoReversingMigration",
    [string]$MigrationName = "MigrationName"
)

$now = Get-Date
$migrationVersion = $now.ToString("yyyyMMddhhmmss")

Switch ($migrationType) {
#################################
    "AutoReversingMigration" {
        $template = @"
using System;
using FluentMigrator;

namespace $dbName.Migrations
{
    [Migration($migrationVersion)]
    public class $migrationName : AutoReversingMigration
    {
        public override void Up()
        {
            throw new NotImplementedException();
        }
    }
}
"@;
    }
#################################
    "ForwardOnlyMigration" {
        $template = @"
using System;
using FluentMigrator;

namespace $dbName.Migrations
{
    [Migration($migrationVersion)]
    public class $migrationName : ForwardOnlyMigration
    {
        public override void Up()
        {
            throw new NotImplementedException();
        }
    }
}
"@;
#################################
    }
    Default {
        raise "$migrationType Not Implemented"
    }
}

$filePath = Join-Path $PSScriptRoot "..\src\db\$dbName.Migrations\$($now.ToString("yyyy"))\$($now.ToString("MM"))\$($migrationVersion)_$migrationName.cs"

New-Item -ItemType File -Force -Path $filePath
$template | Out-File $filePath -Encoding utf8
Write-Host "Migration written to $filePath. Don't forget to include it in the project in VS" -BackgroundColor DarkGreen -ForegroundColor White
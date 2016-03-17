# posh-fluent-migrator
PowerShell scripts for managing FluentMigrator projects

The scripts assume a specific project structure. Change Get-MigrationProject.ps1 as needed to match yours.

  src
    db
      project-name.Migrations
      
You'll also need to change Migration-Projects.json to reflect the names of your migration projects.

Usage:

Initial Creation
``` powershell
.\scripts\Get-MigrationProject.ps1 | .\scripts\Invoke-MsBuild.ps1 | .\scripts\Create-LocalDatabase.ps1 -DropDatabaseIfExists | .\scripts\Migrate-LocalDatabase.ps1
```

Testing Latest Migration and Rollback in `project-name`
``` powershell
.\scripts\Get-MigrationProject.ps1 project-name | .\scripts\Invoke-MsBuild.ps1 | .\scripts\Migrate-LocalDatabase.ps1 | .\scripts\Migrate-LocalDatabase.ps1 -Rollback | .\scripts\Migrate-LocalDatabase.ps1
```

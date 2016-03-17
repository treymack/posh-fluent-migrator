[CmdletBinding()]
param (
    [Parameter(Mandatory=$true, ValueFromPipelineByPropertyName=$true)]
    $ProjectPath,
    [ValidateSet("Debug Release")]
    $Configuration = "Release"
)

process {
    $MsBuild = 'C:\Program Files (x86)\MSBuild\14.0\Bin\MSBuild.exe'
    $process = Start-Process $MsBuild "$ProjectPath /p:Configuration=$Configuration" -NoNewWindow -Wait -ErrorAction Stop -PassThru
    if ($process.ExitCode -ne 0) {
        throw "FAILED: $MsBuild $ProjectPath /p:Configuration=$Configuration"
    }
    return $_
}

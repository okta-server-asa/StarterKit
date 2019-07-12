# Install ScaleFT Server Tools

# Write sftd config file with a CanonicalName set

function Get-URL-With-Authenticode(){
    param(
        [Parameter(Mandatory=$true)][string]$url,
        [Parameter(Mandatory=$true)][string]$pinnedCertId,
        [Parameter(Mandatory=$true)][string]$output
    )
    process{
        $baseDir = Split-Path -Parent -Path $output

        if (!(Test-Path "$output")) {
            echo "Downloading $url to $output"
            New-Item -force -path $baseDir -type directory
            Invoke-WebRequest -UserAgent "ScaleFT/PS1-0.1.0" -UseBasicParsing -TimeoutSec 30 -Uri $url -OutFile $output
        } else {
            echo "Existing $output found"
        }

        $sig = Get-AuthenticodeSignature $output

        if ($sig.Status -ne "Valid") {
            echo "error: signature for $($output) is invalid: $($sig.Status) from $($sig.SignerCertificate.ToString())"
            throw "error: signature for $($output) is invalid: $($sig.Status) from $($sig.SignerCertificate.ToString())"
        }

        if ($sig.SignerCertificate.GetCertHashString() -ne $pinnedCertId) {
            echo "error: signature for $($output) is from wrong certificate: $($sig.SignerCertificate.GetCertHashString()) from $($sig.SignerCertificate.ToString())"
            throw "error: signature for $($output) is from wrong certificate: $($sig.SignerCertificate.GetCertHashString()) from $($sig.SignerCertificate.ToString())"
        }

        echo "$($output) is signed by ScaleFT"
    }
}

function Stop-ScaleFTService(){
    $installed = [bool](Get-Service | Where-Object Name -eq "scaleft-server-tools")
    if ($installed -eq $true) {
        echo "Stoping Service scaleft-server-tools"
        Stop-Service -Name "scaleft-server-tools"
        return $true
    }
    return $false
}

function Start-ScaleFTService(){
    $installed = [bool](Get-Service | Where-Object Name -eq "scaleft-server-tools")
    if ($installed -eq $true) {
        echo "Starting Service scaleft-server-tools"
        Start-Service -Name "scaleft-server-tools"
        return $true
    }
    return $false
}



function Install-ScaleFTServerTools(){
    param(
        [ValidateSet("stable","testing")]
        [Parameter(Mandatory=$false)][string]$ReleaseChannel = "stable",

        [Parameter(Mandatory=$false)][string]$EnrollmentToken,

        [Parameter(Mandatory=$false)][string]$InstanceURL,

        [Parameter(Mandatory=$false)][string]$ToolsVersion,

        [Parameter(Mandatory=$false)][string]$CanonicalName
    )
    process{
        $ErrorActionPreference = "Stop";

        # ScaleFT Authenticode Signing Certificate: [Not After] 1/25/2018 4:00:00 AM
        $pinnedCertId = "d8b60e6457c0c67113ab0a2a5f66eccc63d9ec4d"
        $installerURL = ""
        if ($PSBoundParameters.ContainsKey("ToolsVersion")) {
            if ($ReleaseChannel -eq "stable") {
                $installerURL = "https://dist.scaleft.com/server-tools/windows/v$($ToolsVersion)/ScaleFT-Server-Tools-$($ToolsVersion).msi"
            } else {
                $installerURL = "https://dist-$($ReleaseChannel).scaleft.com/server-tools/windows/v$($ToolsVersion)/ScaleFT-Server-Tools-$($ToolsVersion).msi"
            }
        } else {
            if ($ReleaseChannel -eq "stable") {
                $installerURL = "https://dist.scaleft.com/server-tools/windows/latest/ScaleFT-Server-Tools-latest.msi"
            } else {
                throw "error: When -ReleaseChannel is set to non-stable, an exact version to install must be supplied."
            }
        }

        # Select Local System User, where the ScaleFT Server Agent Runs
        $systemprofile = (Get-WmiObject win32_userprofile  | where-object sid -eq "S-1-5-18" | select -ExpandProperty localpath)
        $stateDir = Join-Path $systemprofile -ChildPath 'AppData' | Join-Path -ChildPath "Local" | Join-Path -ChildPath "ScaleFT"

        if ($PSBoundParameters.ContainsKey("EnrollmentToken")) {
            $tokenPath = Join-Path $stateDir -ChildPath "enrollment.token"
            New-Item -ItemType directory -Path $stateDir -force
            $EnrollmentToken | Out-File $tokenPath -Encoding "ASCII" -Force
        }

        if ($PSBoundParameters.ContainsKey("InstanceURL")) {
            $configPath = Join-Path $stateDir -ChildPath "sftd.yaml"
            New-Item -ItemType directory -Path $stateDir -force
            "InitialURL: $($InstanceURL)"  | Out-File $configPath -Encoding "ASCII" -Force
        }

        if ($PSBoundParameters.ContainsKey("CanonicalName")) {
            $configPath = Join-Path $stateDir -ChildPath "sftd.yaml"
            New-Item -ItemType directory -Path $stateDir -force
            "CanonicalName: $($CanonicalName)"  | Out-File $configPath -Append -Encoding "ASCII" -Force
        }

        $msiPath = [System.IO.Path]::ChangeExtension([System.IO.Path]::GetTempFileName(), '.msi')
        $msiLog = [System.IO.Path]::ChangeExtension($msiPath, '.log')

        Get-URL-With-Authenticode -url $installerURL -pinnedCertId $pinnedCertId -output $msiPath

        $stopped = Stop-ScaleFTService

        trap {
            if ($stopped -eq $true) {
                Start-ScaleFTService
            }
            break
        }

        echo "Starting msiexec on $($msiPath)"
        echo "MSI Log path: $($msiLog)"

        $status = Start-Process -FilePath msiexec -ArgumentList /i,$msiPath,/qn,/L*V!,$msiLog  -Wait -PassThru

        if ($status.ExitCode -ne 0) {
	        Start-ScaleFTService
            throw "msiexec failed with exit code: $($status.ExitCode) Log: $($msiLog)"
        }

        echo "Removing $($msiPath)"
        Remove-Item -Force $msiPath

        Start-ScaleFTService
    }
}

Install-ScaleFTServerTools -ToolsVersion "${sftd_version}" -EnrollmentToken "${enrollment_token}" -ReleaseChannel "testing" -CanonicalName "${canonical_name}"



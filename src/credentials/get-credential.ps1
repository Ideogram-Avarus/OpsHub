param(
    [Parameter(Mandatory = $true)]
    [string]$Target
)

Add-Type -Path "$PSScriptRoot\CredentialManager.cs"

$credentialPtr = [IntPtr]::Zero

$success = [CredentialManager]::CredRead(
    $Target,
    1, # CRED_TYPE_GENERIC
    0,
    [ref]$credentialPtr
)

if (-not $success) {
    $errorCode = [Runtime.InteropServices.Marshal]::GetLastWin32Error()
    throw "Could not retrieve credential '$Target'. Windows error: $errorCode"
}

try {
    $credential = [Runtime.InteropServices.Marshal]::PtrToStructure(
        $credentialPtr,
        [type][CredentialManager+CREDENTIAL]
    )

    $username = [Runtime.InteropServices.Marshal]::PtrToStringUni(
        $credential.UserName
    )

    $bytes = New-Object byte[] $credential.CredentialBlobSize

    [Runtime.InteropServices.Marshal]::Copy(
        $credential.CredentialBlob,
        $bytes,
        0,
        $credential.CredentialBlobSize
    )

    $password = [System.Text.Encoding]::Unicode.GetString($bytes)

    [PSCustomObject]@{
        Username = $username
        Password = $password
    }
}
finally {
    [CredentialManager]::CredFree($credentialPtr)
}
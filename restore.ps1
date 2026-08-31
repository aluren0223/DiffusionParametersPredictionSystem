# 将分卷合并为完整压缩包并解压，得到可运行的完整程序目录
# 用法: powershell -ExecutionPolicy Bypass -File restore.ps1
$here = $PSScriptRoot
$parts = Get-ChildItem -LiteralPath $here -Filter "DiffusionParametersPredictionSystem.zip.part*" | Sort-Object Name
if ($parts.Count -lt 2) { Write-Host "找不到完整分卷!"; exit 1 }
$zip = Join-Path $here "DiffusionParametersPredictionSystem.zip"
$out = [System.IO.File]::Create($zip)
try {
    foreach ($p in $parts) {
        $in = [System.IO.File]::OpenRead($p.FullName)
        try { $in.CopyTo($out) } finally { $in.Close() }
    }
} finally { $out.Close() }
Write-Host "已合并: $zip"
Expand-Archive -LiteralPath $zip -DestinationPath (Join-Path $here "Release") -Force
Remove-Item -LiteralPath $zip
Write-Host "已解压到 Release 目录"

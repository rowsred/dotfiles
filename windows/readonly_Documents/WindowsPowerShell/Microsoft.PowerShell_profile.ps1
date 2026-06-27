Invoke-Expression (&starship init powershell)
$coreutils = @(
    'basename', 'cat', 'chmod', 'comm', 'cp', 'cut', 'date', 'dirname', 
    'echo', 'env', 'expr', 'false', 'fold', 'head', 'id', 'install', 
    'join', 'ln', 'ls', 'md5sum', 'mkdir', 'msysmnt', 'mv', 'od', 
    'paste', 'printf', 'ps', 'pwd', 'rm', 'rmdir', 'sleep', 'sort', 
    'split', 'stty', 'tail', 'tee', 'touch', 'tr', 'true', 'uname', 
    'uniq', 'wc'
)

foreach ($cmd in $coreutils) {
    if (Get-Alias -Name $cmd -ErrorAction SilentlyContinue) {
        Remove-Item "alias:$cmd" -ErrorAction SilentlyContinue
    }
}

$env:XDG_DATA_HOME = ($env:XDG_DATA_HOME, "$env:APPDATA", 1 -ne $null)[0]
$env:XDG_CONFIG_HOME = ($env:XDG_CONFIG_HOME, "$LOCALAPPDATA", 1 -ne $null)[0]
$env:XDG_CACHE_HOME = ($env:XDG_CACHE_HOME, "$TEMP", 1 -ne $null)[0]

$env:UFOVIM_RUNTIME_DIR = ($env:UFOVIM_RUNTIME_DIR, "$env:XDG_DATA_HOME\ufovim", 1 -ne $null)[0]
$env:UFOVIM_CONFIG_DIR = ($env:UFOVIM_CONFIG_DIR, "$env:XDG_CONFIG_HOME\ufovim", 1 -ne $null)[0]
$env:UFOVIM_CACHE_DIR = ($env:UFOVIM_CACHE_DIR, "$env:XDG_CACHE_HOME\ufovim", 1 -ne $null)[0]

nvim -u "$env:UFOVIM_RUNTIME_DIR\ufovim\init.lua"

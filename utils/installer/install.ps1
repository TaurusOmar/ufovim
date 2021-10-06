$ErrorActionPreference = "Stop" # exit when command fails

# set script variables
$LV_BRANCH = ($LV_BRANCH, "rolling", 1 -ne $null)[0]
$LV_REMOTE = ($LV_REMOTE, "taurusomar/ufovim.git", 1 -ne $null)[0]
$INSTALL_PREFIX = ($INSTALL_PREFIX, "$HOME\.local", 1 -ne $null)[0]

$env:XDG_DATA_HOME = ($env:XDG_DATA_HOME, "$env:APPDATA", 1 -ne $null)[0]
$env:XDG_CONFIG_HOME = ($env:XDG_CONFIG_HOME, "$LOCALAPPDATA", 1 -ne $null)[0]
$env:XDG_CACHE_HOME = ($env:XDG_CACHE_HOME, "$TEMP", 1 -ne $null)[0]
$env:UFOVIM_RUNTIME_DIR = ($env:UFOVIM_RUNTIME_DIR, "$env:XDG_DATA_HOME\ufovim", 1 -ne $null)[0]
$env:UFOVIM_CONFIG_DIR = ($env:UFOVIM_CONFIG_DIR, "$env:XDG_CONFIG_HOME\ufovim", 1 -ne $null)[0]
$env:UFOVIM_CACHE_DIR = ($env:UFOVIM_CACHE_DIR, "$env:XDG_CACHE_HOME\ufovim", 1 -ne $null)[0]


$__ufovim_dirs = (
    "$env:UFOVIM_CONFIG_DIR",
    "$env:UFOVIM_RUNTIME_DIR",
    "$env:UFOVIM_CACHE_DIR"
)

function main($cliargs) {
    Write-Output "  

        __            _           
 /\ /\ / _| ___/\   /(_)_ __ ___  
/ / \ \ |_ / _ \ \ / / | '_ ` _ \ 
\ \_/ /  _| (_) \ V /| | | | | | |
 \___/|_|  \___/ \_/ |_|_| |_| |_|
                                  
  
  "
  
    __add_separator "80"
  
    # skip this in a Github workflow
    if ( $null -eq "$GITHUB_ACTIONS" ) {
        install_packer
        setup_shim
        exit
    }

    __add_separator "80"

    check_system_deps

    Write-Output "Would you like to check ufovim's NodeJS dependencies?"
    $answer = Read-Host "[y]es or [n]o (default: no) "
    if ("$answer" -eq "y" -or "$answer" -eq "Y") {
        install_nodejs_deps
    } 

    Write-Output "Would you like to check ufovim's Python dependencies?"
    $answer = Read-Host "[y]es or [n]o (default: no) "
    if ("$answer" -eq "y" -or "$answer" -eq "Y") {
        install_python_deps
    } 

    __add_separator "80"

    Write-Output "Backing up old ufovim configuration"
    backup_old_config

    __add_separator "80" 
  
    if ($cliargs.Contains("--overwrite")) {
        Write-Output "!!Warning!! -> Removing all ufovim related config because of the --overwrite flag"
        $answer = Read-Host "Would you like to continue? [y]es or [n]o "
        if ("$answer" -ne "y" -and "$answer" -ne "Y") {
            exit 1
        } 
		
        foreach ($dir in $__ufovim_dirs) {
            if (Test-Path "$dir") {
                Remove-Item -Force -Recurse "$dir"
            }
        }
    }
  
    if (Test-Path "$env:UFOVIM_RUNTIME_DIR\site\pack\packer\start\packer.nvim") {
        Write-Output "Packer already installed"
    }
    else {
        install_packer
    }
  
    __add_separator "80"
  
    if (Test-Path "$env:UFOVIM_RUNTIME_DIR\ufovim\init.lua" ) {
        Write-Output "Updating ufovim"
        update_ufovim
    }
    else {
        if ($cliargs.Contains("--testing")) {
            copy_local_ufovim_repository
        }
        else {
            clone_ufovim
        }
        setup_ufovim
    }
  
    __add_separator "80"
}

function print_missing_dep_msg($dep) {
    Write-Output "[ERROR]: Unable to find dependency [$dep]"
    Write-Output "Please install it first and re-run the installer. Try: $RECOMMEND_INSTALL $dep"
}

function install_system_package($dep) {
    if (Get-Command -Name "winget" -ErrorAction SilentlyContinue) {
        Write-Output "[INFO]: Attempting to install dependency [$dep] with winget"
        $install_cmd = "winget install --interactive"
    }
    elseif (Get-Command -Name "scoop" -ErrorAction SilentlyContinue) {
        Write-Output "[INFO]: Attempting to install dependency [$dep] with scoop"
        # TODO: check if it's fine to not run it with --global
        $install_cmd = "scoop install"
    }
    else {
        print_missing_dep_msg "$dep"
        exit 1
    }

    try {
        Invoke-Command $install_cmd $dep -ErrorAction Stop
    }
    catch {
        print_missing_dep_msg "$dep"
        exit 1
    }
}

function check_system_dep($dep) {
    try { 
        Get-Command -Name $dep -ErrorAction Stop | Out-Null 
    }
    catch { 
        install_system_package "$dep"
    }
}

function check_system_deps() {
    Write-Output "[INFO]: Checking dependencies.."
    check_system_dep "git"
    check_system_dep "nvim"
	
}

function install_nodejs_deps() {
    try {
        check_system_dep "node"
        Invoke-Command npm install -g neovim tree-sitter-cli  -ErrorAction Break
    }
    catch {
        print_missing_dep_msg "$dep"
    }
}

function install_python_deps() {
    try {
        check_system_dep "pip"
        Invoke-Command python -m pip install --user pynvim -ErrorAction Break
    }
    catch {
        print_missing_dep_msg "$dep"
    }
}

function backup_old_config() {
    foreach ($dir in $__ufovim_dirs) {
        # we create an empty folder for subsequent commands \
        # that require an existing directory	 
        if ( Test-Path "$dir") {
            New-Item "$dir.bak" -ItemType Directory -Force
            Copy-Item -Recurse "$dir\*" "$dir.bak\."
        }
    }

    Write-Output "Backup operation complete"
}


function install_packer() {
    Invoke-Command -ErrorAction Stop -ScriptBlock { git clone --progress --depth 1 "https://github.com/wbthomason/packer.nvim" "$env:UFOVIM_RUNTIME_DIR\site\pack\packer\start\packer.nvim" }
}
  
function copy_local_ufovim_repository() {
    Write-Output "Copy local ufovim configuration"
    Copy-Item -Path "$((Get-Item $PWD).Parent.Parent.FullName)" -Destination "$env:UFOVIM_RUNTIME_DIR/ufovim" -Recurse
}

function clone_ufovim() {
    Write-Output "Cloning ufovim configuration"
    try {
        Invoke-Command -ErrorAction Stop -ScriptBlock { git clone --progress --branch "$LV_BRANCH" --depth 1 "https://github.com/$LV_REMOTE" "$env:UFOVIM_RUNTIME_DIR/ufovim" } 
    }
    catch {
        Write-Output "Failed to clone repository. Installation failed."
        exit 1		
    }
}

function setup_shim() {
    if ((Test-Path "$INSTALL_PREFIX\bin") -eq $false) {
        New-Item "$INSTALL_PREFIX\bin" -ItemType Directory
    }
    Copy-Item "$env:UFOVIM_RUNTIME_DIR\ufovim\utils\bin\ufovim.ps1" -Destination "$INSTALL_PREFIX\bin\ufovim.ps1" -Force
}

function setup_ufovim() {
    Write-Output "Installing ufovim shim"
  
    setup_shim
  
    Write-Output "Preparing Packer setup"

    if ((Test-Path "$env:UFOVIM_CONFIG_DIR") -eq $false) {
        New-Item "$env:UFOVIM_CONFIG_DIR" -ItemType Directory
    }

    Copy-Item "$env:UFOVIM_RUNTIME_DIR\ufovim\utils\installer\config.example-no-ts.lua" `
        "$env:UFOVIM_CONFIG_DIR\config.lua"
  
	Write-Output "Packer setup complete"
	
	__add_separator "80"

	Copy-Item "$env:UFOVIM_RUNTIME_DIR\ufovim\utils\installer\config.example.lua" "$env:UFOVIM_CONFIG_DIR\config.lua"
  
	$answer = Read-Host $(`
	"Would you like to create an alias inside your Powershell profile?`n" +`
	"(This enables you to start ufovim with the command 'ufovim') [y]es or [n]o (default: no)" )
	if ("$answer" -eq "y" -and "$answer" -eq "Y") {
		create_alias
	} 

	__add_separator "80"

    Write-Output "Thank you for installing ufovim!!"
    Write-Output "You can start it by running: $INSTALL_PREFIX\bin\ufovim.ps1"
    Write-Output "Do not forget to use a font with glyphs (icons) support [https://github.com/ryanoasis/nerd-fonts]"
}


function update_ufovim() {
    try {
        Invoke-Command git -C "$env:UFOVIM_RUNTIME_DIR/ufovim" status -uno
    }
    catch {
        git -C "$env:UFOVIM_RUNTIME_DIR/ufovim" pull --ff-only --progress -or
        Write-Output "Unable to guarantee data integrity while updating. Please do that manually instead."
        exit 1
    }
    Write-Output "Your ufovim installation is now up to date!"
}

function __add_separator($div_width) {
    "-" * $div_width
    Write-Output ""
}

function create_alias {
	if($null -eq $(Get-Alias | Select-String "ufovim")){
		Add-Content -Path $PROFILE -Value $(-join @('Set-Alias ufovim "', "$INSTALL_PREFIX", '\bin\ufovim.ps1"'))
		
		Write-Output ""
		Write-Host 'To use the new alias in this window reload your profile with ". $PROFILE".' -ForegroundColor Yellow

	}else {
		Write-Output "Alias is already set and will not be reset."
	}
}

main "$args"


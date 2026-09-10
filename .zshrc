# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH

# Path to your Oh My Zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time Oh My Zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="robbyrussell"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
# zstyle ':omz:update' mode auto      # update automatically without asking
# zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line to change how often to auto-update (in days).
# zstyle ':omz:update' frequency 13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
  git
  zsh-autosuggestions
  zsh-syntax-highlighting
)

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='nvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch $(uname -m)"

# Set personal aliases, overriding those provided by Oh My Zsh libs,
# plugins, and themes. Aliases can be placed here, though Oh My Zsh
# users are encouraged to define aliases within a top-level file in
# the $ZSH_CUSTOM folder, with .zsh extension. Examples:
# - $ZSH_CUSTOM/aliases.zsh
# - $ZSH_CUSTOM/macos.zsh
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

# config to restart docker 
dock() {
    case "$1" in
        on|start)
            echo "Starting Docker..."
            sudo systemctl start docker.socket docker.service
            ;;
        off|stop)
            echo "Stopping Docker..."
            sudo systemctl stop docker.service docker.socket
            ;;
        status)
            systemctl status docker.service
            ;;
        restart)
            echo "Restarting Docker..."
            sudo systemctl restart docker.service
            ;;
        run)
          echo "Running docker.."
          docker compose up -d --build
          ;;
        show)
          docker ps
         ;;
        delete|drop)
         docker compose down -v 
         ;;
         
        # laravel

        fresh-seed)
         docker compose exec app php artisan migrate:fresh --seed
         ;; 
        *)
        echo "Usage: dock {on|off|status|restart|delete|drop|run|show}"
          ;;
    esac
}

source /usr/share/nvm/init-nvm.sh

# config to make underline 
kitty-reload() {
    kill -SIGUSR1 $(pidof kitty)
}

# make cursor underline 
function zle-line-init() {
    echo -ne "\e[4 q"
}
zle -N zle-line-init

way(){
  echo "reload config waybar"
  killall -9 waybar cava sed 2>/dev/null; waybar > /dev/null 2>&1 &
}

swaync() {
  case "$1" in 
    restart)
      echo "Restarting swaync..."
      killall -q swaync
      sleep 0.2
      command swaync &>/dev/null &
      ;;
    send-notif)
      echo "send notification.."
      notify-send "SwayNc" "Testing Notfication"
      ;;
      *)
      command swaync "$@"
      ;;
  esac
}

# reload sddm
sddm-preview() {
    if [[ -z "$1" ]]; then
        echo "Usage: sddm-preview <theme-name> [-p]"
        return 1
    fi

    local theme_name="$1"
    local theme

    if [[ "$2" == "-p" ]]; then
        theme="/usr/share/sddm/themes/$theme_name"
    else
        theme="$HOME/.config/sddm/themes/$theme_name"
    fi

    if [[ ! -d "$theme" ]]; then
        echo "Theme not found: $theme"
        return 1
    fi

    if [[ ! -f "$theme/Main.qml" ]]; then
        echo "Main.qml not found: $theme"
        return 1
    fi

    echo "Previewing: $theme"

    sddm-greeter-qt6 --test-mode --theme "$theme"
}

sddm-info() {
    local component="$1"
    local base="/usr/lib/qt6/qml/SddmComponents"

    if [[ -z "$component" ]]; then
        echo "Usage: sddm-info <Component>"
        echo
        echo "Available components:"
        find "$base" -maxdepth 1 -name "*.qml" \
            -printf '%f\n' |
            sed 's/\.qml$//' |
            sort
        return 1
    fi

    # Case-insensitive component lookup
    local file
    file=$(find "$base" -maxdepth 1 -type f -iname "${component}.qml" | head -n 1)

    if [[ -z "$file" ]]; then
        echo "Component not found: $component"
        echo

        local matches
        matches=$(find "$base" -maxdepth 1 -type f \
            -iname "*${component}*.qml" \
            -printf '%f\n')

        if [[ -n "$matches" ]]; then
            echo "Did you mean:"
            echo "$matches"
        fi

        return 1
    fi

    local current="$file"
    local level=0

    echo
    echo "=== SDDM Component ==="
    echo
    echo "Requested:"
    echo "  $component"
    echo
    echo "Source:"
    echo "  $file"

    echo
    echo "=== Inheritance ==="

    while [[ -f "$current" ]]; do
        local name
        name=$(basename "$current" .qml)

        # Cari deklarasi root:
        # Rectangle {
        # Item {
        # Image {
        # TextBox {
        local parent
        parent=$(grep -m1 -E '^[[:space:]]*[A-Za-z_][A-Za-z0-9_]*[[:space:]]*\{' "$current" |
            sed -E 's/^[[:space:]]*([A-Za-z_][A-Za-z0-9_]*)[[:space:]]*\{.*/\1/')

        if [[ "$level" -eq 0 ]]; then
            echo "  $name"
        else
            echo "    ↳ $name"
        fi

        # Coba cari QML file parent di SddmComponents
        local parent_file=""

        if [[ -n "$parent" ]]; then
            parent_file=$(find "$base" -maxdepth 1 -type f \
                -iname "${parent}.qml" | head -n 1)
        fi

        if [[ -n "$parent_file" ]]; then
            current="$parent_file"
            ((level++))
        else
            # Parent kemungkinan Qt built-in:
            # Item, Rectangle, Image, Text, etc.
            if [[ -n "$parent" ]]; then
                echo "    ↳ $parent (Qt)"
            fi
            break
        fi
    done

    echo
    echo "=== Properties ==="

    current="$file"
    level=0

    while [[ -f "$current" ]]; do
        local name
        name=$(basename "$current" .qml)

        echo
        if [[ "$level" -eq 0 ]]; then
            echo "[$name]"
        else
            echo "[$name - inherited]"
        fi

        local props
        props=$(grep -nE '^[[:space:]]*property ' "$current")

        if [[ -n "$props" ]]; then
            echo "$props" | sed 's/^/  /'
        else
            echo "  None"
        fi

        local parent
        parent=$(grep -m1 -E '^[[:space:]]*[A-Za-z_][A-Za-z0-9_]*[[:space:]]*\{' "$current" |
            sed -E 's/^[[:space:]]*([A-Za-z_][A-Za-z0-9_]*)[[:space:]]*\{.*/\1/')

        local parent_file=""

        if [[ -n "$parent" ]]; then
            parent_file=$(find "$base" -maxdepth 1 -type f \
                -iname "${parent}.qml" | head -n 1)
        fi

        if [[ -n "$parent_file" ]]; then
            current="$parent_file"
            ((level++))
        else
            break
        fi
    done

    echo
    echo "=== Signals ==="

    local signals
    signals=$(grep -nE '^[[:space:]]*signal ' "$file")

    if [[ -n "$signals" ]]; then
        echo "$signals" | sed 's/^/  /'
    else
        echo "  None"
    fi

    echo
    echo "=== Functions ==="

    local functions
    functions=$(grep -nE '^[[:space:]]*function ' "$file")

    if [[ -n "$functions" ]]; then
        echo "$functions" | sed 's/^/  /'
    else
        echo "  None"
    fi

    echo
}

# Added by Antigravity CLI installer
export PATH="/home/udin/.local/bin:$PATH"

# ─── Waybar Countdown Timer ───────────────────────────────────────────────────
# Usage:
#   timer 25m          → set timer 25 menit
#   timer 1h           → set timer 1 jam
#   timer 1h30m        → set timer 1 jam 30 menit
#   timer 90           → set timer 90 detik
#   timer 25m "Kerja"  → set timer dengan label
#   timer cancel       → batalkan timer
#   timer status       → cek sisa waktu

timer() {
    local STATE="$HOME/.cache/waybar-timer.json"
    local NOTIF="$HOME/.cache/waybar-timer.notified"

    # Cancel
    if [[ "$1" == "cancel" || "$1" == "stop" || "$1" == "reset" ]]; then
        rm -f "$STATE" "$NOTIF"
        echo "⏹ Timer dibatalkan."
        return 0
    fi

    # Status
    if [[ "$1" == "status" ]]; then
        if [[ ! -f "$STATE" ]]; then
            echo "Tidak ada timer aktif."
            return 0
        fi
        local END=$(jq -r '.end' "$STATE")
        local LABEL=$(jq -r '.label // ""' "$STATE")
        local NOW=$(date +%s)
        local REMAINING=$((END - NOW))
        if [[ $REMAINING -le 0 ]]; then
            echo "⏰ Timer sudah selesai${LABEL:+: $LABEL}"
        else
            local H=$((REMAINING / 3600))
            local M=$(( (REMAINING % 3600) / 60 ))
            local S=$((REMAINING % 60))
            echo "⏳ Sisa: $(printf '%d:%02d:%02d' $H $M $S)${LABEL:+ — $LABEL}"
        fi
        return 0
    fi

    # Wajib ada argumen durasi
    if [[ -z "$1" ]]; then
        echo "Usage: timer <durasi> [label]"
        echo "  Contoh: timer 25m"
        echo "          timer 1h30m \"Istirahat\""
        echo "          timer 90"
        echo "          timer cancel"
        return 1
    fi

    # Parse durasi: bisa 25m / 1h / 1h30m / 90 (detik)
    local INPUT="$1"
    local LABEL="$2"
    local TOTAL=0
    local H M S

    if [[ "$INPUT" =~ ^([0-9]+h)?([0-9]+m)?([0-9]+s)?$ && "$INPUT" != "" ]]; then
        H=$(echo "$INPUT" | grep -oP '\d+(?=h)'); H=${H:-0}
        M=$(echo "$INPUT" | grep -oP '\d+(?=m)'); M=${M:-0}
        S=$(echo "$INPUT" | grep -oP '\d+(?=s)'); S=${S:-0}
        TOTAL=$(( H*3600 + M*60 + S ))
    elif [[ "$INPUT" =~ ^[0-9]+$ ]]; then
        TOTAL=$INPUT
    else
        echo "❌ Format durasi tidak valid: $INPUT"
        echo "   Gunakan: 25m / 1h / 1h30m / 90"
        return 1
    fi

    if [[ $TOTAL -le 0 ]]; then
        echo "❌ Durasi harus lebih dari 0."
        return 1
    fi

    local END=$(( $(date +%s) + TOTAL ))
    local H_disp=$((TOTAL / 3600))
    local M_disp=$(( (TOTAL % 3600) / 60 ))
    local S_disp=$((TOTAL % 60))

    # Simpan state
    rm -f "$NOTIF"
    jq -n --argjson end "$END" --arg label "$LABEL" \
        '{end: $end, label: $label}' > "$STATE"

    echo "⏳ Timer dimulai: $(printf '%d:%02d:%02d' $H_disp $M_disp $S_disp)${LABEL:+ — \"$LABEL\"}"
    echo "   Selesai pukul: $(date -d @$END '+%H:%M:%S')"
}
# ─────────────────────────────────────────────────────────────────────────────

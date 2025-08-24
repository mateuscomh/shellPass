#!/usr/bin/env bash

export LANG=C
#----------------------------------------------------|
#  Matheus Martins 3mhenrique@gmail.com
#  https://github.com/mateuscomh/yoURL
#  30/03/2021 4.1.1 GPL3
#  Generate secure passwords on terminal
#  Depends: words; xclip on GNU/Linux / pbcopy on IOS
#----------------------------------------------------|

main() {
	local USAGE="Generate random passwords from CLI
███████╗██╗  ██╗███████╗██╗     ██╗     ██████╗  █████╗ ▄▄███▄▄·▄▄███▄▄·
██╔════╝██║  ██║██╔════╝██║     ██║     ██╔══██╗██╔══██╗██╔════╝██╔════╝
███████╗███████║█████╗  ██║     ██║     ██████╔╝███████║███████╗███████╗
╚════██║██╔══██║██╔══╝  ██║     ██║     ██╔═══╝ ██╔══██║╚════██║╚════██║
███████║██║  ██║███████╗███████╗███████╗██║     ██║  ██║███████║███████║
╚══════╝╚═╝  ╚═╝╚══════╝╚══════╝╚══════╝╚═╝     ╚═╝  ╚═╝╚═▀▀▀══╝╚═▀▀▀══╝"

	local VERSION="Ver:4.1.1"
	local AUTHOR="Matheus Martins-3mhenrique@gmail.com"
	local MAX="$1"
	local TYPE="$2"

	echo -e "$USAGE"

	case "$MAX" in
	h | -h | v | -v | --version)
		echo -e "${ITALIC} $VERSION / $AUTHOR ${CLOSE}"
		exit 0
		;;
	*)
		echo "$VERSION"
		_checkSize
		_checkType
		;;
	esac

	_generateCharSets
	_makePass
	_writeFile
}

_checkSize() {
	while [[ -z "$MAX" || ! "$MAX" =~ ^[1-9][0-9]{0,3}$ || ${#MAX} -gt 4 ]]; do
		if [[ ${#MAX} -gt 4 ]]; then
			echo "${BOLD}  Enter up to 4 digits for the password or [Q]uit.${CLOSE}"
			read -r MAX
		else
			echo -e "${BOLD} Enter the QUANTITY of characters for the password or [Q]uit: ${CLOSE}"
			read -r MAX
		fi

		[[ $MAX =~ ^[qQ]$ ]] && {
			echo "Bye..."
			exit 0
		}
	done
}

_checkType() {
	while ! [[ "$TYPE" =~ ^[1-4]$|^[qQ]$ ]]; do
		echo -e "${BOLD} Enter the TYPE [1-4] for password complexity or [Q]uit ${CLOSE}
    ${ITALIC}1${CLOSE} - Numbers only
    ${ITALIC}2${CLOSE} - Letters and numbers
    ${ITALIC}3${CLOSE} - Letters, numbers and special chars
    ${ITALIC}4${CLOSE} - Random words"
		echo -e "${BOLD}Option for $MAX characters: (Choose 1-4 or Q)${CLOSE}"
		read -rsn1 TYPE
	done
}

_generateCharSets() {
	case "$TYPE" in
	1) CPX='0-9' ;;
	2) CPX='a-zA-Z0-9' ;;
	3) CPX='A-Za-z0-9!"#$%&'\''()*+,-./:;<=>?@[\]^_{|}~' ;;
	4)
		case $(uname -s) in
		Darwin) DICT="/usr/share/dict/web2" ;;
		Linux) DICT="/usr/share/dict/american-english" ;;
		*)
			echo "OS not supported"
			return 1
			;;
		esac

		[ -f "$DICT" ] || {
			echo -e "${BOLD}Dictionary not found.${CLOSE}"
			echo -e "Please install it. For Debian/Ubuntu, try: ${ITALIC}sudo apt install wamerican${CLOSE}"
			return 1
		}

		echo -e "\n${BOLD}Choose separator or [Q]uit:${CLOSE}"
		echo -e "Default is '-' "
		echo "1)${ITALIC} Hyphen${CLOSE} (-)"
		echo "2)${ITALIC} Colon ${CLOSE}(:)"
		echo "3)${ITALIC} Semicolon${CLOSE} (;)"
		echo "4)${ITALIC} Comma ${CLOSE}(,)"
		echo "5)${ITALIC} Space ${CLOSE}( )"
		while true; do
			read -rsn1 -p "${BOLD}Your choice [1-5]:${CLOSE}" SEP_CHOICE
			echo
			[[ -z "$SEP_CHOICE" ]] && SEP_CHOICE=1
			case "$SEP_CHOICE" in
			1)
				SEPARATOR="-"
				break
				;;
			2)
				SEPARATOR=":"
				break
				;;
			3)
				SEPARATOR=";"
				break
				;;
			4)
				SEPARATOR=","
				break
				;;
			5)
				SEPARATOR=" "
				break
				;;
			q | Q)
				echo "Bye..."
				exit
				;;
			*) echo "${ITALIC}Invalid option, try again${CLOSE}" ;;
			esac
		done

		CPX=$(shuf -n "$MAX" "$DICT" | tr '\n' "$SEPARATOR" | sed "s/\\${SEPARATOR}\$//")
		;;
	q | Q)
		echo "Bye..."
		exit
		;;
	esac
}

_makePass() {
	if [[ "$TYPE" -eq 4 ]]; then
		PASS=$(echo "$CPX" | tr '[:upper:]' '[:lower:]' | iconv -f UTF-8 -t ASCII//TRANSLIT | sed "s/'s//g")
	else
		local charsets
		case "$TYPE" in
		1) charsets=('0-9') ;;
		2) charsets=('a-z' 'A-Z' '0-9') ;;
		3) charsets=('a-z' 'A-Z' '0-9' '!"#$%&'\''()*+,-./:;<=>?@[\]^_{|}~') ;;
		esac

		local IFS=''
		local combined="${charsets[*]}"

		if [[ "$TYPE" =~ [23] ]]; then
			local remaining=$((MAX - ${#charsets[@]}))

			PASS=$(
				{
					for set in "${charsets[@]}"; do
						tr -dc "$set" </dev/urandom | head -c1
					done
					((remaining > 0)) && tr -dc "$combined" </dev/urandom | head -c "$remaining"
				} | fold -w1 | shuf | tr -d '\n'
			)
		else
			PASS=$(tr -dc "$combined" </dev/urandom | head -c "$MAX")
		fi
	fi

	echo -e "${BOLD}$PASS${CLOSE}"

	case $(uname -s) in
	Darwin) printf %s "$PASS" | pbcopy ;;
	Linux)
		if grep -iq Microsoft /proc/version; then
			printf "%s" "$PASS" | clip.exe
			command -v clip.exe >/dev/null || echo "clip.exe não encontrado"
		elif command -v xclip >/dev/null && [ -n "$DISPLAY" ]; then
			printf "%s" "$PASS" | xclip -sel clip
		fi
		;;
	*)
		echo "OS not supported"
		return 1
		;;
	esac
}

_writeFile() {
	local SCRIPT_PATH="${BASH_SOURCE[0]}"
	local AB_SCRIPT_PATH AB_DIR
	if command -v readlink >/dev/null; then
		AB_SCRIPT_PATH=$(readlink -f "$SCRIPT_PATH")
	else
		AB_SCRIPT_PATH=$(cd "$(dirname "$SCRIPT_PATH")" && pwd)/$(basename "$SCRIPT_PATH")
	fi
	AB_DIR=$(dirname "$AB_SCRIPT_PATH")
	local HISTORY_FILE="$AB_DIR/history.log"

	[ -f "$HISTORY_FILE" ] && tail -n9 "$HISTORY_FILE" >"${HISTORY_FILE}.tmp"
	mv "${HISTORY_FILE}.tmp" "$HISTORY_FILE" 2>/dev/null || touch "$HISTORY_FILE"
	echo "$(date '+%d/%m/%y %H:%M:%S') - $PASS" >>"$HISTORY_FILE"
}

CLOSE=$(tput sgr0)
BOLD=$(tput bold)
ITALIC=$(tput dim)

main "$@"

#!/usr/bin/env bash

export LANG=C
#----------------------------------------------------|
#  Matheus Martins 3mhenrique@gmail.com
#  https://github.com/mateuscomh/yoURL
#  30/03/2021 3.9.3 GPL3
#  Generate secure passwords on terminal
#  Depends: words; xclip on GNU/Linux / pbcopy on IOS
#----------------------------------------------------|

FECHA=$(tput sgr0)
BOLD=$(tput bold)
ITALIC=$(tput dim)

main() {
	local VERSION="Ver:3.9.3"
	local AUTHOR="Matheus Martins-3mhenrique@gmail.com"
	local USAGE="Generate random passwords from CLI
███████╗██╗  ██╗███████╗██╗     ██╗     ██████╗  █████╗ ▄▄███▄▄·▄▄███▄▄·
██╔════╝██║  ██║██╔════╝██║     ██║     ██╔══██╗██╔══██╗██╔════╝██╔════╝
███████╗███████║█████╗  ██║     ██║     ██████╔╝███████║███████╗███████╗
╚════██║██╔══██║██╔══╝  ██║     ██║     ██╔═══╝ ██╔══██║╚════██║╚════██║
███████║██║  ██║███████╗███████╗███████╗██║     ██║  ██║███████║███████║
╚══════╝╚═╝  ╚═╝╚══════╝╚══════╝╚══════╝╚═╝     ╚═╝  ╚═╝╚═▀▀▀══╝╚═▀▀▀══╝"

	local MAX="$1"
	local TYPE="$2"

	echo -e "$USAGE"

	case "$MAX" in
	h | -h | v | -v | --version)
		echo -e "${ITALIC} $VERSION / $AUTHOR ${FECHA}"
		return
		;;
	*)
		echo "$VERSION"
		_checkSize
		_checkType
		;;
	esac

	_generateCharacterSets
	_makePass
	_writeinfile
}

_checkSize() {
	while [[ -z "$MAX" || ! "$MAX" =~ ^[1-9][0-9]{0,3}$ || ${#MAX} -gt 4 ]]; do
		if [[ ${#MAX} -gt 4 ]]; then
			echo "${BOLD}  Enter up to 4 digits for the password or [Q]uit.${FECHA}"
			read -r MAX
		else
			echo -e "${BOLD} Enter the QUANTITY of characters for the password or [Q]uit: ${FECHA}"
			read -r MAX
		fi

		[[ $MAX =~ ^[qQ]$ ]] && {
			echo "Bye..."
			exit 0
		}
		[[ ${#MAX} -gt 4 ]] && MAX=""
	done
}

_checkType() {
	while ! [[ "$TYPE" =~ ^[1-4]$|^[qQ]$ ]]; do
		echo -e "${BOLD} Enter the TYPE [1-4] for password complexity or [Q]uit ${FECHA}
    ${ITALIC}1${FECHA} - Numbers only
    ${ITALIC}2${FECHA} - Letters and numbers
    ${ITALIC}3${FECHA} - Letters, numbers and special chars
    ${ITALIC}4${FECHA} - Random words
		${BOLD}Option for $MAX characters:${FECHA}"
		read -rsn1 TYPE
	done
}

_generateCharacterSets() {
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
			echo "Dictionary not found"
			return 1
		}
		CPX=$(shuf -n "$MAX" "$DICT" | tr '\n' '-' | sed 's/-$//')
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

		if [[ "$TYPE" =~ [23] ]] && ((MAX > ${#charsets[@]})); then
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

	echo -e "${BOLD}$PASS${FECHA}"

	case $(uname -s) in
	Darwin) printf %s "$PASS" | pbcopy ;;
	Linux)
		if grep -iq Microsoft /proc/version; then
			printf "%s" "$PASS" | clip.exe
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

_writeinfile() {
	local SCRIPT_PATH="${BASH_SOURCE[0]}"
	local AB_SCRIPT_PATH AB_DIR
	AB_SCRIPT_PATH=$(readlink -f "$SCRIPT_PATH")
	AB_DIR=$(dirname "$AB_SCRIPT_PATH")
	local HISTORY_FILE="$AB_DIR/history.log"

	[ -f "$HISTORY_FILE" ] && tail -n9 "$HISTORY_FILE" >"${HISTORY_FILE}.tmp"
	mv "${HISTORY_FILE}.tmp" "$HISTORY_FILE" 2>/dev/null || touch "$HISTORY_FILE"
	echo "$(date '+%d/%m/%y %H:%M:%S') - $PASS" >>"$HISTORY_FILE"
}

main "$@"

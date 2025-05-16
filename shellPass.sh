#!/usr/bin/env bash

export LANG=C
#----------------------------------------------------|
#  Matheus Martins 3mhenrique@gmail.com
#  https://github.com/mateuscomh/yoURL
#  30/03/2021 3.9.1 GPL3
#  Generate secure passwords on terminal
#  Depends: words; xclip on GNU/Linux / pbcopy on IOS
#----------------------------------------------------|

FECHA=$(tput sgr0)
BOLD=$(tput bold)
ITALIC=$(tput dim)

main() {
	local VERSION="Ver:3.9.1"
	local AUTHOR="Matheus Martins-3mhenrique@gmail.com"
	local USAGE="Generate random passwords from CLI
███████╗██╗  ██╗███████╗██╗     ██╗     ██████╗  █████╗ ▄▄███▄▄·▄▄███▄▄·
██╔════╝██║  ██║██╔════╝██║     ██║     ██╔══██╗██╔══██╗██╔════╝██╔════╝
███████╗███████║█████╗  ██║     ██║     ██████╔╝███████║███████╗███████╗
╚════██║██╔══██║██╔══╝  ██║     ██║     ██╔═══╝ ██╔══██║╚════██║╚════██║
███████║██║  ██║███████╗███████╗███████╗██║     ██║  ██║███████║███████║
╚══════╝╚═╝  ╚═╝╚══════╝╚══════╝╚══════╝╚═╝     ╚═╝  ╚═╝╚═▀▀▀══╝╚═▀▀▀══╝ "
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

	case "$TYPE" in
	1)
		CPX='0-9'
		;;
	2)
		CPX='a-z0-9A-Z'
		;;
	3)
		CPX='A-Za-z0-9!"#$%&'\''()*+,-./:;<=>?@[\]^_{|}~'
		;;
	4)
		case $(uname -s) in
		Darwin)
			DICT="/usr/share/dict/web2"
			;;
		Linux)
			DICT="/usr/share/dict/american-english"
			;;
		*)
			echo "This is compatible only for GNU/Linux, MacOS or WSL2"
			return 1
			;;
		esac
		if [ ! -f "$DICT" ]; then
			echo "Dictionary not found, consider install package 'words'"
			return 1
		fi
		CPX=$(shuf -n "$MAX" "$DICT" | tr '\n' '-' | sed 's/-$//')
		;;
	q | Q)
		echo "Bye..."
		exit
		;;
	esac
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
		TYPE="0"
		if [[ ${#MAX} -gt 4 ]]; then
			echo "${ITALIC}Invalid input! Enter up to 4 digits.${FECHA}"
			MAX=""
		fi
		[[ $MAX =~ ^[qQ]$ ]] && echo "Bye..." && exit 0
	done
}

_checkType() {
	while ! [[ "$TYPE" =~ ^[1-4]$|^[qQ]$ ]]; do
		echo -e "${BOLD} Enter the TYPE [1,2,3,4] for password complexity you want or [Q]uit ${FECHA}
    ${ITALIC} 1 - Password only numbers ${FECHA}
    ${ITALIC} 2 - Password with LeTtErS and numb3rs ${FECHA}
    ${ITALIC} 3 - Password with LeTtErS, numb3rs and Sp3c1@l Ch@r@ct&rs ${FECHA}
    ${ITALIC} 4 - Random words ${FECHA}
${BOLD} Option with up to $MAX characters ${FECHA}"
		read -rsn 1 TYPE
	done
}

_writeinfile() {
	SCRIPT_PATH="${BASH_SOURCE:-$0}"
	AB_SCRIPT_PATH="$(readlink -f "${SCRIPT_PATH}")"
	AB_DIR="$(dirname "${AB_SCRIPT_PATH}")"
	HISTORY_FILE="$AB_DIR/history.log"

	tail -n 9 "$HISTORY_FILE" >"$HISTORY_FILE.tmp" 2>/dev/null || touch "$HISTORY_FILE.tmp"
	mv "$HISTORY_FILE.tmp" "$HISTORY_FILE"

	echo "$(date '+%d/%m/%y %H:%M:%S') - $PASS" >>"$HISTORY_FILE"
}

_makePass() {
	if [[ "$TYPE" -eq 4 ]]; then
		PASS=$(echo "$CPX" | tr '[:upper:]' '[:lower:]' | iconv -f UTF-8 -t ASCII//TRANSLIT | sed "s/'s//g")
	else
		if [[ "$TYPE" -eq 3 && "$MAX" -gt 3 ]]; then
			lower='a-z'
			upper='A-Z'
			numbers='0-9'
			special='!"#$%&'\''()*+,-./:;<=>?@[\]^_{|}~'

			remaining=$((MAX - 4))

			PASS=$(
				{
					tr -dc "$lower" </dev/urandom | head -c1
					tr -dc "$upper" </dev/urandom | head -c1
					tr -dc "$numbers" </dev/urandom | head -c1
					tr -dc "$special" </dev/urandom | head -c1
					if ((remaining > 0)); then
						tr -dc "$lower$upper$numbers$special" </dev/urandom | head -c "$remaining"
					fi
				} | fold -w1 | shuf | tr -d '\n'
			)
		else
			PASS=$(tr -dc "$CPX" </dev/urandom | head -c "$MAX")
		fi
	fi

	echo -e "${BOLD}$PASS${FECHA}"
	case $(uname -s) in
	Darwin)
		printf %s "$PASS" | pbcopy 2>/dev/null
		;;
	Linux)
		if grep -iq Microsoft /proc/version; then
			printf "%s" "$PASS" | clip.exe
		elif command -v xclip >/dev/null && [ -n "$DISPLAY" ]; then
			printf "%s" "$PASS" | xclip -sel clip
		fi
		;;
	*)
		echo "This is compatible only for GNU/Linux, MacOS or WSL2"
		return 1
		;;
	esac
}
#---Main
main "$1" "$2"

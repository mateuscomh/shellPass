#!/usr/bin/env bash

export LANG=C
#----------------------------------------------------|
#  Matheus Martins 3mhenrique@gmail.com
#  https://github.com/mateuscomh/yoURL
#  30/03/2021 3.7.3 GPL3
#  Generate secure passwords on terminal
#  Depends: words; xclip on GNU/Linux / pbcopy on IOS
#----------------------------------------------------|

FECHA=$(tput sgr0)
BOLD=$(tput bold)
ITALIC=$(tput dim)

main() {
	local VERSION="Ver:3.7.23"
	local AUTHOR="Matheus Martins-3mhenrique@gmail.com"
	local USAGE="Generate random passwords from CLI
███████╗██╗  ██╗███████╗██╗     ██╗     ██████╗  █████╗ ▄▄███▄▄·▄▄███▄▄·
██╔════╝██║  ██║██╔════╝██║     ██║     ██╔══██╗██╔══██╗██╔════╝██╔════╝
███████╗███████║█████╗  ██║     ██║     ██████╔╝███████║███████╗███████╗
╚════██║██╔══██║██╔══╝  ██║     ██║     ██╔═══╝ ██╔══██║╚════██║╚════██║
███████║██║  ██║███████╗███████╗███████╗██║     ██║  ██║███████║███████║
╚══════╝╚═╝  ╚═╝╚══════╝╚══════╝╚══════╝╚═╝     ╚═╝  ╚═╝╚═▀▀▀══╝╚═▀▀▀══╝ "
	local MAX="$1"
	local TIPO="$2"
	echo -e "$USAGE"
	case "$MAX" in
	v | -v | h | -h | --version)
		echo -e "${ITALIC} $VERSION / $AUTHOR ${FECHA}"
		return
		;;
	*)
		echo "$VERSION"
		_checkSize
		_checkType
		;;
	esac

	case "$TIPO" in
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
		Darwin) DICT="/usr/share/dict/web2" ;;
		Linux) DICT="/usr/share/dict/american-english" ;;
		*)
			echo "This is compatible only for GNU/Linux, MacOS or WSL2"
			exit 1
			;;
		esac
		if [ ! -f "$DICT" ]; then
			echo "Dictionary not found"
			exit 1
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
	while :; do
		echo -e "${BOLD} Enter the QUANTITY of characters for the password or [Q]uit: ${FECHA}"
		read -r MAX
    [[ $MAX =~ ^[qQ]$ ]] && echo "Bye..." && exit 0
    [[ $MAX =~ ^[1-9][0-9]{0,8}$ && ${#MAX} -le 4 ]] && break
    echo "${ITALIC}Invalid input! Enter up to 4 digits.${FECHA}"
done

}

_checkType() {
	while [[ "$TIPO" != [1-4] && "$TIPO" != [qQ] ]]; do
		echo -e "${BOLD} Enter the TYPE [1,2,3,4] for password complexity you want or [Q]uit ${FECHA}
    ${ITALIC} 1 - Password only numbers ${FECHA}
    ${ITALIC} 2 - Password with LeTtErS and numb3rs ${FECHA}
    ${ITALIC} 3 - Password with LeTtErS, numb3rs and Sp3c1@l Ch@r@ct&rs ${FECHA}
    ${ITALIC} 4 - Random words ${FECHA}"
		read -rsn 1 TIPO
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
	if [[ "$TIPO" -eq 4 ]]; then
		PASS=$(echo "$CPX" | tr '[:upper:]' '[:lower:]' | iconv -f UTF-8 -t ASCII//TRANSLIT | sed "s/'s//g")
	else
		PASS=$(tr -dc "$CPX" </dev/urandom | head -c "$MAX")
	fi
	echo -e "${BOLD}$PASS${FECHA}"
	case $(uname -s) in
	Darwin) printf %s "$PASS" | pbcopy 2>/dev/null ;;
	Linux)
		if grep -iq Microsoft /proc/version; then
			printf "%s" "$PASS" | clip.exe
		elif command -v xclip >/dev/null && [ -n "$DISPLAY" ]; then
			printf "%s" "$PASS" | xclip -sel clip
		fi
		;;
	*)
		echo "This is compatible only for GNU/Linux, MacOS or WSL2"
		exit 1
		;;
	esac
}
#---Main
main "$1" "$2"

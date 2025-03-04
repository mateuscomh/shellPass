#!/usr/bin/env bash

export LANG=C
#----------------------------------------------------|
#  Matheus Martins 3mhenrique@gmail.com
#  https://github.com/mateuscomh/yoURL
#  30/03/2021 3.7.1 GPL3
#  Generate secure passwords on terminal
#  Depends: xclip on GNU/Linux / pbcopy on IOS
#----------------------------------------------------|

FECHA="\033[m"
BOLD=$(tput bold)
ITALIC=$(tput dim)

main() {
	local VERSION="Ver:3.6.3"
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
		DICIONARIO="/usr/share/dict/american-english"

		if [ ! -f "$DICIONARIO" ]; then
			echo "Dicionário não encontrado!"
			exit 1
		fi
		CPX=$(shuf -n "$MAX" "$DICIONARIO" | tr '\n' '-' | sed 's/-$//')

#		CPX=$(awk 'BEGIN {srand()} {print $0}' "$DICIONARIO" | shuf | head -n "$MAX" | tr '\n' '-' | sed 's/-$//')
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
	while [[ -z "$MAX" || ! "$MAX" =~ ^[1-9][0-9]{0,8}$ ]]; do
		echo -e "${BOLD} Enter the QUANTITY of characters for the password or [Q]uit: ${FECHA}"
		read -r MAX
		[[ $MAX =~ ^[qQ]$ ]] && echo "Bye..." && exit 0
		[[ ${#MAX} -gt 9 ]] && echo "Too long! Try less than 9 digits. " && continue
		break
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
	#[ "$(wc -l <"$AB_DIR/history.log")" -ge 10 ] && tail -n +2 "$AB_DIR"/history.log >"$AB_DIR"/history.log.tmp && mv "$AB_DIR"/history.log.tmp "$AB_DIR"/history.log
	#echo "$(date '+%d/%m/%y %H:%M:%S') - $PASS" >>"$AB_DIR"/history.log
}

_makePass() {
	if [[ "$TIPO" -eq 4 ]]; then
		PASS="$CPX"
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

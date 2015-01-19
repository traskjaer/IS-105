#!/bin/bash

# gitklient.sh
# Kommandolinje klient for git(hub) - Christer Jonassen
# 
# Forutsetter at current directory er et repository og at det er riktig satt opp.

APPVERSION="0.3"

# Terminal farger
DEF="\x1b[0m"
WHITE="\e[0;37m"
LIGHTBLACK="\x1b[30;01m"
BLACK="\x1b[30;11m"
LIGHTBLUE="\x1b[34;01m"
BLUE="\x1b[34;11m"
LIGHTCYAN="\x1b[36;01m"
CYAN="\x1b[36;11m"
LIGHTGRAY="\x1b[37;01m"
GRAY="\x1b[37;11m"
LIGHTGREEN="\x1b[32;01m"
GREEN="\x1b[32;11m"
LIGHTPURPLE="\x1b[35;01m"
PURPLE="\x1b[35;11m"
LIGHTRED="\x1b[31;01m"
RED="\x1b[31;11m"
LIGHTYELLOW="\x1b[33;01m"
YELLOW="\x1b[33;11m"


trap "{ skrivut \"Fanget stopp signal, avslutter...\"; sleep 1;  exit; }" SIGINT SIGTERM # Set trap for catching Ctrl-C and kills, so we can reset terminal upon exit
trap "{ clear; reset; skrivut \"gitklient $APPVERSION terminated at `date`\"; }" EXIT # exit procedure

header()
{
	clear
	skrivut ""$DEF"### "$CYAN"gitklient $APPVERSION "$DEF"- Mappe: "$CYAN"$(pwd)"$DEF" - Bruker: "$CYAN"$(whoami)"$DEF" ###"
	skrivut
}
skrivut()
{
	echo -e ""$DEF"$1"$DEF""
}

skrivutdata()
{
	case "$1" in

		start)
			echo -e ""$DEF""$PURPLE"### Utfører: "$PURPLE"\""$YELLOW"$2"$PURPLE"\""$YELLOW""
			;;

		stopp)
			echo -e ""$DEF""$PURPLE"### OK!"$DEF""
			;;

	esac
}

bekreft()
{
	skrivut "Trykk en tast for å fortsette..."
	read -s -n 1 SELECTION
}

leggtilogcommit()
{
	header
	skrivutdata start "git add * --all"
	git add *
	skrivutdata stopp "git add * --all"
	skrivut
	echo -e "Skriv inn kommentar til commiten du oppretter:"$YELLOW""
	read KOMMENTAR

	skrivut "Vil bli commitet med kommentaren: \""$YELLOW"$KOMMENTAR\""
	bekreft
	skrivut "Utfører git commit!"
	skrivutdata start "git commit -m \"$KOMMENTAR\""
	git commit -m "$KOMMENTAR"
	skrivutdata stopp "git commit -m \"$KOMMENTAR\""
	bekreft
}

synkronisermedgithub()
{
	header
	skrivut "Laster ned..."
	skrivutdata start "git pull origin master"
	git pull origin master
	skrivutdata stopp "git pull origin master"
	skrivut
	skrivut "Laster opp..."
	skrivutdata start "git push origin master"
	git push origin master
	skrivutdata stopp "git push origin master"
	skrivut
	skrivut "Ferdig!"
	bekreft
}

meny()
{
header   
skrivut "  1. Commit alle endringer"
skrivut "     (git add * --all)"
skrivut    
skrivut "  2. Synkroniser med github.com"
skrivut "     (git pull origin master og"
skrivut "      git push origin master)"
skrivut   
skrivut "  X. Avslutt"
skrivut
skrivut
skrivut "Velg en handling (1, 2 eller X):"

read -s -n 1 SELECTION

case "$SELECTION" in
 	1)
		leggtilogcommit
		;;

	2)
		synkronisermedgithub
		;;

	x)
		exit
		;;

	X)
		exit
		;;

	*)
		;;
esac
}

# selve runscriptet
while true
        do
        	meny
        done

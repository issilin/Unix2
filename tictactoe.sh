#!/bin/bash
PORT="9901"
HOST="localhost"
KSPACE=20
function Draw ()
{
	eval 'clear'
	for i in 1 2 3
	do
		echo ''
		for j in 1 2 3
		do
			if [ "${variable[$i$j]}" == "" ]
				then
				echo -n '_ '
			else
				echo -n "${variable[$i$j]} "
			fi
		done
	done
}

function ToNet {
    echo $1 | nc $HOST $PORT
}

function NetListen 
{
    nc -l $PORT
}

function endGame
{
	echo -e "\nendGame"
	if [ $1 == $my ]; then
		echo "Вы победили!!!"
	elif [ $1 == $enemy ]; then
		echo "Вы проиграли (xa-xa)"
	fi
	echo "Ничья"
	exit 0
}

function checkForWin
{
	if [ "${variable[11]}" != "" ] && [ "${variable[11]}" == "${variable[12]}" ] && [ "${variable[12]}" == "${variable[13]}" ]; then
		endGame "${variable[11]}"
	fi
	if [ "${variable[21]}" != "" ] && [ "${variable[21]}" == "${variable[22]}" ] && [ "${variable[22]}" == "${variable[23]}" ]; then 
		endGame "${variable[21]}"
	fi
	if [ "${variable[31]}" != "" ] && [ "${variable[31]}" == "${variable[32]}" ] && [ "${variable[32]}" == "${variable[33]}" ]; then 	
		endGame "${variable[31]}"
	fi
	if [ "${variable[11]}" != "" ] && [ "${variable[11]}" == "${variable[21]}" ] && [ "${variable[21]}" == "${variable[31]}" ]; then 	
		endGame "${variable[11]}"
	fi
	if [ "${variable[12]}" != "" ] && [ "${variable[12]}" == "${variable[22]}" ] && [ "${variable[22]}" == "${variable[32]}" ]; then 	
		endGame "${variable[12]}"
	fi
	if [ "${variable[13]}" != "" ] && [ "${variable[13]}" == "${variable[23]}" ] && [ "${variable[23]}" == "${variable[33]}" ]; then 	
		endGame "${variable[13]}"
	fi
	if [ "${variable[11]}" != "" ] && [ "${variable[11]}" == "${variable[22]}" ] && [ "${variable[22]}" == "${variable[33]}" ]; then 	
		endGame "${variable[11]}"
	fi
	if [ "${variable[31]}" != "" ] && [ "${variable[31]}" == "${variable[22]}" ] && [ "${variable[22]}" == "${variable[13]}" ]; then 	
		endGame "${variable[31]}"
	fi

	for i in 1 2 3
	do
		for j in 1 2 3
		do
			if [ "${variable[$i$j]}" == "" ]
				then
				return
			fi
		done
	done
	endGame "fig"
}

ToNet "x"
if [ "$(NetListen)" == "x" ]; then
	ourMove=1
	my='x'
	enemy='0'
	ToNet "0"
else
	ourMove=0
	my='0'
	enemy='x'
fi

Draw
while [ 1 ]; do
	if [ "$ourMove" -eq 1 ]; then
		checkForWin
		echo -e "\nВаш ход"
		read x
		read y
		ToNet $x$y
		if [ "${variable[$x$y]}" = "" ]; then
			variable[$x$y]=$my
			Draw
			ourMove=0
		else
			echo -e "\nНельзя сделать такой ход"
		fi
	else
		checkForWin
		echo -e "\nЖдите..."
		code=$(NetListen)
		if [ "${variable[$code]}" = "" ]; then
			variable[code]=$enemy
			Draw
			ourMove=1
		else
			echo -e "Нельзя сделать такой ход"
		fi
	fi
done
# Declarer les variables
des=$HOME/Desktop
doc=$HOME/Documents
dow=$HOME/Downloads
pic=$HOME/Pictures
mus=$HOME/Music
vid=$HOME/Videos
h=$(hostname)_       # Nom sauvegarde ( non modifiable )


##### Fonctionnalitées a ajouter
# Creer une archive
# choisir d'inclure les dossier par defaut ou non


# Fonction de sauvegarde.
ft_save() {
    
    # [5/5] Sauvegarde en cours...
    cat userdata.txt
    
    # Verifier la presence du fichier userdata.
    if [ -f userdata.txt ]; then echo "fichier userdata OK"; else "pas de fichier userdata"; ft_save; fi

        # Verifier si une sauvegarde existe deja, sinon incrementer de +1 dans le nom de la sauvegarde.
        path=$path/
        if [ -d $path$h$numb ]; then numb=$((numb+1)) ; bkup=$path$h$numb; mkdir -p $bkup
            else numb=1; bkup=$path$h$numb
            mkdir -p $bkup
        fi


        # [5/5] Message de confirmation.
        echo "Attention ! Risque de sauvegarder en boucle si... "
        echo "$bkup et $HOME ont le meme dossier racine $HOME"
        read -p "[4/5] Vous allez sauvegarder dans $bkup ? (y/n)" resp2
        [[ $bkup =~ $HOME ]] && echo "Erreur Boucle de sauvegarde sur $bkup" &&
        read -p "Bye..." && exit 0


        # Lancer la sauvegarde
        rsync -av --exclude-from=$exclude  $vid $des $doc $dow $mus $pic $rep1 $rep2 $rep3 $rep4 $rep5 $bkup
        zip -9 -r $bkup.zip $bkup
        echo "[5/5] La sauvegarde a reussi."
        xdg-open $bkup
}


# INIT - Choisir si les preferences on besoin d'etre modifiees
clear
read -p "Modifier les préferences du script ? (y/n) " param
[[ $HOME/Desktop/BKUP.desktop ]] && echo "Script BKUP pas encore installe" &&
echo "Icon=$HOME/.icon.png" >> assets/BKUP.desktop &&
cp assets/BKUP.desktop $HOME/Desktop/BKUP.desktop &&
cp assets/.icon.png $HOME


# NON Lancer la sauvegarde.
if [ "$param" = "n" ]; then
    echo "$param"
    if [ -f userdata.txt ]; then
    bkup=(      $(awk 'NR == 11' userdata.txt))
    exclude=(   $(awk 'NR == 13' userdata.txt))
    rep1=(      $(awk 'NR == 11' userdata.txt))
    rep2=(      $(awk 'NR == 12' userdata.txt))
    rep3=(      $(awk 'NR == 13' userdata.txt))
    rep4=(      $(awk 'NR == 14' userdata.txt))
    rep5=(      $(awk 'NR == 15' userdata.txt))
    numb=(      $(awk 'NR == 17' userdata.txt))
    ft_save
    fi
fi


# OUI - Ouvrir le menu des preferences.
if [ "$param" = "y" ]; then
echo "Salut bienvenue le menu des preferences du script BKUP, il enregistre en local tout ce que vous modifiez"
echo "Par defaut les dossiers suivants vont etre enregsitrés"
echo "$des"
echo "$mus"
echo "$dow"
echo "$pic"
echo "$doc"
echo "S'il vous plait avant de realiser une backup veuillez"
echo "retirer les fichier en cache volumineux qui ne sont pas des données"
echo " librairies, doublons, archives, logiciels"

# Choisir 1 emplacement de sauvegarde
echo "[1/5] Dans quel repertoire faire la sauvegarde ?..."
path=$(zenity --file-selection --directory)
echo "Vous avez choisi $path"
[[ ! -d $path ]] && echo -p "Aucun Emplacement" && read -p "bye... " err && exit 0


# Dossier et fichiers additionnels.
echo "$des"
echo "$mus"
echo "$dow"
echo "$pic"
echo "$doc"
echo "Par defaut les dossiers suivants vont etre enregsitrés"
read -p "Bakcuper les dossier utilisateurs (y/n) ?" resp3
[[ "$resp3" == "n" ]] && des="" && mus="" && dow="" && pic="" && doc="" 

echo "[2/5] données additionnelles"
rep1=$(zenity --file-selection --directory)
[[ $rep1 > 1 ]] &&  rep2=$(zenity --file-selection --directory)
[[ $rep2 > 1 ]] &&  rep3=$(zenity --file-selection --directory)
[[ $rep3 > 1 ]] &&  rep4=$(zenity --file-selection --directory)
[[ $rep4 > 1 ]] &&  rep5=$(zenity --file-selection --directory)


# Exclusions
clear
echo "[3/5] Exclusions"
echo "1) Fichiers en cache Windows Mac Linux android linux -> .git .env .lnk .cache .log"
echo "2) Fichier en cache + Fichiers video -> .ogv .mp4 .avi"
read -p "Choisissez un nombre ( par defaut sur 1 )" choose
case "$choose" in
1)
    exclude="exclude/exclude-default.txt"
    ;;
2)
    exclude="exclude/exclude-videos.txt"
    ;;
*)
    exclude="exclude/exclude-default.txt"
    ;;
esac


# Enregistrer des données.
echo "[USERDATA]" > ./userdata.txt
hostname >> userdata.txt && date >> userdata.txt

echo "[REPERTOIRES]" >> userdata.txt
echo "$des" >> userdata.txt && echo "$doc" >> userdata.txt && echo "$dow" >> userdata.txt && echo "$mus" >> userdata.txt && echo "$pic" >> userdata.txt

echo "[CIBLE]" >> userdata.txt
echo $bkup >> userdata.txt

echo "[EXCLUSIONS]" >> userdata.txt
echo $exclude >> userdata.txt

echo "[VOS_REPERTOIRES]" >> userdata.txt
echo "$rep1" >> userdata.txt && echo "$rep2" >> userdata.txt && echo "$rep3" >> userdata.txt && echo "$rep4" >> userdata.txt && echo "$rep5" >> userdata.txt
echo "Number of bakcup" >> userdata.txt
echo $numb >> userdata.txt

    # Lancer la sauvegarde.
    ft_save
fi

echo "Vous etes gay"
exit 0


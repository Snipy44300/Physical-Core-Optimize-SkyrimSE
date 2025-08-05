
English:

🧠 Optimize Skyrim for superior CPU performance!

📌 What is it for?

Physical Core Optimizer is a 100% open-source utility designed for Skyrim (via SKSE).
It forces the game to use only the physical cores of your processor, disabling the less efficient logical cores (HyperThreading / SMT).

✅ Expected Results:
- 🚀 Better overall performance
- 🎯 Significant reduction in stutters
- 🔄 More stable CPU behavior, especially on heavy modpacks

🚀 Key Features:
- 🔧 Dynamic application of CPU affinity via PowerShell
- 📊 Automatic creation of a clear and traceable log file
- 🖥 Visible console with readable and transparent feedback

✅ Why use it?
- 🔥 Performance boost on recent multi-core processors
- 🎯 Fewer stutters and micro-freezes, especially with many mods
- 🧩 Compatible with DXVK, ENB, ReShade, SKSE, etc.
- 🧽 No impact on other software or games
- ⚙️ Leaves no files in the game: everything is external, clean, open source

🛠 How does it work?
1. 🔍 The script automatically detects your processor
2. 🚀 It launches SKSE (skse64_loader.exe)
3. 🎯 It dynamically applies a CPU affinity mask: Skyrim will only use your physical cores

🔄 Compatibility with “CPU Affinity” mods (Nexus Mods)
✅ Compatible with other mods of the same type
⛔️ But using them together is unnecessary

Why?
- This script already applies CPU affinity cleanly and externally
- It does not modify any game files, nor does it rely on DLLs
- It fulfills the same purpose, more stably and transparently

⚠️ Using multiple affinity tools may cause conflicts if each applies different masks.
🧼 With Physical Core Optimizer, you don’t need anything else.

📦 Installation:

1. Download the "Physical Core Optimizer" archive
2. Place all files in your Skyrim game root folder

🎮 If you don’t use a manager like Mod Organizer,
simply launch the .bat file corresponding to your language:
- 🇫🇷 _FR Physical Core Optimizer.bat
- 🇺🇸 _US Physical Core Optimizer.bat


Otherwise, if you're using ModOrganiser, simply add the .bat file like this:
https://i.postimg.cc/k5xgNbCs/E8-C73508-8-E93-4-B62-A41-F-3397-D7556-FF5.png
Or, launch Physical Core Optimizer via MO2_US, which will automatically search for your SKSE and optimize it!

🛑 Always run the script as administrator, otherwise PowerShell won't be able to access your processor's information.

🔍 How to check if it works?

1. Open PowerShell as administrator
2. Launch your game WITHOUT the script
3. Type the following command:

   Get-Process -Name SkyrimSE | Select-Object Name, Id, @{Name="ProcessorAffinity";Expression={($_.ProcessorAffinity).ToString("X")}}

Example:

Name     Id     ProcessorAffinity
----     --     -----------------
SkyrimSE 23872  FFFFFFFF

This means all cores are being used.

🔁 Now:
1. Close Skyrim
2. Launch it with the script
3. Re-run the PowerShell command

Example:

Name     Id     ProcessorAffinity
----     --     -----------------
SkyrimSE 10384  55555555

✅ This confirms that only the physical cores are being used. The value depends on your processor and will differ from the example shown above.


-----------------------------------------------------------------



Français :

🧠 Optimisez Skyrim pour des performances CPU supérieures !

📌 À quoi ça sert ?
Physical Core Optimizer est un utilitaire 100 % open-source conçu pour Skyrim (via SKSE).
Il force le jeu à utiliser uniquement les cœurs physiques de votre processeur, en désactivant les cœurs logiques moins performant (HyperThreading / SMT).

✅ Résultats attendus :
- 🚀 Meilleures performances générales
- 🎯 Réduction notable des stutters
- 🔄 Comportement CPU plus stable, surtout sur les gros modpacks

🚀 Fonctionnalités principales :
- 🔧 Application dynamique de l’affinité CPU via PowerShell
- 📊 Création automatique d’un journal de log clair et traçable
- 🖥 Console visible avec un retour utilisateur lisible et transparent

✅ Pourquoi l’utiliser ?
- 🔥 Boost de performances sur les processeurs multicœurs récents
- 🎯 Moins de stutters et micro-freezes, surtout avec beaucoup de mods
- 🧩 Compatible avec DXVK, ENB, ReShade, SKSE, etc.
- 🧽 Aucun impact sur les autres logiciels ou jeux
- ⚙️ Ne laisse aucun fichier dans le jeu : tout est externe, propre, open source

🛠 Comment ça fonctionne ?
1. 🔍 Le script détecte automatiquement votre processeur
2. 🚀 Il lance SKSE (skse64_loader.exe)
3. 🎯 Il applique dynamiquement un masque d’affinité : Skyrim n’utilisera que vos cœurs physiques

🔄 Compatibilité avec les mods “CPU Affinity” (Nexus Mods)
✅ Compatible avec les autres mods du même type
⛔️ Mais inutile de les cumuler

Pourquoi ?
- Ce script applique déjà l’affinité CPU de manière propre et externe
- Il ne modifie aucun fichier du jeu, ne dépend d'aucune DLL
- Il remplit exactement le même rôle, de manière plus stable et transparente

⚠️ Cumuler plusieurs outils de gestion d’affinité peut entraîner des conflits si chacun applique des masques différents.
🧼 Avec Physical Core Optimizer, vous n'avez besoin de rien d’autre.

📦 Installation :
1. Récupérez l’archive "Physical Core Optimizer"
2. Placez tous les fichiers dans le dossier racine de votre jeu Skyrim

🎮 Si vous n’utilisez pas de gestionnaire comme Mod Organizer,
il suffit de lancer le fichier .bat correspondant à votre langue :
- 🇫🇷 _FR Physical Core Optimizer.bat
- 🇺🇸 _US Physical Core Optimizer.bat

Sinon si vous utiliser modorganiser, vous avez juste à ajouter le .bat comme ceci :
https://i.postimg.cc/tgDzg7cS/2-B8-B6-CD5-2-BA7-45-FD-B897-8-FB4-A9-B0-C294.png
Plus cas lancer via MO2 _FR Physical Core Optimizer qui ira chercher tout seul votre SKSE afin de l'optimiser !

🛑 Lancez toujours le script en tant qu'administrateur, sinon PowerShell ne pourra pas accéder aux informations de votre processeur.

🔍 Comment vérifier que ça fonctionne ?

1. Ouvrez PowerShell en tant qu’administrateur
2. Lancez votre jeu SANS le script
3. Tapez cette commande :

   Get-Process -Name SkyrimSE | Select-Object Name, Id, @{Name="ProcessorAffinity";Expression={($_.ProcessorAffinity).ToString("X")}}

Exemple :

Name     Id     ProcessorAffinity
----     --     -----------------
SkyrimSE 23872  FFFFFFFF

Cela signifie que tous les cœurs sont utilisés.

🔁 Maintenant :
1. Fermez Skyrim
2. Lancez-le avec le script
3. Reprenez la commande PowerShell

Exemple :

Name     Id     ProcessorAffinity
----     --     -----------------
SkyrimSE 10384  55555555

✅ Cela confirme que seuls les cœurs physiques sont utilisés. La valeur dépend de votre processeur et changera par rapport à celle que je vous et montré pour l'exemple. 

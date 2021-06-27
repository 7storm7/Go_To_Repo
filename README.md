# Go_To_Repo
Bash script to go repo folder with repo name

This bash script can be used to navigate to the path of a given repo name that exists in aosp manifest file under .repo/manifests.

It currently supports MacOS terminals. Technologies: Bash heredoc and Applescript.
Linux support is under development.

Usage:
* Go to the main folder of aosp that contains .repo folder
* ./go-to-repo.sh <repo full/partial name>
* If there are multiple entries in repo manifest related to the give repo name, display a dialog with path options for you to select one,
* And it cd makes you swithc to the repo location in aosp.

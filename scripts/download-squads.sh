git clone https://github.com/xAranaktu/FIFASquadFileDownloader downloader

if ! cd downloader; then
	echo "Failed to clone the repository."
	exit 1
fi

sed -i 's/if platform\["name"\] == "sta":/if platform\["name"\] != "pc64":/' main.py

python3 main.py

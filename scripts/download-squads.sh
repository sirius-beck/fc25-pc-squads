git clone https://github.com/xAranaktu/FIFASquadFileDownloader downloader

if ! cd downloader; then
  echo "Failed to clone the repository."
  exit 1
fi

python3 main.py

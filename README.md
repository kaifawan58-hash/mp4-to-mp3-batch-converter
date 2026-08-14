# 🎵 MP4 to MP3 Batch Converter (Windows)

A lightweight, self-contained Windows Batch tool that converts all `.mp4` files in a folder into compressed, tagless `.mp3` audio files — no manual setup required.

## ✨ Features

- 🔍 **Auto-detects** all `.mp4` files in the script's folder
- 🎚 **Configurable audio settings** — bitrate, channels, and sample rate (edit 3 variables at the top of the script)
- 📦 **Zero manual setup** — automatically finds `ffmpeg.exe` next to the script, in your system `PATH`, or downloads a portable copy on first run
- 🏷 **Strips all metadata** — no ID3 tags, album art, or track info in the output files
- ✂️ **Smart short filenames** — long, messy video titles are automatically shortened to 1–2 words for clean output file names (with automatic de-duplication)
- 🧵 **Handles special characters & spaces** in filenames safely
- 🖥 **Single `.bat` file** — no extra scripts, installers, or dependencies to manage

## 🚀 Usage

1. Download `mp4_to_mp3_44100.bat` and place it in the folder containing your `.mp4` files.
2. (Optional but recommended) Place `ffmpeg.exe` in the same folder for instant conversion — otherwise the script will download it automatically on first run.
3. Double-click the `.bat` file.
4. Converted MP3 files will appear in a new `mp3_output` subfolder.

## ⚙️ Default Settings

| Setting      | Value        |
|--------------|--------------|
| Bitrate      | 64 kbps (CBR) |
| Channels     | Mono (1)     |
| Sample Rate  | 22,050 Hz    |
| Metadata     | Stripped     |

Edit the top of the script to change these:

```bat
set "BITRATE=64k"
set "CHANNELS=1"
set "SAMPLERATE=22050"
```

## 🛠 Requirements

- Windows 10 / 11
- Internet connection (only needed once, if `ffmpeg.exe` isn't already present)

## 📄 License

MIT — free to use, modify, and share.

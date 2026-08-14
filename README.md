# 🎵 Universal Media to MP3 Converter (Windows)

> Created and maintained by **Saif**

An interactive, self-contained Windows Batch tool that converts video/audio files (MP4, MKV, AVI, MOV, WEBM, WAV, M4A, FLAC, WMA) into compressed, tagless `.mp3` files — with full control over quality settings, right from a simple menu.

## ✨ Features

- 🎞 **Multiple input formats** — MP4, MKV, AVI, MOV, WEBM, WAV, M4A, FLAC, WMA
- 🧭 **Interactive menus** — choose file type, bitrate, channels, and sample rate at runtime (no editing the script)
- 📖 **Explains every option** — each menu shows what each setting does to quality and file size before you choose
- 📦 **Zero manual setup** — automatically finds `ffmpeg.exe` next to the script, in your system `PATH`, or downloads a portable copy on first run
- 🏷 **Strips all metadata** — no ID3 tags, album art, or track info in the output files
- ✂️ **Optional short filenames** — long, messy titles can be shortened to 1–2 words automatically (with de-duplication), or you can keep original names
- 🧵 **Handles special characters & spaces** in filenames safely
- 🖥 **Single `.bat` file** — no extra scripts, installers, or dependencies to manage

## 🚀 Usage

1. Download `media_to_mp3_converter.bat` and place it in the folder containing your media files.
2. Double-click the `.bat` file.
3. Follow the on-screen menu:
   - Select file type to convert
   - Select bitrate
   - Select channels (Mono/Stereo)
   - Select sample rate
   - Choose whether to shorten output file names
4. Converted MP3 files will appear in a new `mp3_output` subfolder.

## ⚙️ Menu Options

**Bitrate**

| Option | Effect |
|---|---|
| 32 kbps | Smallest size, noticeably muffled. Speech only. |
| 64 kbps | Small size, OK for speech/podcasts, weak for music. |
| 96 kbps | Balanced, decent for music on small devices. |
| 128 kbps | Standard "good enough" quality, most common choice. |
| 192 kbps | Clearly better music quality, bigger file size. |
| 320 kbps | Best MP3 quality possible, largest file size. |

**Channels**

| Option | Effect |
|---|---|
| Mono | Half the file size, sound is centered/flat. Fine for speech. |
| Stereo | Full left/right separation, fuller sound, bigger file. |

**Sample Rate**

| Option | Effect |
|---|---|
| 16000 Hz | Telephone quality, speech only. |
| 22050 Hz | Small file, duller highs, OK for speech/lectures. |
| 32000 Hz | Acceptable for casual music listening. |
| 44100 Hz | CD quality — recommended for music. |
| 48000 Hz | Studio/video standard, slightly bigger file. |

## 🛠 Requirements

- Windows 10 / 11
- Internet connection (only needed once, if `ffmpeg.exe` isn't already present)

## ⚠️ Note: Why `ffmpeg.exe` is NOT included in this repo

`ffmpeg.exe` (the full build with encoders like `libmp3lame`) is typically **60–90+ MB**, which exceeds **GitHub's 25 MB file upload limit** through the web UI, and bloats the repository unnecessarily even via Git.

Instead, this script handles it automatically:
- If `ffmpeg.exe` already exists next to the script, it's used directly.
- If `ffmpeg` is available in your system `PATH`, it's used directly.
- Otherwise, the script **automatically downloads** a portable ffmpeg build from [gyan.dev](https://www.gyan.dev/ffmpeg/builds/) on first run and sets it up — no manual steps required.

This keeps the repository lightweight while still giving you a fully working, zero-setup tool.

## 🙌 Credit

Built and maintained by **Saif**.
If this tool saved you time, consider ⭐ starring the repo!

## 📄 License

MIT — free to use, Not Allow to modify, and share possible.

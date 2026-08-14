# 🎵 Universal Media to MP3/Audio Converter (Windows)

> Created and maintained by **Saaif**

A single, self-contained Windows `.bat` file that converts video/audio files (MP4, MKV, AVI, MOV, WEBM, WAV, M4A, FLAC, WMA) into MP3, WAV, AAC, or OGG — with an interactive menu covering every important quality and workflow setting. No installers, no extra scripts to manage — just one file.

## ✨ Features

- 🎞 **Multiple input formats** — MP4, MKV, AVI, MOV, WEBM, WAV, M4A, FLAC, WMA (pick one or several at once)
- 🎧 **Multiple output formats** — MP3, WAV, AAC (m4a), OGG
- 🎚 **CBR or VBR** — choose constant or variable bitrate, with an explanation of each option
- 🔊 **Volume normalization** — even out loudness across a batch of files
- ✂️ **Trim support** — convert only a specific start time + duration instead of the whole file
- 📁 **Custom output folder** — or use the smart default
- 🔁 **Recursive subfolder scanning** — optionally include files inside subfolders
- ✂️ **Optional short filenames** — long, messy titles shortened to 1–2 words automatically (with de-duplication)
- ⏭ **Skip already-converted files** — safe to re-run on a folder without redoing finished work
- 💾 **Remembers your settings** — save your chosen settings and reuse them next time with one keypress
- 📊 **Live progress + ETA** — see file count, percentage, and estimated time remaining
- 🏷 **Strips all metadata** — no ID3 tags, album art, or track info in the output
- 📦 **Zero manual setup** — automatically finds `ffmpeg.exe` next to the script, in your system `PATH`, or downloads a portable copy on first run
- 🖱 **Drag & drop support** — drop files or a folder onto the `.bat` to convert just those
- 🖥 **Single `.bat` file** — everything (including the conversion engine logic) is self-contained inside one file

## 🚀 Usage

1. Download `media_to_mp3_converter.bat` and place it in the folder containing your media files.
2. Double-click the `.bat` file (or drag files/a folder onto it).
3. Follow the on-screen menu — each option explains what it does to quality and file size before you choose.
4. Converted files will appear in your chosen output folder (default: a subfolder named after the output format, e.g. `mp3_output`).

## ⚙️ Menu Options at a Glance

**Bitrate (CBR)**

| Option | Effect |
|---|---|
| 32 kbps | Smallest size, noticeably muffled. Speech only. |
| 64 kbps | Small size, OK for speech/podcasts, weak for music. |
| 96 kbps | Balanced, decent for music on small devices. |
| 128 kbps | Standard "good enough" quality, most common choice. |
| 192 kbps | Clearly better music quality, bigger file size. |
| 320 kbps | Best MP3 quality possible, largest file size. |

**VBR Quality** (0 = best/largest, 9 = worst/smallest)

**Channels:** Mono (smaller, centered sound) or Stereo (fuller sound, bigger file)

**Sample Rate:** 16000 Hz (telephone) up to 48000 Hz (studio/video standard); 44100 Hz is CD quality and recommended for music.

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

## 🐢 Why Is Conversion Sometimes Slow?

A few common reasons:

1. **CPU-bound encoding** — MP3/AAC/OGG encoding is done entirely on your CPU (not GPU-accelerated), so speed depends heavily on your processor. Older/weaker CPUs will take noticeably longer per file.
2. **High input resolution/bitrate video** — Even though only the audio is extracted, ffmpeg still has to **decode** the entire video stream first before discarding it, so a large 4K/1080p file takes longer to process than a small one, even for audio-only output.
3. **Volume normalization enabled** — The `loudnorm` filter requires ffmpeg to analyze the entire audio track in a first pass before encoding, roughly doubling the time for that file. Turn it off if speed matters more than consistent loudness.
4. **VBR mode** — Variable bitrate encoding does more analysis per audio frame than fixed CBR, so it's slightly slower (though usually not dramatically so).
5. **Disk speed** — Reading large source files and writing output from/to a slow HDD (vs SSD) or a network/USB drive adds overhead.
6. **Many files in one run** — The script processes files one at a time (not in parallel), so total time scales with the number of files, not just their individual size.
7. **Background downloads** — If `ffmpeg.exe` wasn't already present, the first run includes a one-time ~70–80 MB download, which can look like "slow conversion" but is actually just the download step.

**To speed things up:** turn off normalization if you don't need it, use CBR instead of VBR, keep source files on an SSD, and avoid trimming huge 4K video files (a lower-quality source file converts faster).

## 🙌 Credit

Built and maintained by **Saif**.
If this tool saved you time, consider ⭐ starring the repo!

## 📄 License

MIT — free to use, and share ,Not Allow Not Modify.

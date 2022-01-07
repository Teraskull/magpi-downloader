<h1 align="center">
  MagPi Downloader
</h1>

<p align="center">
    Download all <a href="https://magpi.raspberrypi.com/issues/">MagPi</a> and <a href="https://hackspace.raspberrypi.com/issues/">Hackspace</a> issues with an automated script.
</p>

<p align="center">
  <a style="text-decoration:none">
    <img src="https://img.shields.io/badge/OS-Linux-blue?style=flat-square&color=00B16A" alt="OS" />
  </a>
</p>


## Installing

```bash
git clone https://github.com/Teraskull/magpi-downloader

cd magpi-downloader

sudo chmod +x magpi-issue-downloader.sh
```


## Usage
```bash
./magpi-issue-downloader.sh
```


## Examples
To download only MagPi issues, set the `HACKSPACE_FIRST` and `HACKSPACE_LATEST` variables to `0`:
```bash
MAGPI_FIRST=1
HACKSPACE_FIRST=0
MAGPI_LATEST=113
HACKSPACE_LATEST=0
```

To download a specific MagPi issue, set both `MAGPI_FIRST` and `MAGPI_LATEST` to the respective issue number.

> All issues will be downloaded under the `issues/magpi` and `issues/hackspace` directories.
>
> All download URLs are saved in `issues/magpi/issues.txt` and `issues/hackspace/issues.txt`.


## License

Distributed under the MIT License. See [`LICENSE`](/LICENSE) for more information.

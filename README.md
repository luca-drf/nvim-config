# nvim config

## Install

```
mkdir -p ~/.config && \
git clone https://github.com/luca-drf/nvim-config.git ~/.config/nvim
```

### Python Setup (pyenv)

```
pyenv virtualenv <python version> pynvim
pyenv activate pynvim
pip install pynvim
```

## Remove

```
rm -rf ~/.config/nvim && \
rm -rf ~/.local/share/nvim && \
rm -rf ~/.local/state/nvim && \
rm -rf ~/.cache/nvim
```

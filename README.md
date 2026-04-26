# Abrahán Mesa Blog

Jekyll blog prepared for GitHub Pages.

## Local preview

On this macOS setup, Ruby reports `CXX=false`, so `eventmachine` needs an explicit C++ compiler wrapper the first time dependencies are installed:

```bash
MAKE='make CXX=/path/to/this/repository/scripts/clang++-sdk' bundle install
```

Start the local preview server with:

```bash
bundle exec jekyll serve --host 127.0.0.1 --port 4001
```

Then open <http://127.0.0.1:4001>.

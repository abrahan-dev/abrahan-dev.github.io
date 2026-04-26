# Abrahán Mesa Blog

Jekyll blog prepared for GitHub Pages.

## Local preview

On this macOS setup, Ruby reports `CXX=false`, so `eventmachine` needs an explicit C++ compiler wrapper the first time dependencies are installed:

```bash
MAKE='make CXX=/path/to/this/repository/scripts/clang++-sdk' bundle install
```

Start the local preview server with:

```bash
ruby scripts/serve-local.rb
```

Then open <http://127.0.0.1:4001>.

The wrapper always uses port `4001`. If the preview server is already running,
it exits cleanly instead of starting a second Jekyll process and raising
`Address already in use`.

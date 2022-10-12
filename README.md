# Say

Text-to-Speech module for Elixir.

It exposes a function `Say.say/1` that tells the underlying OS or through a SSH tunnel to say the given text.

# Usage

```
Import Say

def say_hello() do
    say("hello")
end
```

# Configuration

In the file 'project/config/config.exs'

## Say via function
```
config :say,
  :func, &IO.inspect/1
```

## Say directly with OS fatures
```
config :say,
  exec: "say",
```

On the Mac the executable 'say' can be used directly.

On Linux I haven't tried, but these should work [command-line-text-speech-apps-linux](https://linuxhint.com/command-line-text-speech-apps-linux/)

# Say via SSH tunnel
```
config :say,
  exec: "say",
  ssh_args: ~w(-p 2209 localhost)
```

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `say` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:say, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at <https://hexdocs.pm/say>.


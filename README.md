# Say

Text-to-Speech module for Elixir.

It exposes a function `Say.say/1` that tells the underlying OS or through a SSH tunnel to say the given text.

## HexDocs

The Elixir Module can be found at <https://hexdocs.pm/say>.

## Why?

While programming I found it very useful to get acustic feedback from some background jobs which execute elixir code.

One concrete sample is when RiotJS markup files has to be compiled to JavaScript. This watch-compile-loop is implemented with elixir, and when a compile fails, my laptop says "riot compile error".

## Usage

```
Import Say

def foo() do
  if func() do
    say("success")
  else
    say("error in foo")
  end
end
```

## Configuration

In the file 'project/config/config.exs'

### Say via function
```
config :say,
  :func, &IO.inspect/1
```

### Say directly with OS fatures
```
config :say,
  exec: "say",
```

On the Mac the executable 'say' can be used directly.

On Linux I haven't tried, but these should work [command-line-text-speech-apps-linux](https://linuxhint.com/command-line-text-speech-apps-linux/)

### Say via SSH tunnel
```
config :say,
  exec: "say",
  ssh_args: ~w(-p 2209 localhost)
```

## Installation

The package can be installed by adding `say` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:say, "~> 0.1.0"}
  ]
end
```


defmodule Say do
  @moduledoc """
  Lets the System say a given text via text-to-speech.

  ## Why?

  While programming I found it very useful to get acustic feedback from some background jobs which execute elixir code.

  One concrete sample is when RiotJS markup files has to be compiled to JavaScript. This watch-compile-loop is implemented with elixir, and when a compile fails, my laptop says "riot compile error".

  ## Usage

      Import Say

      def foo() do
        if func() do
          say("success")
        else
          say("error in foo")
        end
      end

  ## Configuration (How to say something)

  You can configure the way how to say something...

  via an elixir function:

      config :say,
         func: &IO.inspect/1

  via shell command:

      config :say,
         exec: "say"

      config :say,
         exec: "say",
         exec_args: ~w(-v somevoice)

  via shell command over an SSH tunnel:

      config :say,
         exec: "say",
         ssh_args: ~w(-p 2222 localhost)

      config :say,
         exec: "say",
         exec_args: ~w(-v somevoice),
         ssh_args: ~w(-p 2222 localhost)

  ## SSH-Tunneling Use-Cases

  ### Setup a reverse tunnel into a local VM

  If working on a Mac or Linux with text-to-speech and the Elixir app is inside a VM you can set a reverse tunnel from the VM host inside the VM guest over the VM_PORT, so that the upper config works:

      my-mac $ ssh -p VM_PORT -NTR 2222:localhost:22 localhost

  ### Setup a local tunnel into another Mac/Linux

  If your Elixir development environment has no text-to-speech and you have access to a Mac or Linux box with text-to-speech, then you can setup a tunnel to the other Mac/Linux with

      my-elixir $ ssh -NTL 2222:localhost:22 my-mac

  ## OS specialities

    * On the Mac the executable `say` can be used directly.

    * On Linux I haven't tried, but these should work [https://linuxhint.com/command-line-text-speech-apps-linux/](https://linuxhint.com/command-line-text-speech-apps-linux/)

  """

  @doc """
  Lets the system say the given `text`.

  `text` is expected to be a binary.

  Returns a tuple containing :ok or :error, the collected result
  and the command exit status.

  * Throws an `ArgumentError` if `:exec_args` or `:ssh_args` exist but are not a list of binaries
    and `:exec` exists but is not a binary.
  * Throws an `ArgumentError` if `text` is not a binary.

  ## Examples

      iex> Say.say("hello")
      {:ok, "hello", 0}

  """
  @spec say(binary) :: {:ok | :error, Collectable.t(), exit_status :: non_neg_integer}
  def say(text) when is_binary(text) do
    func = Application.get_env(:say, :func)
    exec = Application.get_env(:say, :exec)
    exec_args = Application.get_env(:say, :exec_args)
    ssh_args = Application.get_env(:say, :ssh_args)

    if exec && !is_binary(exec), do: raise(ArgumentError, "exec must be a binary")

    if exec_args do
      if !is_list(exec_args), do: raise(ArgumentError, "exec_args must be a list of binaries")

      unless Enum.all?(exec_args, &is_binary/1),
        do: raise(ArgumentError, "all exec_args must be binaries")
    end

    if ssh_args do
      if !is_list(ssh_args), do: raise(ArgumentError, "ssh_args must be a list of binaries")

      unless Enum.all?(ssh_args, &is_binary/1),
        do: raise(ArgumentError, "all ssh_args must be binaries")
    end

    do_say(text, func, exec, exec_args, ssh_args)
  end

  defp do_say(text, func, exec, _exec_args, ssh_args)
       when func != nil and exec == nil and ssh_args == nil do
    result = func.(text)
    {:ok, result, 0}
  end

  defp do_say(text, func, exec, exec_args, ssh_args)
       when func == nil and exec != nil and exec_args != nil and ssh_args == nil do
    cmd = exec
    args = (exec_args ++ [text]) |> Enum.reject(&is_nil/1)
    do_system_cmd(cmd, args)
  end

  defp do_say(text, func, exec, exec_args, ssh_args)
       when func == nil and exec != nil and exec_args == nil and ssh_args == nil do
    cmd = exec
    args = [text]
    do_system_cmd(cmd, args)
  end

  defp do_say(text, func, exec, exec_args, ssh_args)
       when func == nil and exec != nil and ssh_args != nil do
    cmd = "ssh"
    exec_args = if exec_args != nil, do: exec_args, else: []
    args = (ssh_args ++ [exec] ++ exec_args ++ [text]) |> Enum.reject(&is_nil/1)
    do_system_cmd(cmd, args)
  end

  defp do_say(_text, _func, _exec, _exec_args, _ssh_args) do
    raise ArgumentError, "see config samples"
  end

  defp do_system_cmd(cmd, args) do
    if Application.get_env(:say, :test) do
      {cmd, args}
    else
      {result, exit_code} = System.cmd(cmd, args)

      case exit_code do
        0 -> {:ok, result, 0}
        e -> {:error, result, e}
      end
    end
  end
end

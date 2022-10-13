defmodule Say do
  @moduledoc """
  Lets the System say a given text via text-to-speech.

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
         exec: "say"
         exec_args: ~w(-v somevoice)

  via shell command over an SSH tunnel:

      config :say,
         exec: "say",
         ssh_args: ~w(-p 2222 localhost)

      config :say,
         exec: "say",
         exec_args: ~w(-v somevoice)
         ssh_args: ~w(-p 2222 localhost)

  ## OS specialities

    * On the Mac the executable `say` can be used directly.

    * On Linux I haven't tried, but these should work [https://linuxhint.com/command-line-text-speech-apps-linux/](https://linuxhint.com/command-line-text-speech-apps-linux/)

  """

  @doc """
  Lets the system say the given `text`.

  `text` is expected to be a binary.

  Returns a tuple containing :ok or :error, the collected result
  and the command exit status.

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

    if exec && !is_binary(exec), do: raise ArgumentError, "exec must be a binary"
    if exec_args do
      if !is_list(exec_args), do: raise ArgumentError, "exec_args must be a list of binaries"
      unless Enum.all?(exec_args, &is_binary/1), do: raise ArgumentError, "all exec_args must be binaries"
    end
    if ssh_args do
      if !is_list(ssh_args), do: raise ArgumentError, "ssh_args must be a list of binaries"
      unless Enum.all?(ssh_args, &is_binary/1), do: raise ArgumentError, "all ssh_args must be binaries"
    end

    do_say(text, func, exec, exec_args, ssh_args)
  end

  defp do_say(text, func, exec, _exec_args, ssh_args) when func != nil and exec == nil and ssh_args == nil do
    result = func.(text)
    {:ok, result, 0}
  end

  defp do_say(text, func, exec, exec_args, ssh_args) when func == nil and exec != nil and exec_args != nil and ssh_args == nil do
    cmd = exec
    args = exec_args ++ [text] |> Enum.reject(&is_nil/1)
    do_system_cmd(cmd, args)
  end

  defp do_say(text, func, exec, exec_args, ssh_args) when func == nil and exec != nil and exec_args == nil and ssh_args == nil do
    cmd = exec
    args = [text]
    do_system_cmd(cmd, args)
  end

  defp do_say(text, func, exec, exec_args, ssh_args) when func == nil and exec != nil and ssh_args != nil do
    cmd = "ssh"
    exec_args = if exec_args != nil, do: exec_args, else: []
    args = ssh_args ++ [exec] ++ exec_args ++ [text] |> Enum.reject(&is_nil/1)
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

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
  Lets the system say the given text.

  ## Examples

      iex> Say.say("hello")

  """
  def say(text) do
    do_say(text,
      Application.get_env(:say, :func),
      Application.get_env(:say, :exec),
      Application.get_env(:say, :exec_args),
      Application.get_env(:say, :ssh_args)
    )
  end

  defp do_say(text, func, exec, _exec_args, ssh_args) when func != nil and exec == nil and ssh_args == nil do
    func.(text)
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
    raise RuntimeError, message: "see config samples"
  end

  defp do_system_cmd(cmd, args) do
    if Application.get_env(:say, :test) do
      {cmd, args}
    else
      System.cmd(cmd, args)
    end
  end

end

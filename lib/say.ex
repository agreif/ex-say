defmodule Say do
  @moduledoc """
  Lets the System say a text via text-to-speech.

  config :say,
         func: &IO.inspect/1

  config :say,
         exec: "say"

  config :say,
         exec: "say",
         ssh_args: ~w(-p 2222 localhost)
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
      Application.get_env(:say, :ssh_args)
    )
  end

  defp do_say(text, func, exec, ssh_args) when func != nil and exec == nil and ssh_args == nil do
    func.("say via func: " <> text)
  end

  defp do_say(text, func, exec, ssh_args) when func == nil and exec != nil and ssh_args == nil do
    System.cmd(exec, text)
  end

  defp do_say(text, func, exec, ssh_args) when func == nil and exec != nil and ssh_args != nil do
    System.cmd("ssh", ssh_args ++ [exec] ++ [text])
  end

end

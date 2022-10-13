defmodule SayTest do
  use ExUnit.Case
  # doctest Say

  @error_msg "see config samples"

  test "say raises error with func=nil, exec=nil, exec_args=nil, ssh_args=nil" do
    Application.put_env(:say, :test, true)
    Application.put_env(:say, :func, nil)
    Application.put_env(:say, :exec, nil)
    Application.put_env(:say, :exec_args, nil)
    Application.put_env(:say, :ssh_args, nil)
    assert_raise RuntimeError, @error_msg, fn ->
  Say.say("foo")
end
  end

  test "say raises error with func!=nil exec=!nil, exec_args=nil, ssh_args=nil" do
    Application.put_env(:say, :test, true)
    Application.put_env(:say, :func, &Function.identity/1)
    Application.put_env(:say, :exec, "say")
    Application.put_env(:say, :exec_args, nil)
    Application.put_env(:say, :ssh_args, nil)
    assert_raise RuntimeError, @error_msg, fn ->
  Say.say("foo")
end
  end

  test "say raises error with func!=nil, exec=nil, exec_args=nil, ssh_args!=nil" do
    Application.put_env(:say, :test, true)
    Application.put_env(:say, :func, &Function.identity/1)
    Application.put_env(:say, :exec, nil)
    Application.put_env(:say, :exec_args, nil)
    Application.put_env(:say, :ssh_args, "-p 2222")
    assert_raise RuntimeError, @error_msg, fn ->
  Say.say("foo")
end
  end

  test "say raises error with func=nil, exec=nil, exec_args=nil, ssh_args!=nil" do
    Application.put_env(:say, :test, true)
    Application.put_env(:say, :func, nil)
    Application.put_env(:say, :exec, nil)
    Application.put_env(:say, :exec_args, nil)
    Application.put_env(:say, :ssh_args, "-p 2222 localhost")
    assert_raise RuntimeError, @error_msg, fn ->
  Say.say("foo")
end
  end

  test "say with func!=nil, exec=nil, exec_args=nil, ssh_args=nil" do
    Application.put_env(:say, :test, true)
    Application.put_env(:say, :func, &Function.identity/1)
    Application.put_env(:say, :exec, nil)
    Application.put_env(:say, :exec_args, nil)
    Application.put_env(:say, :ssh_args, nil)
    assert Say.say("foo") == "foo"
  end

  test "say with func=nil, exec!=nil, exec_args=nil, ssh_args=nil" do
    Application.put_env(:say, :test, true)
    Application.put_env(:say, :func, nil)
    Application.put_env(:say, :exec, "say")
    Application.put_env(:say, :exec_args, nil)
    Application.put_env(:say, :ssh_args, nil)
    assert Say.say("foo") == {"say", ["foo"]}
  end

  test "say with func=nil, exec!=nil, exec_args=!nil, ssh_args=nil" do
    Application.put_env(:say, :test, true)
    Application.put_env(:say, :func, nil)
    Application.put_env(:say, :exec, "say")
    Application.put_env(:say, :exec_args, ~w(-v somevoice))
    Application.put_env(:say, :ssh_args, nil)
    assert Say.say("foo") == {"say", ["-v", "somevoice", "foo"]}
  end

  test "say with func=nil, exec!=nil, exec_args=nil, ssh_args!=nil" do
    Application.put_env(:say, :test, true)
    Application.put_env(:say, :func, nil)
    Application.put_env(:say, :exec, "say")
    Application.put_env(:say, :exec_args, nil)
    Application.put_env(:say, :ssh_args, ~w(-p 2222 localhost))
    assert Say.say("foo") == {"ssh", ["-p", "2222", "localhost", "say", "foo"]}
  end

  test "say with func=nil, exec!=nil, exec_args!=nil, ssh_args!=nil" do
    Application.put_env(:say, :test, true)
    Application.put_env(:say, :func, nil)
    Application.put_env(:say, :exec, "say")
    Application.put_env(:say, :exec_args, ~w(-v somevoice))
    Application.put_env(:say, :ssh_args, ~w(-p 2222 localhost))
    assert Say.say("foo") == {"ssh", ["-p", "2222", "localhost", "say", "-v", "somevoice", "foo"]}
  end

end

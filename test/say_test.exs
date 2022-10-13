defmodule SayTest do
  use ExUnit.Case
  # doctest Say

  @config_error_msg "see config samples"

  test "say raises error with func=nil, exec=nil, exec_args=nil, ssh_args=nil" do
    Application.put_env(:say, :test, true)
    Application.put_env(:say, :func, nil)
    Application.put_env(:say, :exec, nil)
    Application.put_env(:say, :exec_args, nil)
    Application.put_env(:say, :ssh_args, nil)
    assert_raise ArgumentError, @config_error_msg, fn ->
      Say.say("foo")
    end
  end

  test "say raises error with func!=nil exec=!nil, exec_args=nil, ssh_args=nil" do
    Application.put_env(:say, :test, true)
    Application.put_env(:say, :func, &Function.identity/1)
    Application.put_env(:say, :exec, "say")
    Application.put_env(:say, :exec_args, nil)
    Application.put_env(:say, :ssh_args, nil)
    assert_raise ArgumentError, @config_error_msg, fn ->
      Say.say("foo")
    end
  end

  test "say raises error with func!=nil, exec=nil, exec_args=nil, ssh_args!=nil" do
    Application.put_env(:say, :test, true)
    Application.put_env(:say, :func, &Function.identity/1)
    Application.put_env(:say, :exec, nil)
    Application.put_env(:say, :exec_args, nil)
    Application.put_env(:say, :ssh_args, ~w(-p 2222))
    assert_raise ArgumentError, @config_error_msg, fn ->
      Say.say("foo")
    end
  end

  test "say raises error with func=nil, exec=nil, exec_args=nil, ssh_args!=nil" do
    Application.put_env(:say, :test, true)
    Application.put_env(:say, :func, nil)
    Application.put_env(:say, :exec, nil)
    Application.put_env(:say, :exec_args, nil)
    Application.put_env(:say, :ssh_args, ~w(-p 2222 localhost))
    assert_raise ArgumentError, @config_error_msg, fn ->
      Say.say("foo")
    end
  end

  test "say raises error with func=nil, exec!=nil, exec_args!=nil, ssh_args=nil but exec_args not list" do
    Application.put_env(:say, :test, true)
    Application.put_env(:say, :func, nil)
    Application.put_env(:say, :exec, "say")
    Application.put_env(:say, :exec_args, "-v somevoice")
    Application.put_env(:say, :ssh_args, nil)
    assert_raise ArgumentError, "exec_args must be a list of binaries", fn ->
      Say.say("foo")
    end
  end

  test "say raises error with func=nil, exec!=nil, exec_args=nil, ssh_args!=nil but ssh_args not list" do
    Application.put_env(:say, :test, true)
    Application.put_env(:say, :func, nil)
    Application.put_env(:say, :exec, "say")
    Application.put_env(:say, :exec_args, nil)
    Application.put_env(:say, :ssh_args, "-p 2222 localhost")
    assert_raise ArgumentError, "ssh_args must be a list of binaries", fn ->
      Say.say("foo")
    end
  end

  test "say raises error with func=nil, exec!=nil, exec_args=nil, ssh_args=nil but exec is not a binary" do
    Application.put_env(:say, :test, true)
    Application.put_env(:say, :func, nil)
    Application.put_env(:say, :exec, 123)
    Application.put_env(:say, :exec_args, nil)
    Application.put_env(:say, :ssh_args, nil)
    assert_raise ArgumentError, "exec must be a binary", fn ->
      Say.say("foo")
    end
  end

  test "say with func!=nil, exec=nil, exec_args=nil, ssh_args=nil" do
    Application.put_env(:say, :test, true)
    Application.put_env(:say, :func, &Function.identity/1)
    Application.put_env(:say, :exec, nil)
    Application.put_env(:say, :exec_args, nil)
    Application.put_env(:say, :ssh_args, nil)
    assert Say.say("foo") == {:ok, "foo", 0}
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

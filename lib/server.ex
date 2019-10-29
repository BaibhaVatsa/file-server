defmodule Server do
  require Logger

  def start_link(port: port) do
    {:ok, socket} = :gen_tcp.listen(port, active: false, packet: :http_bin, reuseaddr: true)
    Logger.info("Accepting connections on port #{port}")

    {:ok, spawn_link(Server, :accept, [socket])}
  end

  def accept(socket) do
    {:ok, request} = :gen_tcp.accept(socket)

    spawn(fn ->
      html = File.read!("index.html")
      css = File.read!("style.css")

      responsehtml = """
      HTTP/1.1 200\r
      Content-Type: text/html\r
      Content-Length: #{byte_size(html)}\r
      \r
      #{html}
      """

      send_response(responsehtml, request)
    end)

    accept(socket)
  end

  def send_response(response, request) do
    :gen_tcp.send(request, response)
    :gen_tcp.close(request)
  end

  def child_spec(opts) do
    %{id: Server, start: {Server, :start_link, [opts]}}
  end
end

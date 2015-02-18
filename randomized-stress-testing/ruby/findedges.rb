require "randomized"
require "socket"
require "rspec/stress_it"

RSpec.configure do |c|
  c.extend RSpec::StressIt
end

describe TCPServer do
  subject(:socket) { Socket.new(Socket::AF_INET, Socket::SOCK_STREAM, 0) }
  let(:sockaddr) { Socket.sockaddr_in(port, "127.0.0.1") }
  after { socket.close }

  context "on a random port" do
    let(:port) { Randomized.number(-100000..100000) }
    fuzz "should bind successfully", [:port] do
      socket.bind(sockaddr)
      expect(socket.local_address.ip_port).to(be == port)
    end
  end
end

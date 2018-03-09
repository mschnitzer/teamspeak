require_relative 'spec_helper.rb'
require 'socket'

describe TeamSpeak3::Server do
  describe '#initialize' do
    context 'attr_reader' do
      let(:server) { FactoryBot.build(:server) }

      it { expect(server.ip_address).to eq('127.0.0.1') }
      it { expect(server.query_port).to eq(10011) }
    end
  end

  describe '#connect' do
    let(:query_port) { rand(50000..60000) }
    let(:server) { FactoryBot.build(:server, ip_address: '127.0.0.1', query_port: query_port) }

    describe 'telnet connection' do
      context 'for a valid TeamSpeak 3 server' do
        before do
          # spawn a tcp server for connection tests
          Thread.new(query_port) do |query_port|
            tcp_server = TCPServer.new('127.0.0.1', query_port)
            client = tcp_server.accept
            client.puts "Welcome to the TeamSpeak 3 ServerQuery interface"
            sleep 3
            client.close
            tcp_server.close
          end

          # it takes a moment till the server has spawned
          sleep 2
        end

        it { expect { server.connect }.to_not raise_error }
      end

      context 'for a non-TeamSpeak 3 server' do
        before do
          # spawn a tcp server for connection tests
          Thread.new(query_port) do |query_port|
            tcp_server = TCPServer.new('127.0.0.1', query_port)
            client = tcp_server.accept
            client.puts "I'm not a TeamSpeak 3 server"
            sleep 3
            client.close
            tcp_server.close
          end

          # it takes a moment till the server has spawned
          sleep 2
        end

        it { expect { server.connect }.to raise_error(TeamSpeak3::Exceptions::ServerConnectionFailed, /welcome message/) }
      end
    end
  end

  describe '#prepare_command' do
    let(:server) { FactoryBot.build(:server) }

    context 'with options' do
      it { expect(server.prepare_command(:clientlist, options: [:uid, :away, :voice])).to eq('clientlist -uid -away -voice') }
    end

    context 'with parameters' do
      it { expect(server.prepare_command(:clientlist, argument1: 'hello', argument2: 'test')).to \
                  eq('clientlist argument1=hello argument2=test') }
    end

    context 'with parameters and options' do
      it { expect(server.prepare_command(:clientlist, argument1: 'hello', argument2: 'test', options: [:uid, :flags])).to \
                  eq('clientlist -uid -flags argument1=hello argument2=test') }
    end

    context 'with arrays as parameters' do
      it { expect(server.prepare_command(:clientkick, clid: [1,2,3], argument2: 'test')).to \
                  eq('clientkick clid=1|clid=2|clid=3 argument2=test') }
    end

    context 'argument encoding' do
      it { expect(server.prepare_command(:clientkick, argument1: 'I need | encoding!!')).to \
           eq("clientkick argument1=I\\sneed\\s\\p\\sencoding!!") }
      it { expect(server.prepare_command(:clientkick, argument: ['I need | encoding!!', 'me | too!!'])).to \
           eq("clientkick argument=I\\sneed\\s\\p\\sencoding!!|argument=me\\s\\p\\stoo!!") }
    end
  end
end

require_relative 'spec_helper.rb'

describe TeamSpeak3::Server do
  describe '#initialize' do
    context 'attr_reader' do
      before do
        @server = TeamSpeak3::Server.new('127.0.0.1', 10011)
      end

      it { expect(@server.ip_address).to eq('127.0.0.1') }
      it { expect(@server.query_port).to eq(10011) }
    end
  end
end

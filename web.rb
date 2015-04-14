require File.join(File.dirname(__FILE__),'boot')

class App < Roda
  use Rack::Session::Cookie, :secret => ENV['SECRET']
  plugin :render

  route do |r|
    r.on "admin" do
      r.on "stomp_messages" do
        r.get ':id.json' do |id|
          message = begin 
            Chopper::StompMessage[id]
          end
          r.redirect '/admin/stomp_messages' if message.nil?
          begin
            JSON.parse(message.message).to_json
          rescue
            message.message.to_json
          end
        end

        r.get ':id' do |id|
          message = begin
            Chopper::StompMessage[id]
          end
          r.redirect '/admin/stomp_messages' if message.nil?
          message.message
        end

        r.is do
          r.get do
            page = (r['page'] || 1).to_i
            @messages = Chopper::StompMessage.dataset.paginate(page, 50)
            view("stomp_messages_index")
          end
        end
      end
    end
  end
end

#run App.freeze.app

require File.join(File.dirname(__FILE__),'boot')

class App < Roda
  use Rack::Session::Cookie, :secret => ENV['SECRET']
  plugin :render, :template_opts => {:trim_mode => true}
  plugin :view_options

  route do |r|
    r.on 'rtppm' do
      r.get ':operator/:sector.json' do |operator,sector|
        @operator, @sector, @time_start, @time_end = [
          CGI::unescape(operator), CGI::unescape(sector), 
          r['start'].nil? ? Time.now - (60*60) : Time.at(r['start']),
          r['end'].nil? ? Time.now : Time.at(r['end'])
        ]
        response['Content-Type'] = 'application/json'
        Chopper::Rtppm.naked.where(:operator => @operator, :sector => @sector, :timestamp => @time_start..@time_end).order(:timestamp).select(:timestamp, :ppm, :rolling_ppm).to_a.to_json
      end
      r.get ':operator' do |operator|
        @operator = URI.unescape(operator)
        @time_start = r['start'] || Time.now - (60*60)
        @time_end = r['end'] || Time.now
        @sectors = Chopper::Rtppm.where(:operator => @operator).distinct.select(:sector).order(:sector)
        view('rtppm_operator')
      end
      r.get do
        @operators = Chopper::Rtppm.distinct.select(:operator).order(:operator)
        view('rtppm')
      end
    end
    r.on "admin" do
      set_layout_options :template => 'admin_layout'

      r.get "db_status" do
        if DB.database_type == :postgres
          @sizes = DB["SELECT relname AS relation, pg_size_pretty(pg_total_relation_size(C.oid)) AS total_size FROM pg_class C LEFT JOIN pg_namespace N ON (N.oid = C.relnamespace) WHERE nspname NOT IN ('pg_catalog', 'information_schema') AND C.relkind <> 'i' AND nspname !~ '^pg_toast' ORDER BY pg_total_relation_size(C.oid) DESC"]
        else
          r.redirect '/'
        end
        view("db_status")        
      end
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
          @data = JSON.pretty_generate(JSON.parse(message.message))
          view("stomp_messages_view")
        end

        r.is do
          r.get do
            page = (r['page'] || 1).to_i
            @messages = Chopper::StompMessage.dataset.order(Sequel.asc(:timestamp)).paginate(page, 50)
            view("stomp_messages_index")
          end
        end
      end
    end
  end
end

#run App.freeze.app

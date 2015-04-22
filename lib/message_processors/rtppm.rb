module Chopper
  module MessageProcessors
    class Rtppm < Chopper::MessageProcessors::Base
      def self.process(msg)
        ts = Time.at(msg['RTPPMDataMsgV1']['timestamp'].to_i / 1000)
        data = msg['RTPPMDataMsgV1']['RTPPMData']['NationalPage']['NationalPPM']
        Chopper::Rtppm.create(
          :operator => 'National', :timestamp => ts,
          :total_trains => data['Total'], :ontime_trains => data['OnTime'], :late_trains => data['Late'], :cancelverylate_trains => data['CancelVeryLate'],
          :ppm_rag => data['PPM']['rag'], :ppm => data['PPM']['text'], :rolling_ppm_rag => data['RollingPPM']['rag'], :rolling_ppm => data['RollingPPM']['text']
        )
        msg['RTPPMDataMsgV1']['RTPPMData']['NationalPage']['Sector'].each do |sector|
          data = sector['SectorPPM']
          Chopper::Rtppm.create(
            :operator => 'National', :sector => sector['sectorDesc'] == '' ? 'All' : sector['sectorDesc'], :timestamp => ts,
            :total_trains => data['Total'], :ontime_trains => data['OnTime'], :late_trains => data['Late'], :cancelverylate_trains => data['CancelVeryLate'],
            :ppm_rag => data['PPM']['rag'], :ppm => data['PPM']['text'], :rolling_ppm_rag => data['RollingPPM']['rag'], :rolling_ppm => data['RollingPPM']['text']
          )
        end
        msg['RTPPMDataMsgV1']['RTPPMData']['OperatorPage'].each do |operator|
          data = operator['Operator']
          operator_name = operator['Operator']['name']
          Chopper::Rtppm.create(
            :operator => operator_name, :timestamp => ts,
            :total_trains => data['Total'], :ontime_trains => data['OnTime'], :late_trains => data['Late'], :cancelverylate_trains => data['CancelVeryLate'],
            :ppm_rag => data['PPM']['rag'], :ppm => data['PPM']['text'], :rolling_ppm_rag => data['RollingPPM']['rag'], :rolling_ppm => data['RollingPPM']['text']
          )
          if operator.fetch('OprServiceGrp',[]).is_a?(Hash)
            data = operator['OprServiceGrp']
            Chopper::Rtppm.create(
              :operator => operator_name, :sector => data['name'], :timestamp => ts,
              :total_trains => data['Total'], :ontime_trains => data['OnTime'], :late_trains => data['Late'], :cancelverylate_trains => data['CancelVeryLate'],
              :ppm_rag => data['PPM']['rag'], :ppm => data['PPM']['text'], :rolling_ppm_rag => data['RollingPPM']['rag'], :rolling_ppm => data['RollingPPM']['text']
            )
          elsif operator.fetch('OprServiceGrp',[]).is_a?(Array)
            operator.fetch('OprServiceGrp',[]).each do |sector|
              data = sector
              Chopper::Rtppm.create(
                :operator => operator_name, :sector => data['name'], :timestamp => ts,
                :total_trains => data['Total'], :ontime_trains => data['OnTime'], :late_trains => data['Late'], :cancelverylate_trains => data['CancelVeryLate'],
                :ppm_rag => data['PPM']['rag'], :ppm => data['PPM']['text'], :rolling_ppm_rag => data['RollingPPM']['rag'], :rolling_ppm => data['RollingPPM']['text']
              )
            end
          end
        end
      end
    end
  end
end

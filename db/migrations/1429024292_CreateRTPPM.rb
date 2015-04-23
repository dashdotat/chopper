Sequel.migration do
  up do
    create_table(:rtppm) do
      primary_key :id
      String :operator, :null => false
      String :sector, :null => true
      Integer :total_trains
      Integer :ontime_trains
      Integer :late_trains
      Integer :cancelverylate_trains
      String :ppm_rag
      Integer :ppm
      String :rolling_ppm_rag
      Integer :rolling_ppm
      DateTime :timestamp
    end
  end

  down do
    drop_table(:rtppm)    
  end
end

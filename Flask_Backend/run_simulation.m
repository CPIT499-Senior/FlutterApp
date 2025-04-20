function run_simulation(mission_id)
    folder = fullfile('missions', ['mission' num2str(mission_id)]);
    input_file = fullfile(folder, 'input.json');
    result_file = fullfile(folder, 'result.json');

//    % Read input.json
            json_text = fileread(input_file);
    data = jsondecode(json_text);

//    % Simulated processing
    result.region = data.region;
    result.start = data.start;
    result.end = data.end;
    result.safe_path = [data.start; data.end]; % straight line
    result.landmine_count = randi([3, 10]); % random landmine count

    % Save result.json
            json_str = jsonencode(result);
    fid = fopen(result_file, 'w');
    fwrite(fid, json_str, 'char');
    fclose(fid);

    disp(['✅ Saved result: ' result_file]);
end

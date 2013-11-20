function line = loadfile(filename)

    counter = 1;
    file = fopen(filename, 'r');
    line = fgets(file);
    
    while ischar(line)
        line
        %out(counter) = hex2dec(line);
        counter = counter + 1;
        line = fgets(file);
    end

end
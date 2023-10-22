% nagelSchreckenbergTraffic(100, 5, 2/5, 1000, 2000, 1000)
function nagelSchreckenbergTraffic(cars, v_max, p, slots, steps, burn)
    v = zeros(1, cars);
    x = zeros(1, cars);
    results = zeros(steps, cars);
    
    % Set up initial car positions
    dist = floor(slots / cars);
    for l = 1:cars
        x(l) = (l-1) * dist;
    end
    
    for l = 1:burn
        [x, v] = simulateStep(cars, x, slots, v, v_max, p);
    end
    
    for l = 1:steps
        [x, v] = simulateStep(cars, x, slots, v, v_max, p);
        results(l, :) = x;
    end
    
    createImage(steps, slots, results);
end

function [x, v] = simulateStep(cars, x, slots, v, v_max, p)
    for cur = 1:cars
        next = cur + 1;
        if next > cars
            next = 1;
        end
        
        dist = x(next) - x(cur);
        if dist < 0
            dist = dist + slots;
        end
        
        v(cur) = min(v(cur) + 1, v_max);
        
        v(cur) = min(v(cur), dist-1);
        if rand() < p
            v(cur) = max(0, v(cur) - 1);
        end

        x(cur) = x(cur) + v(cur);
        if x(cur) > slots
            x(cur) = x(cur) - slots;
        end
    end
end

function createImage(steps, slots, results)
    % Initialize a binary image with ones
    image = ones(steps, slots);
    % Loop through time steps
    for t = 1:size(results,1)
        % Loop through cars
        for c = 1:size(results,2)
            image(t, results(t,c)) = 0;
        end
    end
    
    figure;
    imshow(image, 'InitialMagnification', 'fit');
    xlabel('Distance');
    ylabel('Time');
    title('Nagel–Schreckenberg traffic');
end

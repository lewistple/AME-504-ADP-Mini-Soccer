function updatePlot

    ax = evalin('base', 'ax');
    sld = evalin('base', 'sld');
    kField = evalin('base', 'kField');
    fmaxField = evalin('base', 'fmaxField');
    dField = evalin('base', 'dField');

    theta = get(sld, 'value');

    %-------------------*
    % Spring Properties |
    %-------------------*
    
    % Spring constant [lb/in]
    k = get(kField, 'value');
    
    % Max load [lb]
    Fmax = get(fmaxField, 'value');
    
    % Elastic potential energy [lb*in]
    U = Fmax^2/(2*k);
    
    % Efficiency
    eta = 0.25;
    
    % Converted kinetic energy [lb*in]
    Ke = eta*U;
    
    %-----------------*
    % Ball Properties |
    %-----------------*
    
    % Gravity [in/s^2]
    g = 386.1;
    
    % Density [lb/in^3]
    rho = 0.04;
    
    % Diameter [in]
    d = get(dField, 'value');
    
    % Rubber ball mass [lb]
    W = rho*(4/3)*pi*(d/2)^3;
    
    % Projectile velocity [in/s]
    V = sqrt(2*Ke/(W/g));
    
    %% Plot
    
    t = 0;
    y = 0;

    while y >= 0 && t <= 2
    
        % Moving distances [in]
        x = V*cosd(theta)*t;
        y = V*sind(theta)*t - g*t^2/2;
    
        t = t + 1e-3;
    
        plot(ax, x, y, '.k', 'MarkerSize', 10);
        hold(ax, 'on');
    
    end

    grid(ax, 'on');
    xlabel(ax, 'X Distance [in]');
    ylabel(ax, 'Y Distance [in]');
    axis(ax, 'equal');
    title(ax, 'Projectile Motion Map');
    hold(ax, 'off');

end
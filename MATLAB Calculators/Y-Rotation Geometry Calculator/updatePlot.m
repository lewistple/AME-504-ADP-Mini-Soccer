function updatePlot

    ax = evalin('base', 'ax');
    sld = evalin('base', 'sld');
    RField = evalin('base', 'RField');
    cField = evalin('base', 'cField');
    dField = evalin('base', 'dField');
    LField = evalin('base', 'LField');
    betaField = evalin('base', 'betaField');
    tpxyField = evalin('base', 'tpxyField');
    
    % Launcher floor length [mm]
    L = get(LField, 'value');   

    % Linkage elevation angle [deg]
    alpha = get(sld, 'value');
    sld.Tooltip = compose('%.2f°', alpha);

    % Linkage length [mm]
    R = get(RField, 'value');

    % Roller radius [mm]
    r = 4.9;
    
    % Roller coordinates [mm]
    a = R*cosd(alpha);
    b = R*sind(alpha);
    
    % Pivot coordinates [mm]
    c = get(cField, 'value');
    d = get(dField, 'value');
    
    % Solve for launcher elevation angle in [mm], 
    % and assign it to text area
    syms B
    eqn = tand(B) == (b + r*cosd(B) - d)/(c - a - r*sind(B));
    beta = double(vpasolve(eqn));
    betaText = compose('Launcher Elevation Angle: %.2f°', beta);
    set(betaField, 'Text', betaText);

    % Solve for coordinates of tangent point in [mm]
    % and assign it to text area
    Bx = a + r*sind(beta);
    By = b + r*cosd(beta);
    tpxyText = compose('X    %.2f    Y    %.2f', Bx, By);
    set(tpxyField, 'Text', tpxyText);

    % Plot
    plot(ax, 0, 0, '.r', MarkerSize=20);
    hold(ax, 'on');
    plot(ax, 24*cosd(alpha), 24*sind(alpha), '.r', MarkerSize=20);
    rectangle(ax, 'Position', [24*cosd(alpha)-4 24*sind(alpha)-4 8 8], 'Curvature', [1,1], 'LineWidth', 2);
    rectangle(ax, 'Position', [-16 -10 54.5 20], 'LineWidth', 2);
    line(ax, [0 a], [0 b], 'color', 'r', 'LineWidth', 2);
    rectangle(ax, 'Position', [-R -R 2*R 2*R], 'Curvature', [1,1], 'LineWidth', 1);
    rectangle(ax, 'Position', [a-r b-r 2*r 2*r], 'Curvature', [1,1], 'LineWidth', 2);
    line(ax, [c c-L*cosd(beta)], [d d+L*sind(beta)], 'color', 'b', 'LineWidth', 2);
    line(ax, [c c-62*cosd(beta)], [d d+62*sind(beta)], 'color', 'g', 'LineWidth', 2);
    plot(ax, Bx, By, '.m', MarkerSize=20);
    plot(ax, c, d, '.b', MarkerSize=20);
    hold(ax, 'off');

    grid(ax, 'on');
    axis(ax, 'equal');
    xlabel(ax, 'X [mm]');
    ylabel(ax, 'Y [mm]');
    title(ax, 'Y-Rotation Mechanism Geometry');

end
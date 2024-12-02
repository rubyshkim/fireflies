function firefly()
    % Parameters
    omega1 = 1.0;
    omega2_initial = 1.0;
    K_initial = 5; % Initial coupling strength
    
    % Time span parameters
    dt = 0.01; % Time step for animation
    t_total = 500; % Total simulation time
    t_current = 0; % Current simulation time
    % Initial conditions
    theta0 = [0; 0];
    % Intrinsic frequencies
    omega2 = omega2_initial;
    % Coupling strength
    K = K_initial;

    % Create a figure for the animation and slider
    fig = figure('Position', [100, 100, 600, 600]);
    % Create a slider to adjust the coupling strength
    slider_K = uicontrol('Style', 'slider', 'Min', 0, 'Max', 10, 'Value', K_initial, ...
        'Position', [100 70 200 20]);
    slider_omega2 = uicontrol('Style', 'slider', 'Min', 0.5, 'Max', 1.5, 'Value', omega2_initial, ...
        'Position', [100 40 200 20]);

    % Axes for the unit circle
    axis equal;
    axis off;
    axis([-1.2 1.2 -1.2 1.2]);
    xticks([]); yticks([]);
    hold on;
    plot(cos(linspace(0, 2*pi, 100)), sin(linspace(0, 2*pi, 100)), 'k'); % Unit circle
    plot([0 1],[0 0],'k',0,0,'k.','MarkerSize',12);
    text(1.05,0,"$\theta=0$","Interpreter","latex","FontSize",16);
    oscillator1 = plot(0, 0, 'ro', 'MarkerSize', 12, 'MarkerFaceColor', 'r'); % Oscillator 1
    oscillator2 = plot(0, 0, 'b*', 'MarkerSize', 16, 'MarkerFaceColor', 'b'); % Oscillator 2

     % Add text next to the sliders
    coupling_text = uicontrol('Style', 'text', 'Position', [310 70 180 20], ...
        'String', sprintf('Coupling (A): %.2f', K_initial), 'HorizontalAlignment', 'left', ...
        'BackgroundColor', fig.Color, 'FontSize', 12);

    omega2_text = uicontrol('Style', 'text', 'Position', [310 40 300 20], ...
        'String', sprintf('Intrinsic frequency (omega): %.2f', omega2_initial), 'HorizontalAlignment', 'left', ...
        'BackgroundColor', fig.Color, 'FontSize', 12);

    label1 = text(0,1.3,['$\Omega = $', sprintf(' %.2f,', omega1), sprintf(' $A = $ %.2f,', K_initial),...
        ' $\omega = $',sprintf(' %.2f', omega2_initial)],...
        'HorizontalAlignment','center','Interpreter','latex','FontSize',16);
    
    label2 = text(0,1.15,['$\mu = \frac{\Omega-\omega}{A} = $',sprintf(' %.2f', (omega1-omega2)/K)],...
        'HorizontalAlignment','center','Interpreter','latex','FontSize',16);

    % Initialize simulation variables
    theta = theta0;

    % Real-time animation loop
    while ishandle(fig)
        % Check for slider value change
        omega2 = slider_omega2.Value;
        K = slider_K.Value;

        % Update the coupling strength text
        coupling_text.String = sprintf('Coupling (A): %.2f', K);
        omega2_text.String = sprintf('Intrinsic frequency (omega): %.2f', omega2);
        label1.String = ['$\Omega = $', sprintf(' %.2f,', omega1), sprintf(' $A = $ %.2f,', K),...
        ' $\omega = $',sprintf(' %.2f', omega2)];
        label2.String = ['$\mu = \frac{\Omega-\omega}{A} = $',sprintf(' %.2f', (omega1-omega2)/K)];

        % Perform a small step of the ODE integration
        dtheta = odefun(t_current, theta, omega1, omega2, K);
        theta = theta + dtheta * dt;

        % Update oscillator positions
        x1 = cos(theta(1));
        y1 = sin(theta(1));
        x2 = cos(theta(2));
        y2 = sin(theta(2));
        oscillator1.XData = x1;
        oscillator1.YData = y1;
        oscillator2.XData = x2;
        oscillator2.YData = y2;

        % Increment current time
        t_current = t_current + dt;

        % Pause for real-time effect
        pause(dt);

        % Restart the simulation if time exceeds the total simulation time
        if t_current >= t_total
            t_current = 0;
            theta = theta0; % Reset to initial conditions
        end
    end

    % ODE function
    function dtheta = odefun(~, theta, omega1, omega2, K)
        dtheta = zeros(2, 1);
        dtheta(1) = omega1;% + K * sin(theta(2) - theta(1));
        dtheta(2) = omega2 + K * sin(theta(1) - theta(2));
    end
end

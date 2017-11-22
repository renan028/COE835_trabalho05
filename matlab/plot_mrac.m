%-------- Print eps plots -----

close all;

%Set matlab interpreter to latex
set(groot, 'defaultAxesTickLabelInterpreter','latex');
set(groot, 'defaultLegendInterpreter','latex');
set(groot, 'defaultTextInterpreter','latex');

%Set figures positions and size
fig_xpos = 500;
fig_ypos = 250;
fig_width = 600;
fig_height = 250;
fig_pos = [fig_xpos fig_ypos fig_width fig_height];
pos_pct = .075;

switch changed
    case 1
        str1 = strcat('$\gamma=',num2str(gamma_1),'$');
        str2 = strcat('$\gamma=',num2str(gamma_2),'$');
        file_name = strcat('gamma',num2str(gamma_1),'gamma',num2str(gamma_2));
        
    case 2 
        str1 = '$P_1$';
        str2 = '$P_2$';
        file_name = 'P1P2';
        
    case 3
        str1 = '$P_{m_1}$';
        str2 = '$P_{m_2}$';
        file_name = 'Pm1Pm2';
        
    case 4
        y0_str_1 = '[\,';
        for i=1:length(y0)
            if i ~= length(y0)
                y0_str_1 = strcat(y0_str_1,num2str(y0_1),'\,\,');
            else
                y0_str_1 = strcat(y0_str_1,num2str(y0_1),'\,]');
            end
        end
        y0_str_2 = '[\,';
        for i=1:length(y0)
            if i ~= length(y0)
                y0_str_2 = strcat(y0_str_2,num2str(y0(i)),'\,\,');
            else
                y0_str_2 = strcat(y0_str_2,num2str(y0(i)),'\,]');
            end
        end
        str1 = strcat('$y(0)=',y0_str_1,'^T$');
        str2 = strcat('$y(0)=',y0_str_2,'^T$');
        file_name = 'y01y02';
end

path_tiltheta = strcat('../relatorio/figs/tiltheta/',sim_str,file_name,'.eps');
path_modtheta = strcat('../relatorio/figs/modtheta/',sim_str,file_name,'.eps');
path_e0 = strcat('../relatorio/figs/e0/',sim_str,file_name,'.eps');

%--------------- Fig1: til_theta -------------
figure(1);clf;
set(gcf,'position',[fig_pos(1:2) fig_pos(3) 2*fig_pos(4)]);

h1 = subplot(211);
plot(T_1,tiltheta_1);grid on;
title(strcat('$\tilde{\theta}$ com~ ', str1));

h2 = subplot(212);
plot(T_2,tiltheta_2);grid on;
title(strcat('$\tilde{\theta}$ com~ ', str2));
% h2.YLim = h1.YLim;

switch(gP)
    case 2
        subplot(211);
        legend('$\tilde{\theta}_1$','$\tilde{\theta}_2$','$\tilde{\theta}_3$','$\tilde{\theta}_4$','Location','SouthEast')
        subplot(212);
        legend('$\tilde{\theta}_1$','$\tilde{\theta}_2$','$\tilde{\theta}_3$','$\tilde{\theta}_4$','Location','SouthEast')
    case 3
        subplot(211);
        legend('$\tilde{\theta}_1$','$\tilde{\theta}_2$','$\tilde{\theta}_3$','$\tilde{\theta}_4$','$\tilde{\theta}_5$','$\tilde{\theta}_6$','Location','SouthEast')
        subplot(212);
        legend('$\tilde{\theta}_1$','$\tilde{\theta}_2$','$\tilde{\theta}_3$','$\tilde{\theta}_4$','$\tilde{\theta}_5$','$\tilde{\theta}_6$','Location','SouthEast')
end

%Reduce gap btw subplots
set(h2,'Position',[h2.Position(1), h2.Position(2) + pos_pct*(h1.Position(2) - h2.Position(2)), h2.Position(3), h2.Position(4)]);

if PRINT
    print(path_tiltheta,'-depsc2','-painters')
end

%--------------- Fig2: mod theta -------------
figure(2);clf;
set(gcf,'position',fig_pos);

plot(T_1,modtt_1);grid on;hold on;
plot(T_2,modtt_2);
plot(T_1,norm(thetas)*ones(1,length(T_1)));hold off;

title('$||\theta||$');
legend(str1,str2,'$||\theta^*||$','Location','SouthEast');

if PRINT
    print(path_modtheta,'-depsc2','-painters')
end

%--------------- Fig3: e -------------
figure(3);clf;
set(gcf,'position',fig_pos);

plot(T_1,e0_1);grid;hold on;
plot(T_2,e0_2);hold off;

title('$e_0$');
legend(str1,str2,'Location','SouthEast');

if PRINT
    print(path_e0,'-depsc2','-painters')
end

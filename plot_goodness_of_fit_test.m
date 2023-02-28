clear
Nall = [100, 200 , 400, 800, 1600];
type = 'binom';
twd = readtable("./tracy-widom-distribution.txt");
twdv = twd.Var2;
b_all = [-0.1, -0.2, -0.3,-0.4];
a = 0.1;
p = 0.4;
type1 = "binom";
legendlabel = 'n = ' + string(Nall);


data1 = [];
recordquantile1 = [];
recordquantile2 = [];

for aindex = 1:length(b_all)
    for nindex = 1:length(Nall)
        b = b_all(aindex);
        n = Nall(nindex);
        load(sprintf("./results/result_%d_%s_%d_%d_%d",n,type1,abs(floor(10*a)),abs(floor(10*b)),10*p));
        data1(aindex,nindex,:) = record;
    end
end
for aindex1 = 1:length(b_all)
    for nindex = 1:length(Nall)
        figure('Visible','off')
        data1sub = reshape(data1(aindex1,nindex,:),[1,size(data1(aindex1,nindex,:),3)]);
        hqq = qqplot(data1sub,twdv);
        XD = hqq(1).XData;
        YD = hqq(1).YData;
        recordquantile1(aindex1, nindex,:) = XD;
        recordquantile2(aindex1, nindex,:) = YD;
    end

end
  

font_size = 18;
for aindex1 = 1:length(b_all)
        b = b_all(aindex1);
        colorstring = ["black","blue","g","m","cyan"];
        fig = figure("visible",'on');
        box on;
        for nindex = 1:length(Nall)
            hold on;
            XD = reshape(recordquantile1(aindex1, nindex,:),[1,length(recordquantile1(aindex1, nindex,:))]);
            YD = reshape(recordquantile2(aindex1, nindex,:),[1,length(recordquantile2(aindex1, nindex,:))]);
            plot(XD, YD,'+b','MarkerEdgeColor',colorstring(nindex),'DisplayName',legendlabel(nindex))
            xlim([-5 5])
            ylim([-5 5])
        end
        [~, objh] = legend(legendlabel,'Location','northwest','fontsize',20);
        objhl = findobj(objh, 'type', 'line');
        set(objhl, 'Markersize', 18);
        hold on 
        x = linspace(-5,5,11);
        y = x;
        plot(x,y, 'LineWidth',2,'Color','r','HandleVisibility','off')
        xlabel('Theoretical quantiles of $TW_1$', 'Interpreter','latex','fontsize',font_size);
        ylabel('Sample quantiles of $n^{2/3}[\sigma_1(\tilde{A})-2]$', 'Interpreter','latex','fontsize',font_size);
        set(gca,'fontsize',font_size);
        ax = gca;
        ax.TitleFontSizeMultiplier = 1.5;
        pbaspect([1.2 1 1])
        set(gca,'units','centimeters')
        set(gcf,'units','centimeters')
        pos = get(gca,'Position');
        ti = get(gca,'TightInset');
        title(sprintf('QQ plot of $b=%1.1f$, $p=%1.1f$',b,p),'Interpreter','latex','fontsize',25);
        set(gca, 'Position',[1 2 pos(3)+ti(1)+ti(3)+2 pos(4)+ti(2)+ti(4)]);
        set(gcf, 'PaperSize', [pos(3)+ti(1)+ti(3) pos(4)+ti(2)+ti(4)]);
        set(gcf, 'Units', 'Inches', 'Position', [0 0 6 5.5], 'PaperUnits', 'Inches', 'PaperSize', [5.5, 5.5])
        saveas(fig, sprintf("./plots/qqplot-comparison-dense-%d.png",abs(b_all(aindex1)*10)))
end


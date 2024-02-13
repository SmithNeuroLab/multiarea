function data=powell24_figure2(inData)
    %
    % Makes figure 2 from Powell et al 2024
    %
    % Optionally returns all data from figure
    %
    % inData is either 1) the full path to the figure 2 data file
    %    eg: ~/Downloads/Powell24/Data/figure_2_data.mat
    
    if ischar(inData)
        data=load(inData);
    else
        data=inData;
    end
    
    figure;
    
    areas={'pfc','ppc','a1','s1','v1'};
    % Display correlation patterns
    for iarea=1:5
        for i=1:2
            subplot(2,7,iarea+(i-1)*7)
            imagesc(data.(areas{iarea}).corrImg(:,:,i),[-0.75 0.75]); hold on
            seedXY=data.(areas{iarea}).seedPoint(i,:);
            plot(seedXY(1),seedXY(2),'g.','markersize',10)
            axis image
            set(gca,'xtick',[],'ytick',[])
            if i==1
                title(upper(areas{iarea}))
            end
        end
    end
    colormap(data.colormap);
    
    % Plot correlation by distance
    clrs=[199,21,133; 30,144,255; 255,165,0;50 205 50; 0 0 0]/255;
    
    subplot(2,7,6)
    for iarea=1:5
        x=data.(areas{iarea}).corrByDist(1,:);
        corrMn=data.(areas{iarea}).corrByDist(2,:);
        corrSem=data.(areas{iarea}).corrByDist(3,:);
        errorbar(x,corrMn,corrSem,'color',clrs(iarea,:),'CapSize',0); hold on
        
        plot([min(x) max(x)],[1 1]*data.(areas{iarea}).corrShuffle,'--','color',clrs(iarea,:));
    end
    ylabel('Correlation strength')
    xlabel('Distance (mm)')
    xlim([0 2.2])
    ylim([0 1])
    box off
    
    subplot(2,7,7)
    for iarea=1:5
        corrData=data.(areas{iarea}).corr2mm;
        plot(iarea,corrData,'.','color',clrs(iarea,:)); hold on
        errorbar(iarea,mean(corrData),sem(corrData),'color',clrs(iarea,:),'CapSize',0)
        set(gca,'ylim',[0 1],'xlim',[0 6],'box','off','xtick',1:5,...
            'xticklabel',upper(areas))
        ylabel('Corr (2mm)');
    end
    
    subplot(2,7,13)
    for iarea=1:5
        x=data.(areas{iarea}).expVar(1,:);
        eVarMn=data.(areas{iarea}).expVar(2,:);
        eVarSem=data.(areas{iarea}).expVar(3,:);
        errorbar(x,eVarMn,eVarSem,'color',clrs(iarea,:),'CapSize',0); hold on
        
        plot([min(x) max(x)],[1 1]*data.(areas{iarea}).corrShuffle,'--','color',clrs(iarea,:));
    end
    ylabel('Correlation strength')
    xlabel('PCs')
    xlim([0 50])
    ylim([0 1])
    box off
    
    subplot(2,7,14)
    for iarea=1:5
        pRatData=data.(areas{iarea}).pr;
        plot(iarea,pRatData,'.','color',clrs(iarea,:)); hold on
        errorbar(iarea,mean(pRatData),sem(pRatData),'color',clrs(iarea,:),'CapSize',0)
        set(gca,'ylim',[0 16],'xlim',[0 6],'box','off','xtick',1:5,...
            'xticklabel',upper(areas))
        ylabel('Corr (2mm)');
    end
    
end

function x=sem(in,dim)
    if nargin<2
        if isvector(in)
            dim=find(size(in)==max(size(in)),1);
        else
            dim = find(size(in)~=1, 1);
            if isempty(dim), dim = 1; end
        end
    end
    x=std(in,0,dim)/sqrt(size(in,dim));
end
function data=powell24_figure3(inData)
    %
    % Makes figure 3 from Powell et al 2024
    %
    % Optionally returns all data from figure
    %
    % inData is either 1) the full path to the figure 3 data file
    %    eg: ~/Downloads/Powell24/Data/figure_3_data.mat
    
    if ischar(inData)
        data=load(inData);
    else
        data=inData;
    end
    
    figure
    
    areas={'pfc','ppc','a1','s1','v1'};
    
    % Display correlation patterns
    for iarea=1:5
        % 2-photon events
        % 2-photon correlation
        subplot(4,6,iarea);
        cellsXY=data.(areas{iarea}).cellsXY; % cell locations in WideField coordinates
        cellEvtData=data.(areas{iarea}).cellEvtData;
        
        % Map event amplitide to 0..2*stdev
        mxAmp=2*nanstd(cellEvtData)+nanmean(cellEvtData);
        cellEvtInd=ceil((cellEvtData)/mxAmp*256);
        cellEvtInd(cellEvtInd<1)=1;
        cellEvtInd(cellEvtInd>256)=256;
        evtColormap=copper(256);
        cellEvtColor=evtColormap(cellEvtInd,:);
        
        for i=1:length(cellsXY)
            plot(cellsXY(i,1),cellsXY(i,2),'markeredgecolor','k',...
                'marker','o','markerfacecolor',cellEvtColor(i,:),...
                'markersize',4,'linewidth',.25); hold on
        end
        
        % set limits
        xl=data.(areas{iarea}).axisLims2p(1,:);
        yl=data.(areas{iarea}).axisLims2p(2,:);
        set(gca,'XLim',xl, 'YLim',yl,'xtick',[],'ytick',[],'ydir','reverse',...
            'DataAspectRatio',[1 1 1])
        
        % 2-photon correlation
        subplot(4,6,6+iarea);
        cellCorrs=data.(areas{iarea}).cellCorrs;
        seedCell=data.(areas{iarea}).seedCell;
        cellCorrColorRange=[-0.5 0.5]; % color range for 2p correlations
        
        % Map correlations to 0..255 and index into colormap
        cellCorrsInd=ceil((cellCorrs-cellCorrColorRange(1))/range(cellCorrColorRange)*256);
        cellCorrsInd(cellCorrsInd<1)=1;
        cellCorrsInd(cellCorrsInd>256)=256;
        cellCorrsColor=data.colormap(cellCorrsInd,:);
        
        for i=1:length(cellsXY)
            plot(cellsXY(i,1),cellsXY(i,2),'markeredgecolor','k',...
                'marker','o','markerfacecolor',cellCorrsColor(i,:),...
                'markersize',4,'linewidth',.25); hold on
        end
        plot(cellsXY(seedCell,1),cellsXY(seedCell,2),'markeredgecolor','k',...
            'marker','o','markerfacecolor','g',...
            'markersize',5,'linewidth',.25); hold on
        % set limits
        xl=data.(areas{iarea}).axisLims2p(1,:);
        yl=data.(areas{iarea}).axisLims2p(2,:);
        set(gca,'XLim',xl, 'YLim',yl,'xtick',[],'ytick',[],'ydir','reverse',...
            'DataAspectRatio',[1 1 1])
        
        % Wide-field correlation
        subplot(4,6,12+iarea)
        imagesc(data.(areas{iarea}).corrImg,[-0.75 0.75]); hold on
        seedXY=data.(areas{iarea}).seedPoint;
        plot(seedXY(1),seedXY(2),'g.','markersize',10)
        axis image
        set(gca,'xtick',[],'ytick',[])
        
        bx=patch([xl fliplr(xl)],[yl(1) yl(1) yl(2),yl(2)],'k');
        set(bx,'facecolor','none','edgecolor','k','linewidth',1)
    end
    colormap(data.colormap);
    
    
    
    % Plot correlation by distance
    clrs=[199,21,133; 30,144,255; 255,165,0;50 205 50; 0 0 0]/255;
    
    subplot(4,6,19)
    for iarea=1:5
        x=data.(areas{iarea}).corrsByDist2p(1,:);
        corrMn=data.(areas{iarea}).corrsByDist2p(2,:);
        corrSem=data.(areas{iarea}).corrsByDist2p(3,:);
        errorbar(x,corrMn,corrSem,'color',clrs(iarea,:),'CapSize',0); hold on
    end
    ylabel('Correlation strength')
    xlabel('Distance (mm)')
    xlim([0 0.6])
    ylim([-0.5 1])
    box off
    
    subplot(4,6,20)
    for iarea=1:5
        corrData=data.(areas{iarea}).locCorrs;
        plot(iarea,corrData,'.','color',clrs(iarea,:)); hold on
        errorbar(iarea,mean(corrData),sem(corrData),'color',clrs(iarea,:),'CapSize',0)
        set(gca,'ylim',[0 1],'xlim',[0 6],'box','off','xtick',1:5,...
            'xticklabel',upper(areas))
        ylabel('Corr (30 - 100 \mum)');
    end
    
    % Plot LCI by distance
    subplot(4,6,21)
    for iarea=1:5
        x=data.(areas{iarea}).lciByDist2p(1,:);
        expVarMn=data.(areas{iarea}).lciByDist2p(2,:);
        expVarSem=data.(areas{iarea}).lciByDist2p(3,:);
        errorbar(x,expVarMn,expVarSem,'color',clrs(iarea,:),'CapSize',0); hold on
    end
    ylabel('LCI')
    xlabel('Distance (mm)')
    xlim([0 0.6])
    ylim([-0.75 1])
    box off
    
    subplot(4,6,22)
    for iarea=1:5
        prData=data.(areas{iarea}).locLCI;
        plot(iarea,prData,'.','color',clrs(iarea,:)); hold on
        errorbar(iarea,mean(prData),sem(prData),'color',clrs(iarea,:),'CapSize',0)
        set(gca,'ylim',[0 1],'xlim',[0 6],'box','off','xtick',1:5,...
            'xticklabel',upper(areas))
        ylabel('LCI (30 - 100 \mum)');
    end
    
    % Plot Explained variance and dimensionality
    subplot(4,6,23)
    for iarea=1:5
        x=data.(areas{iarea}).expVar2p(1,:);
        expVarMn=data.(areas{iarea}).expVar2p(2,:);
        expVarSem=data.(areas{iarea}).expVar2p(3,:);
        errorbar(x,expVarMn,expVarSem,'color',clrs(iarea,:),'CapSize',0); hold on
    end
    ylabel('Cumulative variance')
    xlabel('PCs')
    xlim([0 15])
    ylim([0 1])
    box off
    
    subplot(4,6,24)
    for iarea=1:5
        prData=data.(areas{iarea}).pr2p;
        plot(iarea,prData,'.','color',clrs(iarea,:)); hold on
        errorbar(iarea,mean(prData),sem(prData),'color',clrs(iarea,:),'CapSize',0)
        set(gca,'ylim',[0 10],'xlim',[0 6],'box','off','xtick',1:5,...
            'xticklabel',upper(areas))
        ylabel('Participation ratio');
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
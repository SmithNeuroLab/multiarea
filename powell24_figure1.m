function data=powell24_figure1(inData)
    %
    % Makes figure 1 from Powell et al 2024
    %
    % Optionally returns all data from figure
    %
    % inData is either 1) the full path to the figure 1 data file
    %    eg: ~/Downloads/Powell24/Data/figure_1_data.mat
    
    if ischar(inData)
        data=load(inData);
    else
        data=inData;
    end
    %%
    figure;
    
    areas={'pfc','ppc','a1','s1','v1'};
    % Plot traces and events for all areas
    for iarea=1:5
        subplot(5,5,(iarea-1)*5+1)
        t=data.(areas{iarea}).trace(1,:);
        plot(t,data.(areas{iarea}).trace(2,:)); hold on
        plot(data.(areas{iarea}).eventFrameTimes,ones(1,2)*max(data.(areas{iarea}).trace(2,:)),...
            '*');
        axis tight
        ylabel('\DeltaF/F');
        xlabel('Time (s)')
        box off
        title(upper(areas{iarea}))
        
        for ievt=1:2
            subplot(5,5,(iarea-1)*5+1+ievt)
            evt=data.(areas{iarea}).eventFrames(:,:,ievt);
            sum(isnan(evt(:)))
            
            imshow(evt,nanmean(evt(:))+2*nanstd(evt(:))*[-1 1])
        end
    end
    %% Plot modularity
    subplot(5,5,4)
    % colors for area labels
    clrs=[199,21,133; 30,144,255; 255,165,0;50 205 50; 0 0 0]/255;
    for iarea=1:5
        x=data.(areas{iarea}).modularityCrv(1,:);
        modMean=data.(areas{iarea}).modularityCrv(2,:);
        modSem=data.(areas{iarea}).modularityCrv(3,:);
        errorbar(x,modMean,modSem,'color',clrs(iarea,:),'CapSize',0); hold on
    end
    axis tight
    box off
    ylabel('Fraction events');
    xlabel('Modularity')
    title('Event modularity')
    subplot(5,5,5)
    for iarea=1:5
        modData=data.(areas{iarea}).modularity;
        plot(iarea,modData,'.','color',clrs(iarea,:)); hold on
        errorbar(iarea,mean(modData),sem(modData),'color',clrs(iarea,:),'CapSize',0)
        set(gca,'ylim',[0 0.15],'xlim',[0 6],'box','off','xtick',1:5,...
            'xticklabel',upper(areas))
        ylabel('Modularity');
    end
    % Plot wavelength
    subplot(5,5,9)
    for iarea=1:5
        x=data.(areas{iarea}).wavelengthCrv(1,:);
        wavMean=data.(areas{iarea}).wavelengthCrv(2,:);
        wavSem=data.(areas{iarea}).wavelengthCrv(3,:);
        errorbar(x,wavMean,wavSem,'color',clrs(iarea,:),'CapSize',0); hold on
    end
    axis tight
    box off
    ylabel('Fraction events');
    xlabel('Wavelength (mm)')
    title('Event wavelength')
    subplot(5,5,10)
    for iarea=1:5
        wavData=data.(areas{iarea}).wavelength;
        plot(iarea,wavData,'.','color',clrs(iarea,:)); hold on
        errorbar(iarea,mean(wavData),sem(wavData),'color',clrs(iarea,:),'CapSize',0)
        set(gca,'ylim',[0 1],'xlim',[0 6],'box','off','xtick',1:5,...
            'xticklabel',upper(areas))
        ylabel('Wavelength');
    end
    %% Plot Module amplitude
    subplot(5,5,14)
    for iarea=1:5
        x=data.(areas{iarea}).modAmpCrv(1,:);
        wavMean=data.(areas{iarea}).modAmpCrv(2,:);
        wavSem=data.(areas{iarea}).modAmpCrv(3,:);
        errorbar(x,wavMean,wavSem,'color',clrs(iarea,:),'CapSize',0); hold on
    end
    axis tight
    box off
    ylabel('Fraction events');
    xlabel('Module amplitude')
    title('Module amplitude')
    subplot(5,5,15)
    for iarea=1:5
        modAData=data.(areas{iarea}).modAmp;
        plot(iarea,modAData,'.','color',clrs(iarea,:)); hold on
        errorbar(iarea,mean(modAData),sem(modAData),'color',clrs(iarea,:),'CapSize',0)
        set(gca,'ylim',[0 6],'xlim',[0 6],'box','off','xtick',1:5,...
            'xticklabel',upper(areas))
        ylabel('Module amplitude');
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

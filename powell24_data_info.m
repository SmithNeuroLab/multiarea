% Script to load additional data associated with Powell et al. 2024,
% PNAS.
%
% To run, adjust dataPath to point to the location of the downloaded
% data folder on your system (e.g. ~/Downloads/powell24_data)

dataPath='~/Downloads/powell24_data';
%% Spontaneous events
% Loads all spontaneous event frames for example animals shown in Powell
% 2024 figure 1. 
%
% Variables for each area contain:
%     evtFrames: a 270 x 320 x Events matrix containing spontaneous events. Pixel values are expressed as deltaF/F.
%     micronsPerPx: scalar value expressing the spatial scale in microns per pixel of the data

%A1
q=load(fullfile(dataPath,'a1_F0234_wfEvents.mat'));
a1_events=q.evtFrames;
a1_micronsPerPx=q.micronsPerPx;
	
%PPC
q=load(fullfile(dataPath,'ppc_F0234_wfEvents.mat'));
ppc_events=q.evtFrames;
ppc_micronsPerPx=q.micronsPerPx;

%S1
q=load(fullfile(dataPath,'ppc_F0234_wfEvents.mat'));
s1_events=q.evtFrames;
s1_micronsPerPx=q.micronsPerPx;

%PFC
q=load(fullfile(dataPath,'pfc_F0234_wfEvents.mat'));
pfc_events=q.evtFrames;
pfc_micronsPerPx=q.micronsPerPx;
	
%V1
q=load(fullfile(dataPath,'v1_F0224_wfEvents.mat'));
v1_events=q.evtFrames;
v1_micronsPerPx=q.micronsPerPx;

%% Widefield correlation matrices
% Loads pixelwise correlation matrices for example animals shown in Powell
% 2024 Figure 2
%
% % Variables for each area contain:
%     corrs: M x M correlation matrix for all pixels within the ROI 
%     roi: a 135 x 160 logical array indicating the pixel locations 
%         correspding to the entries in corrs
%         roi is at 21.978 microns per pixel in all cases. 
%
% Note that pixel indices in for rows in corrs are stored in 'C' 
% (row-major) byte order, and not 'F' (column major) byte order
% We therefore must transpose roi before appliying the data from corrs
% in order to reconstruct an image. 

fileNames={'a1_F0234_wfCorrMat.mat','ppc_F0234_wfCorrMat.mat','ppc_F0234_wfCorrMat.mat',...
    'pfc_F0234_wfCorrMat.mat','v1_F0224_wfCorrMat.mat'};
q=load(fullfile(dataPath,fileNames{1}));
corrs=q.corrs;
roi=q.roi;


% To display a 2d image of correlations for a single: pixel (seed point)
corrImage=zeros(size(roi'));
pxIndex=5000; % index of pixel (seed point to plot)
pxCorrs=corrs(pxIndex,:);

% Linearize the roi, and transpose to convert to matlab-native column-major byte
% order
roiflat=reshape(roi',[],1);
corrImage(roiflat)=pxCorrs;
corrImage=corrImage';

figure;
imshow(corrImage,[-1 1])


%% Cellular events and correlation patterns
% Loads celluar event and correlation data for example animals shown in Powell
% 2024 Figure 3
% 
% Variables for each area contain:
%     cellXY: ncell x 2 array with X and Y positions for each neuron (in pixel units)
%     micronsPerPx2p: microns per pixel for cellXY
%     eventData2p: ncell x nevent array with activity (in dF/F) for each cell 
%         on each spontaneous event
%     corrMat2p: ncell x ncell correlation matrix
    

fileNames={'a1_F0234_2pData.mat','s1_F0231_2pData.mat','pfc_F0234_2pData.mat','v1_F0224_2pData.mat','ppc_F0234_2pData.mat'};
q=load(fullfile(dataPath,fileNames{1}));

cellXY=q.cellXY;
events=q.eventData2p;
corrs2p=q.corrMat2p;

% To show event:
scatter(cellXY(:,1),cellXY(:,2),'CData',events(:,50),'MarkerFaceColor','flat')
colormap(copper)

% To show correlation pattern for single cell
figure
scatter(cellXY(:,1),cellXY(:,2),'CData',corrs2p(:,50),'MarkerFaceColor','flat')
colormap(parula)



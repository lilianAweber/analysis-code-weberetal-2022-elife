function behav = dprst_calculate_performance( MMN, responseButtons, options )
%DPRST_CALCULATE_PERFORMANCE Calculates performance score for visual
%distraction task in the DPRST study
%   Collects all indices of a participant's behavior into a struct (behav):
%   the reward money (in CHF), the performance score (the higher,
%   the better, minimum is zero, maximum around 0.6), the mean RT, how
%   many error presses and misses visual events a person had, and their 
%   hit- and errorrate.
%   IN:     MMN             - the struct that is outputted from the task
%           responseButtons - labels of response buttons used by this
%                           participant
%           options         - the substruct of options for behavioral
%                           analysis
%   OUT:    behav           - a struct with all behavioral indices

% initialize results
reactTime = [];
behav.misses = 0;
behav.errors = 0;
rts = [];

% on which trials did something actually happen
idxVis = find(MMN.stimuli.visSequence);

% how many visual stimuli and button presses do we have
nVis = length(idxVis);
nButtons = length(MMN.responses.responseTimes);

% go through all stimuli except last one
for vis = 1: nVis
    % when and wich stimulus was presented
    presTime = MMN.stimuli.visTimes(idxVis(vis));
    presType = MMN.stimuli.visSequence(idxVis(vis));
    corrButton = responseButtons{presType};
    
    % determine acceptable range of RTs
    minTime = presTime + options.minRT;
    maxTimeRT = presTime + options.maxRT;
    if vis == nVis
        maxTime = maxTimeRT;
    else
        presRange = MMN.stimuli.visTimes(idxVis(vis + 1)) - presTime;
        maxTimeRange = presTime + presRange;
        maxTime = min(maxTimeRT, maxTimeRange);
    end
    
    % go through button presses
    potRTs = [];
    for butt = 1: nButtons
        pressTime = MMN.responses.responseTimes(butt);
        respButton = MMN.responses.keys{butt};
        % save potential RTs
        if      pressTime > minTime && ...
                pressTime < maxTime && ...
                strcmp(respButton, corrButton)
            potRTs = [potRTs pressTime];
        end
    end
    
    % if there were none, this is a miss
    if isempty(potRTs)
        behav.misses = behav.misses + 1;
        reactTime(vis) = NaN;
        rts(vis) = NaN;
    else
        % choose first correct response
        reactTime(vis) = min(potRTs);
        rts(vis) = reactTime(vis) - presTime;
    end
end

% check which button presses have not been assigned
for butt = 1: nButtons
    pressTime = MMN.responses.responseTimes(butt);
    if ~ismember(pressTime, reactTime)
        behav.errors = behav.errors + 1;
    end
end

% evaluate performance
behav.rt = mean(rts(~isnan(rts)));
faults = behav.misses + behav.errors;
behav.perform = 1 - (behav.rt + faults/nVis) + 0.2;
if behav.perform < 0
    behav.perform = 0;
end

% calculate payoff
rangePerform = options.maxPerform - options.minPerform;
moneyScale = options.maxMoney / rangePerform;

behav.money = behav.perform * moneyScale;
if behav.money > options.maxMoney
    behav.money = options.maxMoney;
end

% calculate hitrate and errorrate
behav.hitrate = (nVis-behav.misses)/nVis;
behav.errorrate = behav.errors/nVis;

end


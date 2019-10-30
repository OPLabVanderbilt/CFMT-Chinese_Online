% rng params
rng_seed = typecast(uint8('CMTF'), 'uint32');
rng('default');
rng(rng_seed, 'twister');

TrialQueue1 = randperm(30);
TrialQueue2 = randperm(24);

save('TrialQueues.mat', 'TrialQueue1', 'TrialQueue2');

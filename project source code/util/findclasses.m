%% SYS800 - Reconnaissance de formes et inspection
% M'Hand Kedjar - December 2016
% Course Project on Age and Gender Classification

% Copyright (c) Philipp Wagner. All rights reserved.
% Licensed under the BSD license. See LICENSE file in the project root for full license information.

function idx = findclasses(y, list_of_classes)
	min_class = min(y);
	max_class = max(y);
  idx = [];
	for i = list_of_classes
		if((i >= min_class) || (i <= max_class))
			idx = [idx, find(y == i)];
		end
	end
end

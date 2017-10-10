%% SYS800 - Reconnaissance de formes et inspection
% M'Hand Kedjar - December 2016

var_vect = [0.001 0.01 0.05 0.08 0.1 0.15 0.2 0.3 0.4 0.5 0.7 1];
temp_path = '..\data\mnist7000\Learning\0/000001.tif'; 
image = imread(temp_path); 
for v = 1:numel(var_vect)
    noise_variance = var_vect(v);
    noised_image = AddNoiseToBWImage(image,noise_variance);
    subplot(4,3,v), imagesc(noised_image), title(sprintf('var_n = %0.0d', noise_variance))
end

suptitle('Visualisation de l''effet d''un ajout du bruit au chiffre 0')
colormap gray
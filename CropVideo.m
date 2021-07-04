clear all
clc
vid1=VideoReader('TrialVideo.avi');
n=vid1.NumberOfFrames;
writerObj1 = VideoWriter('TrialVideo-crop.avi');
open(writerObj1);
for i = 100: 200
  im = read(vid1,i);
  im=imresize(im,0.5);
  imc=imcrop(im,[60 60 300 300]);% The dimention of the new video
  img=rgb2gray(im);
  [a,b]=size(img);
  imc=imresize(imc,[a,b]);
  writeVideo(writerObj1,imc);  
    subplot(1,3,1)
    imshow(im)
    subplot(1,3,2)
    imshow(imc)
   
end
close(writerObj1)
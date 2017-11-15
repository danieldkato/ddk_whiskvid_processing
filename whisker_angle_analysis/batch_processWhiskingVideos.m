%Batch process videos through ffmpeg & trace

%Use the 'dir' command to get a list of all whisking videos in the current
%directory
fnames = dir('*_whiskvid*');

for i = 1:length(fnames)
    
    %Step one: take original .avi video and invert colors using ffmpeg;
    %then saves as a new .mp4 (only do this step if there isn't already an .mp4 file
    %with this name in the directory)
    f1 = fnames(i).name;
    f2 = [f1(1:end-4) '.mp4'];
    
    if ~exist(f2,'file')
        com = ' -vf lutyuv=y=negval -vcodec mpeg4 -q 2 ';
        fullCom = ['!ffmpeg -i ',f1,com,f2];        
        eval(fullCom)
    end                    
    
    %Next steps: call the whiski 'trace' and 'measure' commands from within
    %matlab and save those files in directory (only executes if files don't 
    %already exist).
    f3 = [f2(1:end-4) '.whiskers'];
    f4 = [f2(1:end-4) '.measurements'];
        
    if exist(f2,'file')
        wcom = ['!trace ',f2,' ',f3];
        disp(['Tracing ',f2,'...'])
        eval(wcom)
   end
    
    if ~exist(f4,'file')
        mcom = ['!measure --face right ',f3,' ',f4];
        eval(mcom)
    end
end
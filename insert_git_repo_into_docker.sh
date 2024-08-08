clinSV_repo_path=/app/clinsv_repo

cp -f $clinSV_repo_path/clinsv $clinsv_path/bin/ && \
cp -f $clinSV_repo_path/sort_bgzip $clinsv_path/bin/ &&\
cp -f $clinSV_repo_path/perl_modules/* $clinsv_path/perlib/My && \
cp -f $clinSV_repo_path/scripts/*  $clinsv_path/clinSV/scripts/ 
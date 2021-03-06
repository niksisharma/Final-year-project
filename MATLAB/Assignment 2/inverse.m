
%%METHOD 1.
clc
clear all;
close all;
%%

x=input('enter the matrix');
[m n]=size(x);
if m==n
    if det(x)==0 %if det=0, matrix is singular
        disp('inverse not possible');% should not be singular, det!=0.

    else
        inversing=inv(x);
        disp('inverse is ');
        disp(inversing);

disp('eigen vectors are');
        [V L]= eig(x);
        eigenvectors=[V];
        disp(eigenvectors);
        disp('eigen values are');
        eigenvalues=[L];
        disp(eigenvalues);
        
       
    end
end

%% METHOD 2 (to find inverse)
xinv = V*(L^-1)*(V^-1);
disp(xinv);


%% METHOD 3 (to find inverse)
I=eye(m);
result=rref([x I]); % I stands for identity matrix.
disp(result);



    
   

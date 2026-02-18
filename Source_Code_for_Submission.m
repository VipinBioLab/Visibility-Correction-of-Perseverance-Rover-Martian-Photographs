function Enhanced_Image_Colour=FCI_Colour(Input_Image_Colour,Exponential_Fuzzification_Parameter)
Enhanced_Image_Colour=Input_Image_Colour;
Denominational_Fuzzification_Parameter=127;
Enhanced_Image_Colour(:,:,1)=FCI(Input_Image_Colour(:,:,1),Exponential_Fuzzification_Parameter,Denominational_Fuzzification_Parameter);
Enhanced_Image_Colour(:,:,2)=FCI(Input_Image_Colour(:,:,2),Exponential_Fuzzification_Parameter,Denominational_Fuzzification_Parameter);
Enhanced_Image_Colour(:,:,3)=FCI(Input_Image_Colour(:,:,3),Exponential_Fuzzification_Parameter,Denominational_Fuzzification_Parameter);
end
function Enhanced_Image=FCI(Input_Image,EFP,DFP)
Input_Image=double(Input_Image);
Fuzzy_Memb_Fun=(1+((max(Input_Image(:))-Input_Image)./DFP)).^(-1*EFP);
[Num_Row Num_Column]=size(Input_Image);
for i=1:Num_Row
        for j=1:Num_Column
            if Fuzzy_Memb_Fun(i,j)<=0.5
               IFMF(i,j)=2*Fuzzy_Memb_Fun(i,j)*Fuzzy_Memb_Fun(i,j);
            else              
                IFMF(i,j)=1-(2*(1-Fuzzy_Memb_Fun(i,j))*(1-Fuzzy_Memb_Fun(i,j)));
            end
        end
end
Defuzz=max(Input_Image(:))-((((1./IFMF).^(1/EFP))-1)*DFP);
Enhanced_Image=uint8(Defuzz);       
end

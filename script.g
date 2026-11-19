LoadPackage("simpl");
LoadPackage("sonata");




AllCandidatesOfAutomorphismGroups:=function(G)  
    local g,n,osub,res,classes,temp,i,sub,class,t,maxsubgroups,conj;
Print("entered ", Order(G),"\n");
    res:=[];
    if Order(G) in [12,24,60] then
        Add(res,G);
    fi;
    classes:=[ConjugacyClassSubgroups(G,G)];
    while classes <> [] do
Print("new classes ",Length(classes),"\n");
        temp:=[];
        for class in classes do 
            g:=Representative(class);
            maxsubgroups:=ConjugacyClassesMaximalSubgroups(g);
            for t in maxsubgroups do
                sub:=Representative(t);
                osub:=Order(sub);
                if (osub mod 12 =0) or (osub mod 24 =0) or (osub mod 60 = 0) then
                    Add(temp,t);
                    if (osub = 12) or (osub = 24) or (osub = 60 ) then
	                Add(res,sub);
                    fi;
                fi;
            od;
        od;
        classes:=temp;
    od;
    return res;
end;






tcon1:=["1024_1024","1102_1150","1200_1220","1262_1278","832_870"];
tcon2:=["960_960","1026_1070","1152_1152","1222_1240","1280_1280"];
tcon3:=["752_768","872_900","962_1022","1072_1100","1154_1198"];
tcon4:=["1242_1260","770_830","902_958","702_750"];


LeonardoSearch:=function(content)
    local g,con,path,file,res,s,d,ords,groups,cand,res_str,ord,resl,oa,EG,
    vof,faceDegrees,temp,str,i,path_to_file,n,t,bool,a,res_str2,content2,path2,aut,conj;
    path:="RES/";
    ord:=[12,24,60];
    res_str:=["A_4","S_4","A_5"];
    res_str2:=["regular","equivelar","others"];
    groups:=[AlternatingGroup(4),SymmetricGroup(4),AlternatingGroup(5)];
    for con in content do
        path2:=Concatenation(path,con);
        content2:=DirectoryContents(path2);
        content2:=Filtered(content2,c-> not c in [".",".."] );
        for file in content2 do
            t:=SplitString(file,"_");
	    Print(file,"\n");
            path_to_file:=Concatenation(path2,"/",file);

            vof1:=[];vof2:=[];vof3:=[];vof4:=[];vof5:=[];vof6:=[];
            vof7:=[];vof8:=[];vof9:=[];vof10:=[];
            Read(path_to_file);
            temp:=[vof1,vof2,vof3,vof4,vof5,vof6,vof7,vof8,vof9,vof10];
            temp:=Filtered(temp,vof->vof <>[]);
            Print(Length(temp),"\n");
            for vof in temp do
                s:=SimplicialSurfaceByVerticesInFaces(vof);
                faceDegrees:=Set(FaceDegreesOfVertices(s));
                if EulerCharacteristic(s)<=-1 then 
                    if t[7]="6" then
                        resl:="regular";
                    elif Length(faceDegrees)=1 then
                        resl:="equivelar";
                    else
                        resl:="others";
                    fi;
                    oa:=Length(Set(vof))*Int(t[7]);
                    Print(oa, "\n");
                    if (oa mod 12 =0) or (oa mod 24 =0) or (oa mod 60 = 0) then
                        Print("we have to check\n");
                        aut:=AutomorphismGroupOnFaces(s);

                       conj:=List(ConjugacyClassesSubgroups(aut),Representative);
                        Print("computed subgroups/");
                        for i in [1,2,3] do
                            cand:=Filtered(conj,g->Order(g)=ord[i]);
                            cand:=Filtered(cand, g->IsIsomorphicGroup(g,groups[i]));
                            if Length(cand)>0 then
                                str:=Concatenation("surfaces_",con,"_",res_str[i],"_",resl);
                                AppendTo(str,VerticesOfFaces(s));
                                AppendTo(str,"\n\n");
                            fi;
                        od;
                   else
                          Print("order not nice\n");
                    fi;       
                fi;
            od;
            Unbind(vof1);Unbind(vof2);Unbind(vof3);
            Unbind(vof4);Unbind(vof5);Unbind(vof6);
            Unbind(vof7);Unbind(vof8);Unbind(vof9);Unbind(vof10);
        od;
    od;
    return true;
end;


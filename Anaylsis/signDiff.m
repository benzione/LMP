function [signScatter]=signDiff()
    signScatter=cell(16,1);

    signScatter(1)={'xk'};
    
    signScatter(2)={'*r'};
    signScatter(4)={'*c'};
    signScatter(7)={'*b'};    
    
    signScatter(3)={'sr'};
    signScatter(5)={'sc'};
    signScatter(10)={'sb'};
    
    signScatter(6)={'or'};
    signScatter(8)={'oc'};
    signScatter(9)={'ob'};
    signScatter(11)={'om'};
    
    signScatter(12)={'+r'};
    signScatter(13)={'+c'};
    signScatter(14)={'+b'};
    signScatter(15)={'+m'};
    signScatter(16)={'+g'};
end
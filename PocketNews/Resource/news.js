window.onload = function(){
    
    var o1 = document.getElementById('promotionCover');
    if(o1)
        o1.style.display='none';
    
    var o2 = document.getElementById('j_header');
    if(!o2)
        o2 = document.getElementById('j_artcileMain');
    o2.style.display='none';
    
    var cont = document.getElementById('artCont');
    if(!cont)
        cont = document.getElementById('j_articleContent');
    
    var oTitle = cont.getElementsByTagName('div')[0];
    var h2 = oTitle.getElementsByTagName('h2')[0];
    h2.style.color = 'red';
    alert(h2.innerText);

};
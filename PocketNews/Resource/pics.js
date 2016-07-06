var imgs = new Array();
window.onload = function(){
    var oPic = document.getElementById('pic_list');
    var aLi = document.getElementsByTagName('li');
    var srcs = '';
    for(var i=0;i<aLi.length;i++){
        var oLi = aLi[i];
        var oImg = oLi.getElementsByTagName('img')[0];
        if(oImg)
            imgs[i] = oImg.src;
        
    }
    alert(imgs);
    return imgs;
}
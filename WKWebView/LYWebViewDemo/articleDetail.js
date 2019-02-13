(function () {

    var  allAppViewImgsSrc;

    //视频播放事件
    function videoPlay() {
        event.preventDefault();
        var offset = this.getBoundingClientRect();

        window.appBridge({
            'data': {
                "videoID": this.children[0].getAttribute('data-video-id'),
                "videoType": this.children[0].getAttribute('data-video-type'),
                "videoTop": offset.top,
                "videoLeft": offset.left,
                "videoWidth": offset.width,
                "videoHeight": offset.height,
            },
            'apiName': 'showVideoPlayer'
        });
    }

    //为视频和gif添加播放标签
    function addPlayBtn() {
        var imgWrap,
            playElem;

        if (this.getAttribute('data-vsrc')) {
            imgWrap = this.parentNode;
            playElem = document.createElement('i');
            playElem.className = 'video_boxs_play';
            imgWrap.appendChild(playElem);
        } else if (this.getAttribute('data-src')) {
            imgWrap = this.parentNode;
            playElem = document.createElement('i');
            playElem.innerHTML = 'gif';
            playElem.className = 'gif_play';
            imgWrap.appendChild(playElem);
        }
        this.removeEventListener('load', addPlayBtn, false);
    }

    //加载图片
    function imgLoad(url) {
        
        var img = new Image(), _this = this;
        img.onload = function () {
            _this.src = img.src;

            img.onload = null;
            img = null;
            _this = null;
        };
        img.src = url;
    }
    //图片懒加载
    function imgLazyLoad() {
        var i, len,
            imgs, img,
            view;

        imgs = document.getElementsByTagName('img');
        view = {
            l: 0,
            t: 0,
            b: window.innerHeight || document.documentElement.clientHeight,
            r: window.innerWidth || document.documentElement.clientWidth
        };

        for (i = 0, len = imgs.length; i < len; i++) {
            img = imgs[i];
            if (!img.getAttribute('src')) {
                imgLoad.call(img, img.getAttribute('data-original'));
            }
        }
    }

    //处理所有img标签，对gif图根据网络状态特殊处理
    function gifHandle() {
        var i, len,
            img_nodes,
            img_node,
            dataSrc,
            originSrc,
            imgWrap;

        img_nodes = document.body.getElementsByTagName('img');
 
        for (i = 0, len = img_nodes.length; i < len; i++) {//只处理gif图
            img_node = img_nodes[i];
            dataSrc = img_node.getAttribute('data-src');
            originSrc = img_node.getAttribute('data-original');
            if (dataSrc && originSrc && dataSrc !== originSrc) {
                img_node.setAttribute("data-isgif", 1);
            }
            if (dataSrc && dataSrc !== originSrc) {
                imgWrap = document.createElement('div');
                imgWrap.className = 'gif_wrap';
                img_node.parentNode.replaceChild(imgWrap, img_node);
                imgWrap.appendChild(img_node);

                img_node.addEventListener('load', addPlayBtn, false);
                imgWrap.addEventListener('click', gifClickHandle, false);
            }
        }
 
        imgLazyLoad();
    }

    //页面执行调用的第一个方法
    function getNetWorkType(data) {
 
        handleAllImg();
        gifHandle();
    }

    //处理所有视频，将视频替换为首帧静态图片
    function handleAllImg() {
        var i, len;
        //处理video
        var video_template = '<img data-original="#{img_src}" data-video-type="#{vtype}" data-video-id="#{vid}" data-vsrc="#{video_src}" />';

        var video_nodes = document.body.getElementsByTagName('video'),
            videoWrap, video;
        if (video_nodes.length) {
            for (i = 0, len = video_nodes.length; i < len; i++) {
                video = video_nodes[0];
                video.pause();
                videoWrap = document.createElement('div');
                videoWrap.innerHTML = video_template.replace(/#{video_src}/g, video.getAttribute('src')).replace(/#{img_src}/g, video.getAttribute('poster')).
                    replace(/#\{vtype\}/g, video.getAttribute("data-video-type")).replace(/#\{vid\}/g, video.getAttribute("data-video-id"));
                video.parentNode.replaceChild(videoWrap, video);
                videoWrap.className = 'video_boxs';
                videoWrap.addEventListener('click', videoPlay, false);
                videoWrap.children[0].addEventListener('load', addPlayBtn, false);
            }
        }

        //处理所有图片
        var img_nodes = document.body.getElementsByTagName('img'),
            img_node,
            gifsrc,
            figur,
            figurText;

        len = img_nodes.length;
        if (len) {
            allAppViewImgsSrc = getNotVideoImgsSrc(img_nodes);

            for (i = 0; i < len; i++) {
                img_node = img_nodes[i];
                gifsrc = img_node.getAttribute('data-src');
                if (!img_node.getAttribute("data-vsrc")) { //video的缩略图，不当作点击浏览
                    if (!gifsrc || gifsrc === img_node.getAttribute('data-original')) { //没有data-src,不是老版内容，就是普通图片
                        img_node.addEventListener('click', imgAppView, false);
                    } else { //gif图
 
                        if (img_node.src === gifsrc) {//非wifi环境下，只有加载过的gif才能点击浏览
                            img_node.addEventListener('click', imgAppView, false);
                        }
 
                    }
                    //图注内容最多20字
                    figur = img_node.nextElementSibling;
                    if (figur) {
                        figurText = figur.innerHTML;
                        if (figurText.length < 21) {
                            figur.innerHTML = figurText.slice(0, 20);
                        }
                    }
                }
            }
        }
    }

    window.appBridge({
        'apiName': 'getNativeNetStatus',
        'callback': 'getNetWorkType'
    });



    //获取所有不是视频首帧的图片
    function getNotVideoImgsSrc(img_nodes) {
        var img_node,
            len, i,
            imgsSrcArr;

        len = img_nodes.length;

        if (len) {
            i = 0;
            imgsSrcArr = [];
            for (; i < len; i++) {
                img_node = img_nodes[i];
                //video的缩略图，不计算在内
                if (!img_node.getAttribute("data-vsrc")) {
                    imgsSrcArr.push(img_node.getAttribute('data-src') || img_node.getAttribute('data-original') || img_node.src);
                }
            }
        }
        return imgsSrcArr;
    }

    //注册app需要使用的js方法
    window.getNetWorkType = getNetWorkType;
    window.registJSBridge(getNetWorkType);

})();

function zoom_image(obj) {
    if (obj.hasClass('photoBox')) {
        //  var load = obj.find('.loadingBox');
        // load.show();
        var img = obj.next().find('img');
        if (img.attr('src') == 'about:blank') {
            img.attr('src', obj.find('img').attr('src').replace('170x110_', ''));
            img.load(function () {
                obj.hide();
                obj.next().show();
            });
        } else {
            obj.hide();
            obj.next().show();
        }
    } else {
        obj.hide();
        obj.prev().show();
        //  obj.prev().find('.loadingBox').hide();
    }
}

window.onload = function(){
    $(".miniimg").each(function () {
        $(this).bind('click', function (){
            zoom_image($(this).parent());
            //alert('33');
        });
    });
}

function setupWebViewJavascriptBridge(callback) {
    if (window.WebViewJavascriptBridge) { return callback(WebViewJavascriptBridge); }
    if (window.WVJBCallbacks) { return window.WVJBCallbacks.push(callback); }
    window.WVJBCallbacks = [callback];
    var WVJBIframe = document.createElement('iframe');
    WVJBIframe.style.display = 'none';
    WVJBIframe.src = 'wvjbscheme://__BRIDGE_LOADED__';
    document.documentElement.appendChild(WVJBIframe);
    setTimeout(function() { document.documentElement.removeChild(WVJBIframe) }, 0)
}

window.onerror = function (err) {
    console.log('window.onerror: ' + err)
}

setupWebViewJavascriptBridge(function(bridge) {

    /* Initialize your app here */

    $(".miniimg").each(function () {
        $(this).unbind().bind('click', function () {
            bridge.callHandler('imgCallback', $(this).attr('src').replace('170x110_', ''), function (response) {
                console.log("JS received response: ", response)
            })
            zoom_image($(this).parent())
        });
    });
    $(".maximg").each(function () {
        $(this).unbind().bind('click', function () {
            bridge.callHandler('imgCallback', $(this).attr('src').replace('170x110_', ''), function (response) {
                console.log("JS received response: ", response)
            })
        });
    });
})
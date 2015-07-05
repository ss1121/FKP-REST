var request = require('request');
// request for koa
var req = function(api,options){
    function rp(err, rep, body){   //deal with response result
        if(error)
            throw new Error("async search: no respons data");

        if (!error && response.statusCode == 200)
            return body;
    }

    return function(rp){
        request(api,rp);
    }
}

var path = require('path');
var libs = require('../libs/libs');
var qs = require('querystring');
var src = "http://120.25.223.175:5051/jh-web-portal/";


var apiPath = {
    base: src,
    dirs: {
        search: src+'search-json.html',
        user: src+'checkUserStatus.html'
    }
}

//搜索
function *getSearch(param){
    libs.elog('javaapi/getSearch')

    var url = apiPath.dirs.search;
    var query = qs.stringify(param);

    if(libs.getObjType(param)!=='Object')
        return yield req(url);

    return yield req(url+'?'+query);
}

//用户
function *getUser(param){
    libs.elog('javaapi/getUser')

    var url = apiPath.dirs.user;
    var query = qs.stringify(param);

    if(libs.getObjType(param)!=='Object')
        return yield req(url);

    return yield req(url+'?'+query);
}

function *getInfo(param){

}

function *getGood(param){

}

function *getArticle(param){

}

module.exports = {
    req: request,
    search: getSearch,
    infos: getInfo,
    goods: getGood,
    article: getArticle,
    user: getUser
}
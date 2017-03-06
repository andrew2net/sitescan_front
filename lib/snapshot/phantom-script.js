var page = require('webpage').create(),
    system = require('system'),
    url;
url = system.args[1];
if (url.match(/bestbuy.com/)){
  page.customHeaders = {
    'x-employment': "I'v read. If you consider a foreing employee I will consider job at BestBuy.com :)"
  }
  page.settings.userAgent = 'Faraday v0.9.2';
}else{
  page.settings.userAgent = 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_10_5) AppleWebKit/601.1.54 (KHTML, like Gecko) Version/9.0 Safari/601.1.54';
}
page.settings.loadImages = false;
var lastTime = new Date().getTime();
page.onResourceRequested = function(req){
  lastTime = new Date().getTime();
}
page.omResourceReceived = function(res){
  lastTime = new Date().getTime();
}
page.open(url, function(status){
  page.evaluate(function(){
    var elements = document.querySelectorAll('meta[name=fragment], script');
    for (i=0; i<elements.length; i++){
      elements[i].parentNode.removeChild(elements[i]);
    }
  });
  if (status == 'success'){
    var interval = setInterval(function(){
      var currentTime = new Date().getTime();
      if(currentTime - lastTime > 3000){
        system.stdout.write(page.content);
        clearInterval(interval);
        phantom.exit();
      }
    }, 100);
  }else{
    system.stderr.write(status);
    phantom.exit();
  }
});

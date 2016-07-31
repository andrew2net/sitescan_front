var page = require('webpage').create(),
    system = require('system');
var url = system.args[1];
page.settings.userAgent = 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_10_5) AppleWebKit/601.1.54 (KHTML, like Gecko) Version/9.0 Safari/601.1.54';
page.settings.loadImages = false;
page.open(url, function(status){
  page.evaluate(function(){
    var elements = document.querySelectorAll('meta[name=fragment], script');
    for (i=0; i<elements.length; i++){
      elements[i].parentNode.removeChild(elements[i]);
    }
  });
  console.log(page.content);
  // console.log(status);
  phantom.exit();
});

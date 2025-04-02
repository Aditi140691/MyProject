function fn()
{
    var getProperties = Java.type('MyProject.Util.PropertyLoader');
    var gp = new getProperties();
    var platformConfig = gp.getPlatform();
    var environmentConfig = gp.getEnvironment();
    var browserConfig = gp.getBrowser();
    var osConfig = gp.getOs();
 
    var platform = karate.properties['platform'] ? karate.properties['platform'] : platformConfig;
    var environment = karate.env ? karate.env : environmentConfig;
    var browser = karate.properties['browser'] ? karate.properties['browser'] : browserConfig;
    var os = karate.properties['os'] ? karate.properties['os'] : osConfig;
 
    console.log('Platform is '+platform);
    console.log('OS is '+os);
    console.log('Env is '+environment);
    console.log('Browser is '+browser);
 
    var lambdaHooks = function()
    {
        if(karate.info.errorMessage){
                script('lambda-status=failed');
        }else{
                script('lambda-status=passed');
        }
    }
        if (browser.toLowerCase() == "chrome"){
            var driverPath = karate.properties['user.dir']+'\\drivers\\chromedriver.exe';
            karate.configure('driver', { type: 'chromedriver', executable: driverPath, httpConfig: { readTimeout: 120000 }} );
            var session = { capabilities: { alwaysMatch: { browserName: 'chrome', 'goog:chromeOptions': { args: [ '--headless', 'window-size=1280,720' ] } } } }
        } else if (browser.toLowerCase() == "firefox"){
            var driverPath = karate.properties['user.dir']+'\\drivers\\geckodriver.exe';
            karate.configure('driver', { type: 'geckodriver', executable: driverPath});
            var session = { capabilities: { alwaysMatch: { browserName: 'firefox', 'moz:firefoxOptions': { args: [ '--headless', 'window-size=1280,720' ] } } } }
        }
    }
 
    if(environment.toLowerCase() == 'qa'){
        var config = { // This is base config JSON which will be returned
            testUrl: "http://Saucedemo.com",
            apiUrl: "https://regres.in/"
        }
    }else if(environment.toLowerCase() == 'stage'){
 
        var config = { // This is base config JSON which will be returned
       
        }
    }
    karate.configure('ssl', true);
    return config;
}
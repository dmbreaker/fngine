﻿package base.externals
{

    /*

        Usage:

            MochiBot.track(this, "XXXXXXXX");

    */
    import flash.display.DisplayObject;
    import flash.display.Sprite;
    import flash.display.Loader;
    import flash.system.Security;
    import flash.system.Capabilities;
    import flash.net.URLRequest;
    import flash.net.URLRequestMethod;
    import flash.net.URLVariables;

    public dynamic class MochiBot extends Sprite
	{

        public static function track(parent:Sprite, tag:String):MochiBot
		{
			try
			{
				if (Security.sandboxType == "localWithFile")
				{
					trace( "[MochiBot] Sandbox: localWithFile" );
					return null;
				}
				var self:MochiBot = new MochiBot();
				parent.addChild(self);
				Security.allowDomain("*");
				Security.allowInsecureDomain("*");
				var server:String = "http://core.mochibot.com/my/core.swf";
				var lv:URLVariables = new URLVariables();
				lv["sb"] = Security.sandboxType;
				lv["v"] = Capabilities.version;
				lv["swfid"] = tag;
				lv["mv"] = "8";
				lv["fv"] = "9";
				var url:String = self.root.loaderInfo.loaderURL;
				if (url.indexOf("http") == 0) {
					lv["url"] = url;
				} else {
					lv["url"] = "local";
				}
				var req:URLRequest = new URLRequest(server);
				req.contentType = "application/x-www-form-urlencoded";
				req.method = URLRequestMethod.POST;
				req.data = lv;
				var loader:Loader = new Loader();
				self.addChild(loader);
				loader.load(req);
				return self;
			}
			catch (e:Error)
			{
				trace( "[MochiBOT] Error(" + e.errorID +": " + e.message );
				return null;
			}
			return null;
        }

    }

}

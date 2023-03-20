/*
 *  Copyright 2019 Tua Rua Ltd.
 *
 *  Licensed under the Apache License, Version 2.0 (the "License");
 *  you may not use this file except in compliance with the License.
 *  You may obtain a copy of the License at
 *
 *  http://www.apache.org/licenses/LICENSE-2.0
 *
 *  Unless required by applicable law or agreed to in writing, software
 *  distributed under the License is distributed on an "AS IS" BASIS,
 *  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 *  See the License for the specific language governing permissions and
 *  limitations under the License.
 */

package com.tuarua {
import com.tuarua.applesignin.AppleIDCredential;
import com.tuarua.applesignin.PasswordCredential;
import com.tuarua.applesignin.events.AppleSignInErrorEvent;
import com.tuarua.applesignin.events.AppleSignInEvent;
import com.tuarua.fre.ANEUtils;

import flash.events.StatusEvent;
import flash.external.ExtensionContext;
import flash.utils.Dictionary;

/** @private */
public class AppleSignInANEContext {
    internal static const NAME:String = "AppleSignInANE";
    internal static const TRACE:String = "TRACE";
    private static var _context:ExtensionContext;
    public static var callbacks:Dictionary = new Dictionary();
    private static var argsAsJSON:Object;

    private static const CREDENTIAL_STATE:String = "AppleSignInANE.OnCredentialState";

    public function AppleSignInANEContext() {
    }

    public static function get context():ExtensionContext {
        if (_context == null) {
            try {
                _context = ExtensionContext.createExtensionContext("com.tuarua." + NAME, null);
                _context.addEventListener(StatusEvent.STATUS, gotEvent);
            } catch (e:Error) {
                trace("[" + NAME + "] ANE not loaded properly.  Future calls will fail.");
            }
        }
        return _context;
    }

    public static function createCallback(listener:Function):String {
        var id:String;
        if (listener != null) {
            id = context.call("createGUID") as String;
            callbacks[id] = listener;
        }
        return id;
    }

    public static function callCallback(callbackId:String, ...args):void {
        var callback:Function = callbacks[callbackId];
        if (callback == null) return;
        callback.apply(null, args);
        delete callbacks[callbackId];
    }

    private static function gotEvent(event:StatusEvent):void {
        var error:Error;
        switch (event.level) {
            case TRACE:
                trace("[" + NAME + "]", event.code);
                break;
            case AppleSignInErrorEvent.ERROR:
                try {
                    argsAsJSON = JSON.parse(event.code);
                    if (argsAsJSON.hasOwnProperty("error")) {
                        error = new Error(argsAsJSON.error.message, argsAsJSON.error.code);
                        AppleSignIn.shared().dispatchEvent(new AppleSignInErrorEvent(event.level, error));
                    }
                } catch (e:Error) {
                    trace(e.toString())
                }
                break;
            case AppleSignInEvent.SUCCESS:
                try {
                    argsAsJSON = JSON.parse(event.code);
                    if (argsAsJSON.hasOwnProperty("appleIDCredential")) {
                        AppleSignIn.shared().dispatchEvent(new AppleSignInEvent(event.level,
                                ANEUtils.map(argsAsJSON.appleIDCredential, AppleIDCredential) as AppleIDCredential));
                    } else {
                        AppleSignIn.shared().dispatchEvent(new AppleSignInEvent(event.level,
                                null, ANEUtils.map(argsAsJSON.passwordCredential, PasswordCredential) as PasswordCredential));
                    }
                } catch (e:Error) {
                    trace(e.toString())
                }
                break;
            case CREDENTIAL_STATE:
                argsAsJSON = JSON.parse(event.code);
                var state:int = -1;
                if (argsAsJSON.hasOwnProperty("error") && argsAsJSON.error) {
                    error = new Error(argsAsJSON.error.message, argsAsJSON.error.code);
                } else if (argsAsJSON.hasOwnProperty("credentialState") && argsAsJSON.credentialState) {
                    state = argsAsJSON.credentialState;
                }
                callCallback(argsAsJSON.callbackId, state, error);
                break;
        }
    }

    public static function dispose():void {
        if (!_context) return;
        trace("[" + NAME + "] Unloading ANE...");
        _context.removeEventListener(StatusEvent.STATUS, gotEvent);
        _context.dispose();
        _context = null;
    }
}
}

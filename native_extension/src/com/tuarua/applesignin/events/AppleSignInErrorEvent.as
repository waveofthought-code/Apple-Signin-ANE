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

package com.tuarua.applesignin.events {
import flash.events.Event;

public class AppleSignInErrorEvent extends Event {
    public static const ERROR:String = "AppleSignInANE.OnError";
    public var error:Error;

    /** @private */
    public function AppleSignInErrorEvent(type:String, error:Error = null,
                                          bubbles:Boolean = false, cancelable:Boolean = false) {
        super(type, bubbles, cancelable);
        this.error = error;
    }

    public override function clone():Event {
        return new AppleSignInErrorEvent(type, this.error, bubbles, cancelable);
    }

    public override function toString():String {
        return formatToString("AppleSignInErrorEvent", "type", "error", "type", "bubbles", "cancelable");
    }
}
}

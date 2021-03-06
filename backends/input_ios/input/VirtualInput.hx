/*
 * Copyright (c) 2003-2015, GameDuell GmbH
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 *
 * 1. Redistributions of source code must retain the above copyright notice,
 * this list of conditions and the following disclaimer.
 *
 * 2. Redistributions in binary form must reproduce the above copyright notice,
 * this list of conditions and the following disclaimer in the documentation
 * and/or other materials provided with the distribution.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
 * ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
 * WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.
 * IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY
 * DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
 * LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
 * ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 * SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

package input;

import cpp.Lib;
import haxe.ds.Vector;
import msignal.Signal;

class VirtualInput
{
    private static var initializeNative = Lib.load("input_ios", "input_ios_text_create_textfieldwrapper", 2);
    private static var showKeyboardNative = Lib.load("input_ios", "input_ios_text_show_keyboard", 1);
    private static var hideKeyboardNative = Lib.load("input_ios", "input_ios_text_hide_keyboard", 1);
    private static var setAllowedCharCodesNative = Lib.load("input_ios", "input_ios_text_set_allowed_char_codes", 2);
    private static var setTextNative = Lib.load("input_ios", "input_ios_text_set_text", 2);

    public var onInputStarted(default, null): Signal0;
    public var onInputEnded(default, null): Signal0;
    public var onTextChanged(default, null): Signal1<String>;

    public var text(default, set): String;

    public var allowedCharCodes(never, set): Vector<Bool>;

    private var obj: Dynamic;

    private function new(charCodes: Vector<Bool>)
    {
        onInputStarted = new Signal0();
        onInputEnded = new Signal0();
        onTextChanged = new Signal1();

        obj = initializeNative(onInputEnded.dispatch, set_text);

        text = "";
        allowedCharCodes = charCodes;
    }

    private function show(): Bool
    {
        var result: Bool = showKeyboardNative(obj);

        if (result)
        {
            onInputStarted.dispatch();
        }

        return false;
    }

    private function hide(): Bool
    {
        // callback handled natively
        hideKeyboardNative(obj);

        return false;
    }

    private function set_text(value: String): String
    {
        if (text != value)
        {
            setTextNative(obj, value);

            text = value;

            onTextChanged.dispatch(value);
        }

        return value;
    }

    private function set_allowedCharCodes(value: Vector<Bool>): Vector<Bool>
    {
        setAllowedCharCodesNative(obj, value);

        return value;
    }
}

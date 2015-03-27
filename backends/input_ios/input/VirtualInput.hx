/*
 * Copyright (c) 2003-2015 GameDuell GmbH, All Rights Reserved
 * This document is strictly confidential and sole property of GameDuell GmbH, Berlin, Germany
 */
package input;

import cpp.Lib;
import haxe.ds.Vector;
import msignal.Signal;

/**
    @author jxav
 */
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